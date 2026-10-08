#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQuery.
# LGPL-3.0-or-later; see LICENSE.

"""A user's inline query, with JSON conversion and source identity semantics."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.location import Location
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryLimit


struct InlineQuery(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Incoming inline query; equality is based only on its unique id."""

    comptime MAX_RESULTS = InlineQueryLimit.RESULTS.value
    comptime MAX_OFFSET_LENGTH = InlineQueryLimit.MAX_OFFSET_LENGTH.value
    comptime MAX_QUERY_LENGTH = InlineQueryLimit.MAX_QUERY_LENGTH.value

    var id: String
    var from_user: User
    var query: String
    var offset: String
    var location: Optional[Location]
    var chat_type: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        from_user: User,
        query: String,
        offset: String,
        location: Optional[Location] = None,
        chat_type: Optional[String] = None,
    ):
        self.id = id.copy()
        self.from_user = from_user.copy()
        self.query = query.copy()
        self.offset = offset.copy()
        self.location = location.copy()
        self.chat_type = chat_type.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        from_user: User,
        query: String,
        offset: String,
        location: Optional[Location] = None,
        chat_type: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id.copy()
        self.from_user = from_user.copy()
        self.query = query.copy()
        self.offset = offset.copy()
        self.location = location.copy()
        self.chat_type = chat_type.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.from_user = existing.from_user.copy()
        self.query = existing.query.copy()
        self.offset = existing.offset.copy()
        self.location = existing.location.copy()
        self.chat_type = existing.chat_type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQuery\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "id", self.id)
        var from_data = self.from_user.to_dict(recursive)
        var from_node = result.copy_subtree_from(from_data, from_data.root)
        result.object_set(result.root, "from", from_node)
        result.set_string(result.root, "query", self.query)
        result.set_string(result.root, "offset", self.offset)
        if self.location is not None:
            var location_data = self.location.value().to_dict(recursive)
            var location_node = result.copy_subtree_from(location_data, location_data.root)
            result.object_set(result.root, "location", location_node)
        if self.chat_type is not None:
            result.set_string(result.root, "chat_type", self.chat_type.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQuery JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var from_index = data.object_get(data.root, "from")
        var query_index = data.object_get(data.root, "query")
        var offset_index = data.object_get(data.root, "offset")
        if id_index == -1 or from_index == -1 or query_index == -1 or offset_index == -1:
            raise Error("InlineQuery JSON object is missing a required field")

        var from_data = JsonDocument()
        from_data.root = from_data.copy_subtree_from(data, from_index)
        var from_user = User.de_json(from_data)

        var location: Optional[Location] = None
        var location_index = data.object_get(data.root, "location")
        if location_index != -1 and not data.is_null(location_index):
            var location_data = JsonDocument()
            location_data.root = location_data.copy_subtree_from(data, location_index)
            location = Optional[Location](Location.de_json(location_data))

        var chat_type: Optional[String] = None
        var chat_type_index = data.object_get(data.root, "chat_type")
        if chat_type_index != -1 and not data.is_null(chat_type_index):
            chat_type = Optional[String](data.string_value(chat_type_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "id" and key != "from" and key != "query" and key != "offset" and
                key != "location" and key != "chat_type"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQuery(
            data.string_value(id_index), from_user, data.string_value(query_index),
            data.string_value(offset_index), location, chat_type, api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQuery.de_json(items[index].copy()))
        return result^
