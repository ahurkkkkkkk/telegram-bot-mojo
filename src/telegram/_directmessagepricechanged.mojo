#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _directmessagepricechanged.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct DirectMessagePriceChanged(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream DirectMessagePriceChanged."""

    var are_direct_messages_enabled: Bool
    var direct_message_star_count: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, are_direct_messages_enabled: Bool, direct_message_star_count: Optional[Int] = None):
        self.are_direct_messages_enabled = are_direct_messages_enabled
        self.direct_message_star_count = direct_message_star_count
        self.api_kwargs = empty_json_object()

    def __init__(out self, are_direct_messages_enabled: Bool, direct_message_star_count: Optional[Int] = None, *, api_kwargs: JsonDocument):
        self.are_direct_messages_enabled = are_direct_messages_enabled
        self.direct_message_star_count = direct_message_star_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.are_direct_messages_enabled = existing.are_direct_messages_enabled
        self.direct_message_star_count = existing.direct_message_star_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.are_direct_messages_enabled == other.are_direct_messages_enabled and self.direct_message_star_count == other.direct_message_star_count

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.are_direct_messages_enabled:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.direct_message_star_count is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            var direct_message_star_count_hash_text = String(self.direct_message_star_count.value())
            hasher.update(direct_message_star_count_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "are_direct_messages_enabled", self.are_direct_messages_enabled)
        if self.direct_message_star_count is not None:
            result.set_number(result.root, "direct_message_star_count", String(self.direct_message_star_count.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> DirectMessagePriceChanged:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("DirectMessagePriceChanged JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("DirectMessagePriceChanged JSON value is not an object")
        var parsed_are_direct_messages_enabled_index = data.object_get(data.root, "are_direct_messages_enabled")
        if parsed_are_direct_messages_enabled_index == -1:
            raise Error("DirectMessagePriceChanged JSON object is missing are_direct_messages_enabled")
        var parsed_are_direct_messages_enabled = data.boolean_value(parsed_are_direct_messages_enabled_index)
        var parsed_direct_message_star_count_index = data.object_get(data.root, "direct_message_star_count")
        var parsed_direct_message_star_count: Optional[Int] = None
        if parsed_direct_message_star_count_index != -1 and not data.is_null(parsed_direct_message_star_count_index):
            parsed_direct_message_star_count = Optional[Int](data.integer_value(parsed_direct_message_star_count_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "are_direct_messages_enabled" and key != "direct_message_star_count":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return DirectMessagePriceChanged(parsed_are_direct_messages_enabled, parsed_direct_message_star_count, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[DirectMessagePriceChanged]:
        var items = data.array_documents(array_index)
        var result = List[DirectMessagePriceChanged]()
        for index in range(len(items)):
            result.append(DirectMessagePriceChanged.de_json(items[index].copy()))
        return result^
