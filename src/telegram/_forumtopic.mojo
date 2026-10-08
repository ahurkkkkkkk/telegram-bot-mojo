#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _forumtopic.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct ForumTopic(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream ForumTopic."""

    var message_thread_id: Int
    var name: String
    var icon_color: Int
    var icon_custom_emoji_id: Optional[String]
    var is_name_implicit: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, message_thread_id: Int, name: String, icon_color: Int, icon_custom_emoji_id: Optional[String] = None, is_name_implicit: Optional[Bool] = None):
        self.message_thread_id = message_thread_id
        self.name = name
        self.icon_color = icon_color
        self.icon_custom_emoji_id = icon_custom_emoji_id
        self.is_name_implicit = is_name_implicit
        self.api_kwargs = empty_json_object()

    def __init__(out self, message_thread_id: Int, name: String, icon_color: Int, icon_custom_emoji_id: Optional[String] = None, is_name_implicit: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.message_thread_id = message_thread_id
        self.name = name
        self.icon_color = icon_color
        self.icon_custom_emoji_id = icon_custom_emoji_id
        self.is_name_implicit = is_name_implicit
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.message_thread_id = existing.message_thread_id
        self.name = existing.name.copy()
        self.icon_color = existing.icon_color
        self.icon_custom_emoji_id = existing.icon_custom_emoji_id
        self.is_name_implicit = existing.is_name_implicit
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_thread_id == other.message_thread_id and self.name == other.name and self.icon_color == other.icon_color

    def __hash__[H: Hasher](self, mut hasher: H):
        var message_thread_id_hash_text = String(self.message_thread_id)
        hasher.update(message_thread_id_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.name.as_bytes())
        hasher.update(String("\0").as_bytes())
        var icon_color_hash_text = String(self.icon_color)
        hasher.update(icon_color_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "icon_color", String(self.icon_color))
        if self.icon_custom_emoji_id is not None:
            result.set_string(result.root, "icon_custom_emoji_id", self.icon_custom_emoji_id.value())
        if self.is_name_implicit is not None:
            result.set_boolean(result.root, "is_name_implicit", self.is_name_implicit.value())
        result.set_number(result.root, "message_thread_id", String(self.message_thread_id))
        result.set_string(result.root, "name", self.name)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ForumTopic:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ForumTopic JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ForumTopic JSON value is not an object")
        var parsed_message_thread_id_index = data.object_get(data.root, "message_thread_id")
        if parsed_message_thread_id_index == -1:
            raise Error("ForumTopic JSON object is missing message_thread_id")
        var parsed_message_thread_id = data.integer_value(parsed_message_thread_id_index)
        var parsed_name_index = data.object_get(data.root, "name")
        if parsed_name_index == -1:
            raise Error("ForumTopic JSON object is missing name")
        var parsed_name = data.string_value(parsed_name_index)
        var parsed_icon_color_index = data.object_get(data.root, "icon_color")
        if parsed_icon_color_index == -1:
            raise Error("ForumTopic JSON object is missing icon_color")
        var parsed_icon_color = data.integer_value(parsed_icon_color_index)
        var parsed_icon_custom_emoji_id_index = data.object_get(data.root, "icon_custom_emoji_id")
        var parsed_icon_custom_emoji_id: Optional[String] = None
        if parsed_icon_custom_emoji_id_index != -1 and not data.is_null(parsed_icon_custom_emoji_id_index):
            parsed_icon_custom_emoji_id = Optional[String](data.string_value(parsed_icon_custom_emoji_id_index))
        var parsed_is_name_implicit_index = data.object_get(data.root, "is_name_implicit")
        var parsed_is_name_implicit: Optional[Bool] = None
        if parsed_is_name_implicit_index != -1 and not data.is_null(parsed_is_name_implicit_index):
            parsed_is_name_implicit = Optional[Bool](data.boolean_value(parsed_is_name_implicit_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "message_thread_id" and key != "name" and key != "icon_color" and key != "icon_custom_emoji_id" and key != "is_name_implicit":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ForumTopic(parsed_message_thread_id, parsed_name, parsed_icon_color, parsed_icon_custom_emoji_id, parsed_is_name_implicit, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ForumTopic]:
        var items = data.array_documents(array_index)
        var result = List[ForumTopic]()
        for index in range(len(items)):
            result.append(ForumTopic.de_json(items[index].copy()))
        return result^
struct ForumTopicCreated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream ForumTopicCreated."""

    var name: String
    var icon_color: Int
    var icon_custom_emoji_id: Optional[String]
    var is_name_implicit: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, name: String, icon_color: Int, icon_custom_emoji_id: Optional[String] = None, is_name_implicit: Optional[Bool] = None):
        self.name = name
        self.icon_color = icon_color
        self.icon_custom_emoji_id = icon_custom_emoji_id
        self.is_name_implicit = is_name_implicit
        self.api_kwargs = empty_json_object()

    def __init__(out self, name: String, icon_color: Int, icon_custom_emoji_id: Optional[String] = None, is_name_implicit: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.name = name
        self.icon_color = icon_color
        self.icon_custom_emoji_id = icon_custom_emoji_id
        self.is_name_implicit = is_name_implicit
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.icon_color = existing.icon_color
        self.icon_custom_emoji_id = existing.icon_custom_emoji_id
        self.is_name_implicit = existing.is_name_implicit
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name and self.icon_color == other.icon_color

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.name.as_bytes())
        hasher.update(String("\0").as_bytes())
        var icon_color_hash_text = String(self.icon_color)
        hasher.update(icon_color_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "icon_color", String(self.icon_color))
        if self.icon_custom_emoji_id is not None:
            result.set_string(result.root, "icon_custom_emoji_id", self.icon_custom_emoji_id.value())
        if self.is_name_implicit is not None:
            result.set_boolean(result.root, "is_name_implicit", self.is_name_implicit.value())
        result.set_string(result.root, "name", self.name)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ForumTopicCreated:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ForumTopicCreated JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ForumTopicCreated JSON value is not an object")
        var parsed_name_index = data.object_get(data.root, "name")
        if parsed_name_index == -1:
            raise Error("ForumTopicCreated JSON object is missing name")
        var parsed_name = data.string_value(parsed_name_index)
        var parsed_icon_color_index = data.object_get(data.root, "icon_color")
        if parsed_icon_color_index == -1:
            raise Error("ForumTopicCreated JSON object is missing icon_color")
        var parsed_icon_color = data.integer_value(parsed_icon_color_index)
        var parsed_icon_custom_emoji_id_index = data.object_get(data.root, "icon_custom_emoji_id")
        var parsed_icon_custom_emoji_id: Optional[String] = None
        if parsed_icon_custom_emoji_id_index != -1 and not data.is_null(parsed_icon_custom_emoji_id_index):
            parsed_icon_custom_emoji_id = Optional[String](data.string_value(parsed_icon_custom_emoji_id_index))
        var parsed_is_name_implicit_index = data.object_get(data.root, "is_name_implicit")
        var parsed_is_name_implicit: Optional[Bool] = None
        if parsed_is_name_implicit_index != -1 and not data.is_null(parsed_is_name_implicit_index):
            parsed_is_name_implicit = Optional[Bool](data.boolean_value(parsed_is_name_implicit_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "name" and key != "icon_color" and key != "icon_custom_emoji_id" and key != "is_name_implicit":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ForumTopicCreated(parsed_name, parsed_icon_color, parsed_icon_custom_emoji_id, parsed_is_name_implicit, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ForumTopicCreated]:
        var items = data.array_documents(array_index)
        var result = List[ForumTopicCreated]()
        for index in range(len(items)):
            result.append(ForumTopicCreated.de_json(items[index].copy()))
        return result^
struct ForumTopicEdited(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream ForumTopicEdited."""

    var name: Optional[String]
    var icon_custom_emoji_id: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, name: Optional[String] = None, icon_custom_emoji_id: Optional[String] = None):
        self.name = name
        self.icon_custom_emoji_id = icon_custom_emoji_id
        self.api_kwargs = empty_json_object()

    def __init__(out self, name: Optional[String] = None, icon_custom_emoji_id: Optional[String] = None, *, api_kwargs: JsonDocument):
        self.name = name
        self.icon_custom_emoji_id = icon_custom_emoji_id
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name
        self.icon_custom_emoji_id = existing.icon_custom_emoji_id
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name and self.icon_custom_emoji_id == other.icon_custom_emoji_id

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.name is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.name.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.icon_custom_emoji_id is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.icon_custom_emoji_id.value().as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.icon_custom_emoji_id is not None:
            result.set_string(result.root, "icon_custom_emoji_id", self.icon_custom_emoji_id.value())
        if self.name is not None:
            result.set_string(result.root, "name", self.name.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ForumTopicEdited:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ForumTopicEdited JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ForumTopicEdited JSON value is not an object")
        var parsed_name_index = data.object_get(data.root, "name")
        var parsed_name: Optional[String] = None
        if parsed_name_index != -1 and not data.is_null(parsed_name_index):
            parsed_name = Optional[String](data.string_value(parsed_name_index))
        var parsed_icon_custom_emoji_id_index = data.object_get(data.root, "icon_custom_emoji_id")
        var parsed_icon_custom_emoji_id: Optional[String] = None
        if parsed_icon_custom_emoji_id_index != -1 and not data.is_null(parsed_icon_custom_emoji_id_index):
            parsed_icon_custom_emoji_id = Optional[String](data.string_value(parsed_icon_custom_emoji_id_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "name" and key != "icon_custom_emoji_id":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ForumTopicEdited(parsed_name, parsed_icon_custom_emoji_id, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ForumTopicEdited]:
        var items = data.array_documents(array_index)
        var result = List[ForumTopicEdited]()
        for index in range(len(items)):
            result.append(ForumTopicEdited.de_json(items[index].copy()))
        return result^
