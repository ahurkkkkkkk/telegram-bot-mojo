#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""A bot's public display name."""

from telegram._telegramobject import TelegramJsonObject
from telegram import constants
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from std.hashlib.hasher import Hasher


def _empty_api_kwargs() -> JsonDocument:
    var document = JsonDocument()
    document.root = document.add_object()
    return document^


struct BotName(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a bot name; equality is based on ``name``."""

    var name: String
    var api_kwargs: JsonDocument

    comptime MAX_LENGTH = constants.BotNameLimit.MAX_NAME_LENGTH.value

    def __init__(out self, name: String):
        self.name = name
        self.api_kwargs = _empty_api_kwargs()

    def __init__(out self, name: String, api_kwargs: JsonDocument):
        self.name = name
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.name.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = _empty_api_kwargs()
        result.set_string(result.root, "name", self.name)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BotName JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BotName JSON value is not an object")
        var name_node = data.object_get(data.root, "name")
        if name_node == -1:
            raise Error("BotName JSON object is missing 'name'")
        var name = data.string_value(name_node)
        var api_kwargs = _empty_api_kwargs()
        var child = data.nodes[data.root].first_child
        while child != -1:
            if data.nodes[child].name != "name":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, data.nodes[child].name.copy(), copied)
            child = data.nodes[child].next_sibling
        return BotName(name, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotName.de_json(items[index].copy()))
        return result^
