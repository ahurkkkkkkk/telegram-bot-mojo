#!/usr/bin/env mojo
#
# Native Mojo translation of CallbackQuery's data model from PTB v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""A callback query with user identity and an optional message payload."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._user import User
from telegram._message import MaybeInaccessibleMessage
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _callback_query_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


struct CallbackQuery(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native CallbackQuery data fields; equality follows upstream and uses the query ID."""

    comptime MAX_ANSWER_TEXT_LENGTH = 200

    var id: String
    var from_user: User
    var chat_instance: String
    var message: Optional[MaybeInaccessibleMessage]
    var data: Optional[String]
    var inline_message_id: Optional[String]
    var game_short_name: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        from_user: User,
        chat_instance: String,
        message: Optional[MaybeInaccessibleMessage] = None,
        data: Optional[String] = None,
        inline_message_id: Optional[String] = None,
        game_short_name: Optional[String] = None,
    ):
        self.id = id.copy()
        self.from_user = from_user.copy()
        self.chat_instance = chat_instance.copy()
        self.message = message.copy()
        self.data = data.copy()
        self.inline_message_id = inline_message_id.copy()
        self.game_short_name = game_short_name.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        from_user: User,
        chat_instance: String,
        message: Optional[MaybeInaccessibleMessage] = None,
        data: Optional[String] = None,
        inline_message_id: Optional[String] = None,
        game_short_name: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id.copy()
        self.from_user = from_user.copy()
        self.chat_instance = chat_instance.copy()
        self.message = message.copy()
        self.data = data.copy()
        self.inline_message_id = inline_message_id.copy()
        self.game_short_name = game_short_name.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.from_user = existing.from_user.copy()
        self.chat_instance = existing.chat_instance.copy()
        self.message = existing.message.copy()
        self.data = existing.data.copy()
        self.inline_message_id = existing.inline_message_id.copy()
        self.game_short_name = existing.game_short_name.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "chat_instance", self.chat_instance)
        if self.data is not None:
            result.set_string(result.root, "data", self.data.value())
        result.set_string(result.root, "id", self.id)
        if self.game_short_name is not None:
            result.set_string(result.root, "game_short_name", self.game_short_name.value())
        if self.inline_message_id is not None:
            result.set_string(result.root, "inline_message_id", self.inline_message_id.value())
        if self.message is not None:
            var nested = self.message.value().to_dict(recursive=recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "message", nested_index)
        var user_data = self.from_user.to_dict(recursive)
        var user_index = result.copy_subtree_from(user_data, user_data.root)
        result.object_set(result.root, "from", user_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> CallbackQuery:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("CallbackQuery JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var from_index = data.object_get(data.root, "from")
        var chat_instance_index = data.object_get(data.root, "chat_instance")
        if id_index == -1 or from_index == -1 or chat_instance_index == -1:
            raise Error("CallbackQuery JSON object is missing a required field")
        var id = data.string_value(id_index)
        var from_data = _callback_query_nested(data, from_index)
        var from_user = User.de_json(from_data)
        var chat_instance = data.string_value(chat_instance_index)

        var message: Optional[MaybeInaccessibleMessage] = None
        var index = data.object_get(data.root, "message")
        if index != -1 and not data.is_null(index):
            message = Optional[MaybeInaccessibleMessage](
                MaybeInaccessibleMessage.de_json(_callback_query_nested(data, index))
            )
        var query_data: Optional[String] = None
        index = data.object_get(data.root, "data")
        if index != -1 and not data.is_null(index):
            query_data = Optional[String](data.string_value(index))
        var inline_message_id: Optional[String] = None
        index = data.object_get(data.root, "inline_message_id")
        if index != -1 and not data.is_null(index):
            inline_message_id = Optional[String](data.string_value(index))
        var game_short_name: Optional[String] = None
        index = data.object_get(data.root, "game_short_name")
        if index != -1 and not data.is_null(index):
            game_short_name = Optional[String](data.string_value(index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "id" or key == "from" or key == "chat_instance" or key == "message" or
                key == "data" or key == "inline_message_id" or key == "game_short_name"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return CallbackQuery(
            id,
            from_user,
            chat_instance,
            message,
            query_data,
            inline_message_id,
            game_short_name,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[CallbackQuery]:
        var items = data.array_documents(array_index)
        var result = List[CallbackQuery]()
        for index in range(len(items)):
            result.append(CallbackQuery.de_json(items[index].copy()))
        return result^
