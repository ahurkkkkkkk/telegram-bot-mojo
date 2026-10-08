#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 message-origin models.
# LGPL-3.0-or-later; see LICENSE.

"""Original sender information for forwarded Telegram messages."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _origin_require_object(data: JsonDocument) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("MessageOrigin JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("MessageOrigin JSON value is not an object")


def _origin_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("MessageOrigin JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _origin_api_kwargs(data: JsonDocument, type: String) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var is_model_field = key == "type" or key == "date"
        if type == "user":
            is_model_field = is_model_field or key == "sender_user"
        elif type == "hidden_user":
            is_model_field = is_model_field or key == "sender_user_name"
        elif type == "chat":
            is_model_field = is_model_field or key == "sender_chat" or key == "author_signature"
        elif type == "channel":
            is_model_field = is_model_field or key == "chat" or key == "message_id" or key == "author_signature"
        if not is_model_field:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct MessageOrigin(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Tagged value for known and future message-origin discriminators."""

    comptime USER = "user"
    comptime HIDDEN_USER = "hidden_user"
    comptime CHAT = "chat"
    comptime CHANNEL = "channel"

    var type: String
    var date: TimestampDateTime
    var sender_user: Optional[User]
    var sender_user_name: Optional[String]
    var sender_chat: Optional[Chat]
    var chat: Optional[Chat]
    var message_id: Optional[Int]
    var author_signature: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, type: String, date: TimestampDateTime):
        self.type = type.copy()
        self.date = date.copy()
        self.sender_user = None
        self.sender_user_name = None
        self.sender_chat = None
        self.chat = None
        self.message_id = None
        self.author_signature = None
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: String, date: TimestampDateTime, *, api_kwargs: JsonDocument):
        self.type = type.copy()
        self.date = date.copy()
        self.sender_user = None
        self.sender_user_name = None
        self.sender_chat = None
        self.chat = None
        self.message_id = None
        self.author_signature = None
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.date = existing.date.copy()
        self.sender_user = existing.sender_user.copy()
        self.sender_user_name = existing.sender_user_name
        self.sender_chat = existing.sender_chat.copy()
        self.chat = existing.chat.copy()
        self.message_id = existing.message_id
        self.author_signature = existing.author_signature
        self.api_kwargs = existing.api_kwargs.copy()

    @staticmethod
    def user(date: TimestampDateTime, sender_user: User) -> Self:
        var result = Self(Self.USER, date)
        result.sender_user = Optional[User](sender_user.copy())
        return result^

    @staticmethod
    def hidden_user(date: TimestampDateTime, sender_user_name: String) -> Self:
        var result = Self(Self.HIDDEN_USER, date)
        result.sender_user_name = Optional[String](sender_user_name.copy())
        return result^

    @staticmethod
    def chat_origin(
        date: TimestampDateTime,
        sender_chat: Chat,
        author_signature: Optional[String] = None,
    ) -> Self:
        var result = Self(Self.CHAT, date)
        result.sender_chat = Optional[Chat](sender_chat.copy())
        result.author_signature = author_signature
        return result^

    @staticmethod
    def channel(
        date: TimestampDateTime,
        chat: Chat,
        message_id: Int,
        author_signature: Optional[String] = None,
    ) -> Self:
        var result = Self(Self.CHANNEL, date)
        result.chat = Optional[Chat](chat.copy())
        result.message_id = Optional[Int](message_id)
        result.author_signature = author_signature
        return result^

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.date == other.date

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.date)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        if self.type == Self.USER and self.sender_user is not None:
            var user_document = self.sender_user.value().to_dict(recursive=recursive)
            var user_index = result.copy_subtree_from(user_document, user_document.root)
            result.object_set(result.root, "sender_user", user_index)
        elif self.type == Self.HIDDEN_USER and self.sender_user_name is not None:
            result.set_string(result.root, "sender_user_name", self.sender_user_name.value())
        elif self.type == Self.CHAT:
            if self.sender_chat is not None:
                var sender_document = self.sender_chat.value().to_dict(recursive=recursive)
                var sender_index = result.copy_subtree_from(sender_document, sender_document.root)
                result.object_set(result.root, "sender_chat", sender_index)
            if self.author_signature is not None:
                result.set_string(result.root, "author_signature", self.author_signature.value())
        elif self.type == Self.CHANNEL:
            if self.chat is not None:
                var chat_document = self.chat.value().to_dict(recursive=recursive)
                var chat_index = result.copy_subtree_from(chat_document, chat_document.root)
                result.object_set(result.root, "chat", chat_index)
            if self.message_id is not None:
                result.set_number(result.root, "message_id", String(self.message_id.value()))
            if self.author_signature is not None:
                result.set_string(result.root, "author_signature", self.author_signature.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _origin_require_object(data)
        var type_index = data.object_get(data.root, "type")
        var date_index = data.object_get(data.root, "date")
        if type_index == -1 or date_index == -1 or data.is_null(type_index) or data.is_null(date_index):
            raise Error("MessageOrigin JSON object is missing type or date")
        var kind = data.string_value(type_index)
        var result = MessageOrigin(
            kind,
            from_timestamp(data.integer_value(date_index)),
            api_kwargs=_origin_api_kwargs(data, kind),
        )
        if kind == Self.USER:
            var user_index = data.object_get(data.root, "sender_user")
            if user_index == -1 or data.is_null(user_index):
                raise Error("MessageOrigin user is missing sender_user")
            result.sender_user = Optional[User](
                User.de_json(_origin_nested(data, user_index)).copy()
            )
        elif kind == Self.HIDDEN_USER:
            var name_index = data.object_get(data.root, "sender_user_name")
            if name_index == -1 or data.is_null(name_index):
                raise Error("MessageOrigin hidden user is missing sender_user_name")
            result.sender_user_name = Optional[String](data.string_value(name_index))
        elif kind == Self.CHAT:
            var sender_index = data.object_get(data.root, "sender_chat")
            if sender_index == -1 or data.is_null(sender_index):
                raise Error("MessageOrigin chat is missing sender_chat")
            result.sender_chat = Optional[Chat](
                Chat.de_json(_origin_nested(data, sender_index)).copy()
            )
            var signature_index = data.object_get(data.root, "author_signature")
            if signature_index != -1 and not data.is_null(signature_index):
                result.author_signature = Optional[String](data.string_value(signature_index))
        elif kind == Self.CHANNEL:
            var chat_index = data.object_get(data.root, "chat")
            var message_id_index = data.object_get(data.root, "message_id")
            if chat_index == -1 or message_id_index == -1 or data.is_null(chat_index):
                raise Error("MessageOrigin channel is missing chat or message_id")
            result.chat = Optional[Chat](Chat.de_json(_origin_nested(data, chat_index)).copy())
            result.message_id = Optional[Int](data.integer_value(message_id_index))
            var signature_index = data.object_get(data.root, "author_signature")
            if signature_index != -1 and not data.is_null(signature_index):
                result.author_signature = Optional[String](data.string_value(signature_index))
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
