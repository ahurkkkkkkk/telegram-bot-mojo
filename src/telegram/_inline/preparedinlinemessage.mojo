#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 PreparedInlineMessage.
# LGPL-3.0-or-later; see LICENSE.

"""An inline message prepared for sending from a Telegram Mini App."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct PreparedInlineMessage(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Prepared inline message metadata; equality follows the upstream id identity."""

    var id: String
    var expiration_date: TimestampDateTime
    var api_kwargs: JsonDocument

    def __init__(out self, id: String, expiration_date: TimestampDateTime):
        self.id = id.copy()
        self.expiration_date = expiration_date.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        expiration_date: TimestampDateTime,
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id.copy()
        self.expiration_date = expiration_date.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.expiration_date = existing.expiration_date.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PreparedInlineMessage\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "expiration_date", String(to_timestamp(self.expiration_date)))
        result.set_string(result.root, "id", self.id)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if (
            data.root < 0
            or data.root >= len(data.nodes)
            or data.nodes[data.root].kind != JSON_OBJECT
        ):
            raise Error("PreparedInlineMessage JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var expiration_index = data.object_get(data.root, "expiration_date")
        if id_index == -1 or expiration_index == -1:
            raise Error("PreparedInlineMessage JSON object is missing a required field")
        var id = data.string_value(id_index)
        var expiration_date = from_timestamp(data.integer_value(expiration_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "id" and key != "expiration_date":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return PreparedInlineMessage(id, expiration_date, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(PreparedInlineMessage.de_json(items[index].copy()))
        return result^
