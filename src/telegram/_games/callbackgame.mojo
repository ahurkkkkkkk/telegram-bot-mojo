#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 CallbackGame.
# LGPL-3.0-or-later; see LICENSE.

"""Placeholder for a callback game, retaining any API extension fields."""

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct CallbackGame(Copyable, TelegramJsonObject):
    var api_kwargs: JsonDocument

    def __init__(out self):
        self.api_kwargs = empty_json_object()

    def __init__(out self, api_kwargs: JsonDocument):
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.api_kwargs.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("CallbackGame JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("CallbackGame JSON value is not an object")
        return CallbackGame(data)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(CallbackGame.de_json(items[index].copy()))
        return result^
