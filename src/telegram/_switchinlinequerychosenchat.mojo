#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _switchinlinequerychosenchat.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct SwitchInlineQueryChosenChat(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream SwitchInlineQueryChosenChat."""

    var query: Optional[String]
    var allow_user_chats: Optional[Bool]
    var allow_bot_chats: Optional[Bool]
    var allow_group_chats: Optional[Bool]
    var allow_channel_chats: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, query: Optional[String] = None, allow_user_chats: Optional[Bool] = None, allow_bot_chats: Optional[Bool] = None, allow_group_chats: Optional[Bool] = None, allow_channel_chats: Optional[Bool] = None):
        self.query = query
        self.allow_user_chats = allow_user_chats
        self.allow_bot_chats = allow_bot_chats
        self.allow_group_chats = allow_group_chats
        self.allow_channel_chats = allow_channel_chats
        self.api_kwargs = empty_json_object()

    def __init__(out self, query: Optional[String] = None, allow_user_chats: Optional[Bool] = None, allow_bot_chats: Optional[Bool] = None, allow_group_chats: Optional[Bool] = None, allow_channel_chats: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.query = query
        self.allow_user_chats = allow_user_chats
        self.allow_bot_chats = allow_bot_chats
        self.allow_group_chats = allow_group_chats
        self.allow_channel_chats = allow_channel_chats
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.query = existing.query
        self.allow_user_chats = existing.allow_user_chats
        self.allow_bot_chats = existing.allow_bot_chats
        self.allow_group_chats = existing.allow_group_chats
        self.allow_channel_chats = existing.allow_channel_chats
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.query == other.query and self.allow_user_chats == other.allow_user_chats and self.allow_bot_chats == other.allow_bot_chats and self.allow_group_chats == other.allow_group_chats and self.allow_channel_chats == other.allow_channel_chats

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.query is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.query.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.allow_user_chats is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.allow_user_chats.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.allow_bot_chats is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.allow_bot_chats.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.allow_group_chats is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.allow_group_chats.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.allow_channel_chats is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.allow_channel_chats.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.allow_bot_chats is not None:
            result.set_boolean(result.root, "allow_bot_chats", self.allow_bot_chats.value())
        if self.allow_channel_chats is not None:
            result.set_boolean(result.root, "allow_channel_chats", self.allow_channel_chats.value())
        if self.allow_group_chats is not None:
            result.set_boolean(result.root, "allow_group_chats", self.allow_group_chats.value())
        if self.allow_user_chats is not None:
            result.set_boolean(result.root, "allow_user_chats", self.allow_user_chats.value())
        if self.query is not None:
            result.set_string(result.root, "query", self.query.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> SwitchInlineQueryChosenChat:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("SwitchInlineQueryChosenChat JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("SwitchInlineQueryChosenChat JSON value is not an object")
        var parsed_query_index = data.object_get(data.root, "query")
        var parsed_query: Optional[String] = None
        if parsed_query_index != -1 and not data.is_null(parsed_query_index):
            parsed_query = Optional[String](data.string_value(parsed_query_index))
        var parsed_allow_user_chats_index = data.object_get(data.root, "allow_user_chats")
        var parsed_allow_user_chats: Optional[Bool] = None
        if parsed_allow_user_chats_index != -1 and not data.is_null(parsed_allow_user_chats_index):
            parsed_allow_user_chats = Optional[Bool](data.boolean_value(parsed_allow_user_chats_index))
        var parsed_allow_bot_chats_index = data.object_get(data.root, "allow_bot_chats")
        var parsed_allow_bot_chats: Optional[Bool] = None
        if parsed_allow_bot_chats_index != -1 and not data.is_null(parsed_allow_bot_chats_index):
            parsed_allow_bot_chats = Optional[Bool](data.boolean_value(parsed_allow_bot_chats_index))
        var parsed_allow_group_chats_index = data.object_get(data.root, "allow_group_chats")
        var parsed_allow_group_chats: Optional[Bool] = None
        if parsed_allow_group_chats_index != -1 and not data.is_null(parsed_allow_group_chats_index):
            parsed_allow_group_chats = Optional[Bool](data.boolean_value(parsed_allow_group_chats_index))
        var parsed_allow_channel_chats_index = data.object_get(data.root, "allow_channel_chats")
        var parsed_allow_channel_chats: Optional[Bool] = None
        if parsed_allow_channel_chats_index != -1 and not data.is_null(parsed_allow_channel_chats_index):
            parsed_allow_channel_chats = Optional[Bool](data.boolean_value(parsed_allow_channel_chats_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "query" and key != "allow_user_chats" and key != "allow_bot_chats" and key != "allow_group_chats" and key != "allow_channel_chats":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return SwitchInlineQueryChosenChat(parsed_query, parsed_allow_user_chats, parsed_allow_bot_chats, parsed_allow_group_chats, parsed_allow_channel_chats, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[SwitchInlineQueryChosenChat]:
        var items = data.array_documents(array_index)
        var result = List[SwitchInlineQueryChosenChat]()
        for index in range(len(items)):
            result.append(SwitchInlineQueryChosenChat.de_json(items[index].copy()))
        return result^
