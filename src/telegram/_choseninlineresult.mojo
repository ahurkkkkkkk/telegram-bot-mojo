#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ChosenInlineResult.
# LGPL-3.0-or-later; see LICENSE.

"""A result selected by a user from an inline query."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.location import Location
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ChosenInlineResult(Equatable, Hashable, Copyable, TelegramJsonObject):
    """An inline selection, identified by result ID."""

    var result_id: String
    var from_user: User
    var location: Optional[Location]
    var inline_message_id: Optional[String]
    var query: String
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        result_id: String,
        from_user: User,
        query: String,
        location: Optional[Location] = None,
        inline_message_id: Optional[String] = None,
    ):
        self.result_id = result_id.copy()
        self.from_user = from_user.copy()
        self.location = location.copy()
        self.inline_message_id = inline_message_id
        self.query = query.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        result_id: String,
        from_user: User,
        query: String,
        location: Optional[Location] = None,
        inline_message_id: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.result_id = result_id.copy()
        self.from_user = from_user.copy()
        self.location = location.copy()
        self.inline_message_id = inline_message_id
        self.query = query.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.result_id = existing.result_id.copy()
        self.from_user = existing.from_user.copy()
        self.location = existing.location.copy()
        self.inline_message_id = existing.inline_message_id
        self.query = existing.query.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.result_id == other.result_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.result_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "result_id", self.result_id)
        var user = self.from_user.to_dict(recursive=recursive)
        var user_node = result.copy_subtree_from(user, user.root)
        result.object_set(result.root, "from", user_node)
        if self.location is not None:
            var location = self.location.value().to_dict(recursive=recursive)
            var location_node = result.copy_subtree_from(location, location.root)
            result.object_set(result.root, "location", location_node)
        if self.inline_message_id is not None:
            result.set_string(result.root, "inline_message_id", self.inline_message_id.value())
        result.set_string(result.root, "query", self.query)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChosenInlineResult JSON value is not an object")
        var result_id_index = data.object_get(data.root, "result_id")
        var user_index = data.object_get(data.root, "from")
        var query_index = data.object_get(data.root, "query")
        if result_id_index == -1 or user_index == -1 or query_index == -1:
            raise Error("ChosenInlineResult JSON object is missing a required field")
        var result_id = data.string_value(result_id_index)
        var user_document = JsonDocument()
        user_document.root = user_document.copy_subtree_from(data, user_index)
        var from_user = User.de_json(user_document)
        var query = data.string_value(query_index)
        var location: Optional[Location] = None
        var location_index = data.object_get(data.root, "location")
        if location_index != -1 and not data.is_null(location_index):
            var location_document = JsonDocument()
            location_document.root = location_document.copy_subtree_from(data, location_index)
            location = Optional[Location](Location.de_json(location_document))
        var inline_message_id: Optional[String] = None
        var inline_message_id_index = data.object_get(data.root, "inline_message_id")
        if inline_message_id_index != -1 and not data.is_null(inline_message_id_index):
            inline_message_id = Optional[String](data.string_value(inline_message_id_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "result_id" and key != "from" and key != "query" and key != "location" and key != "inline_message_id":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChosenInlineResult(
            result_id,
            from_user,
            query,
            location,
            inline_message_id,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ChosenInlineResult.de_json(items[index].copy()))
        return result^
