#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 Chat.
# LGPL-3.0-or-later; see LICENSE.

"""A Telegram chat value with JSON and local mention helpers."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument
from telegram._utils.json_model import empty_json_object
from telegram.helpers import escape_markdown
from telegram.helpers import mention_html as mention_user_html
from telegram.helpers import mention_markdown as mention_user_markdown


def _chat_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _chat_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _chat_escape_html(value: String) -> String:
    var result = String()
    for character in value.codepoint_slices():
        if character == "&":
            result.write_string("&amp;")
        elif character == "<":
            result.write_string("&lt;")
        elif character == ">":
            result.write_string("&gt;")
        elif character == "\"":
            result.write_string("&quot;")
        elif character == "'":
            result.write_string("&#x27;")
        else:
            result.write_string(character)
    return result


struct Chat(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Telegram chat metadata; equality and hashing use only ``id``."""

    comptime SENDER = "sender"
    comptime PRIVATE = "private"
    comptime GROUP = "group"
    comptime SUPERGROUP = "supergroup"
    comptime CHANNEL = "channel"

    var id: Int
    var chat_type: String
    var title: Optional[String]
    var username: Optional[String]
    var first_name: Optional[String]
    var last_name: Optional[String]
    var is_forum: Optional[Bool]
    var is_direct_messages: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: Int,
        type: String,
        title: Optional[String] = None,
        username: Optional[String] = None,
        first_name: Optional[String] = None,
        last_name: Optional[String] = None,
        is_forum: Optional[Bool] = None,
        is_direct_messages: Optional[Bool] = None,
    ):
        self.id = id
        self.chat_type = type.copy()
        self.title = title
        self.username = username
        self.first_name = first_name
        self.last_name = last_name
        self.is_forum = is_forum
        self.is_direct_messages = is_direct_messages
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        type: String,
        title: Optional[String] = None,
        username: Optional[String] = None,
        first_name: Optional[String] = None,
        last_name: Optional[String] = None,
        is_forum: Optional[Bool] = None,
        is_direct_messages: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id
        self.chat_type = type.copy()
        self.title = title
        self.username = username
        self.first_name = first_name
        self.last_name = last_name
        self.is_forum = is_forum
        self.is_direct_messages = is_direct_messages
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id
        self.chat_type = existing.chat_type.copy()
        self.title = existing.title
        self.username = existing.username
        self.first_name = existing.first_name
        self.last_name = existing.last_name
        self.is_forum = existing.is_forum
        self.is_direct_messages = existing.is_direct_messages
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.id).as_bytes())

    def type(self) -> String:
        return self.chat_type.copy()

    def full_name(self) -> Optional[String]:
        if self.first_name is None or self.first_name.value().byte_length() == 0:
            return None
        var value = self.first_name.value().copy()
        if self.last_name is not None and self.last_name.value().byte_length() > 0:
            value = String(value, " ", self.last_name.value())
        return Optional[String](value^)

    def effective_name(self) -> Optional[String]:
        if self.title is not None:
            return Optional[String](self.title.value().copy())
        return self.full_name()

    def link(self) -> Optional[String]:
        if self.username is None or self.username.value().byte_length() == 0:
            return None
        return Optional[String](String("https://t.me/", self.username.value()))

    def mention_markdown(self, name: Optional[String] = None) raises -> String:
        if self.chat_type == "private":
            if name is not None and name.value().byte_length() > 0:
                return mention_user_markdown(self.id, name.value())
            var full = self.full_name()
            if full is not None:
                return mention_user_markdown(self.id, full.value())
            raise Error("Can not create a mention to a private chat without first name")
        if self.username is not None and self.username.value().byte_length() > 0:
            var label: String
            if name is not None and name.value().byte_length() > 0:
                label = name.value().copy()
            elif self.title is not None and self.title.value().byte_length() > 0:
                label = self.title.value().copy()
            else:
                raise Error("Can not create a mention to a public chat without title")
            return String("[", label, "](", self.link().value(), ")")
        raise Error("Can not create a mention to a private group chat")

    def mention_markdown_v2(self, name: Optional[String] = None) raises -> String:
        if self.chat_type == "private":
            if name is not None and name.value().byte_length() > 0:
                return mention_user_markdown(self.id, name.value(), version=2)
            var full = self.full_name()
            if full is not None:
                return mention_user_markdown(self.id, full.value(), version=2)
            raise Error("Can not create a mention to a private chat without first name")
        if self.username is not None and self.username.value().byte_length() > 0:
            var label: String
            if name is not None and name.value().byte_length() > 0:
                label = escape_markdown(name.value(), version=2)
            elif self.title is not None and self.title.value().byte_length() > 0:
                label = escape_markdown(self.title.value(), version=2)
            else:
                raise Error("Can not create a mention to a public chat without title")
            return String("[", label, "](", self.link().value(), ")")
        raise Error("Can not create a mention to a private group chat")

    def mention_html(self, name: Optional[String] = None) raises -> String:
        if self.chat_type == "private":
            if name is not None and name.value().byte_length() > 0:
                return mention_user_html(self.id, name.value())
            var full = self.full_name()
            if full is not None:
                return mention_user_html(self.id, full.value())
            raise Error("Can not create a mention to a private chat without first name")
        if self.username is not None and self.username.value().byte_length() > 0:
            var label: String
            if name is not None and name.value().byte_length() > 0:
                label = name.value().copy()
            elif self.title is not None and self.title.value().byte_length() > 0:
                label = self.title.value().copy()
            else:
                raise Error("Can not create a mention to a public chat without title")
            return String('<a href="', self.link().value(), '">', _chat_escape_html(label), "</a>")
        raise Error("Can not create a mention to a private group chat")

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "id", String(self.id))
        result.set_string(result.root, "type", self.chat_type)
        if self.title is not None:
            result.set_string(result.root, "title", self.title.value())
        if self.username is not None:
            result.set_string(result.root, "username", self.username.value())
        if self.first_name is not None:
            result.set_string(result.root, "first_name", self.first_name.value())
        if self.last_name is not None:
            result.set_string(result.root, "last_name", self.last_name.value())
        if self.is_forum is not None:
            result.set_boolean(result.root, "is_forum", self.is_forum.value())
        if self.is_direct_messages is not None:
            result.set_boolean(result.root, "is_direct_messages", self.is_direct_messages.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return self.to_dict().to_json()

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Chat JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var type_index = data.object_get(data.root, "type")
        if id_index == -1 or type_index == -1:
            raise Error("Chat JSON requires id and type")
        var id = data.integer_value(id_index)
        var chat_type = data.string_value(type_index)
        var title = _chat_optional_string(data, "title")
        var username = _chat_optional_string(data, "username")
        var first_name = _chat_optional_string(data, "first_name")
        var last_name = _chat_optional_string(data, "last_name")
        var is_forum = _chat_optional_bool(data, "is_forum")
        var is_direct_messages = _chat_optional_bool(data, "is_direct_messages")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var is_known = (
                key == "id" or key == "type" or key == "title" or key == "username" or
                key == "first_name" or key == "last_name" or key == "is_forum" or
                key == "is_direct_messages"
            )
            if not is_known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            id,
            chat_type,
            title,
            username,
            first_name,
            last_name,
            is_forum,
            is_direct_messages,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
