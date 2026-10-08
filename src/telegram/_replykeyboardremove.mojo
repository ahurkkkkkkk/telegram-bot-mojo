#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ReplyKeyboardRemove.
# LGPL-3.0-or-later; see LICENSE.

"""Request removal of a custom reply keyboard."""

from std.collections.optional import Optional

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ReplyKeyboardRemove(Copyable, TelegramJsonObject):
    var remove_keyboard: Bool
    var selective: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, selective: Optional[Bool] = None):
        self.remove_keyboard = True
        self.selective = selective
        self.api_kwargs = empty_json_object()

    def __init__(out self, selective: Optional[Bool], api_kwargs: JsonDocument):
        self.remove_keyboard = True
        self.selective = selective
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.remove_keyboard = existing.remove_keyboard
        self.selective = existing.selective
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "remove_keyboard", self.remove_keyboard)
        if self.selective is not None:
            result.set_boolean(result.root, "selective", self.selective.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ReplyKeyboardRemove JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ReplyKeyboardRemove JSON value is not an object")
        var selective: Optional[Bool] = None
        var selective_index = data.object_get(data.root, "selective")
        if selective_index != -1 and not data.is_null(selective_index):
            selective = Optional[Bool](data.boolean_value(selective_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "remove_keyboard" and key != "selective":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ReplyKeyboardRemove(selective, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ReplyKeyboardRemove.de_json(items[index].copy()))
        return result^
