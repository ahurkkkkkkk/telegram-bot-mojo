#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResult.
# LGPL-3.0-or-later; see LICENSE.

"""Shared inline-query result identity and JSON fields."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultLimit


struct InlineQueryResult(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Base result data; identity is the result id."""

    comptime MIN_ID_LENGTH = InlineQueryResultLimit.MIN_ID_LENGTH.value
    comptime MAX_ID_LENGTH = InlineQueryResultLimit.MAX_ID_LENGTH.value

    var type: String
    var id: String
    var api_kwargs: JsonDocument

    def __init__(out self, type: String, id: String):
        self.type = type.copy()
        self.id = id.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: String, id: String, *, api_kwargs: JsonDocument):
        self.type = type.copy()
        self.id = id.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResult\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResult JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        var id_index = data.object_get(data.root, "id")
        if type_index == -1 or id_index == -1:
            raise Error("InlineQueryResult JSON object is missing type or id")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type" and key != "id":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResult(
            data.string_value(type_index), data.string_value(id_index), api_kwargs=api_kwargs
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResult.de_json(items[index].copy()))
        return result^
