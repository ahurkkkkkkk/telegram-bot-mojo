#!/usr/bin/env mojo
#
# Native reaction values corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Telegram message reaction types and counts."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _reaction_api_kwargs(
    data: JsonDocument, first: String, second: String = String()
) raises -> JsonDocument:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("reaction JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("reaction JSON value is not an object")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if key != first and key != second:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _reaction_subdocument(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("reaction JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _require_reaction_object(data: JsonDocument, class_name: String) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error(String(class_name, " JSON document has no root"))
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error(String(class_name, " JSON value is not an object"))


struct ReactionTypeEmoji(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A reaction represented by a standard emoji."""

    comptime TYPE = "emoji"
    var emoji: String
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self, emoji: String):
        self.emoji = emoji.copy()
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, emoji: String, api_kwargs: JsonDocument):
        self.emoji = emoji.copy()
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.emoji = existing.emoji.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.emoji == other.emoji

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.emoji.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "emoji", self.emoji)
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _require_reaction_object(data, "ReactionTypeEmoji")
        var emoji_index = data.object_get(data.root, "emoji")
        if emoji_index == -1:
            raise Error("ReactionTypeEmoji JSON object is missing emoji")
        return Self(
            data.string_value(emoji_index),
            _reaction_api_kwargs(data, "type", "emoji"),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct ReactionTypeCustomEmoji(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A reaction represented by a custom emoji identifier."""

    comptime TYPE = "custom_emoji"
    var custom_emoji_id: String
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self, custom_emoji_id: String):
        self.custom_emoji_id = custom_emoji_id.copy()
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, custom_emoji_id: String, api_kwargs: JsonDocument):
        self.custom_emoji_id = custom_emoji_id.copy()
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.custom_emoji_id = existing.custom_emoji_id.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.custom_emoji_id == other.custom_emoji_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.custom_emoji_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "custom_emoji_id", self.custom_emoji_id)
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _require_reaction_object(data, "ReactionTypeCustomEmoji")
        var id_index = data.object_get(data.root, "custom_emoji_id")
        if id_index == -1:
            raise Error("ReactionTypeCustomEmoji JSON object is missing custom_emoji_id")
        return Self(
            data.string_value(id_index),
            _reaction_api_kwargs(data, "type", "custom_emoji_id"),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct ReactionTypePaid(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A paid reaction."""

    comptime TYPE = "paid"
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self):
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, api_kwargs: JsonDocument):
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(Self.TYPE).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _require_reaction_object(data, "ReactionTypePaid")
        return Self(_reaction_api_kwargs(data, "type"))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct ReactionType(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Tagged value for any standard, custom, paid, or future reaction type.

    ``de_json`` dispatches known Bot API discriminators into payload-bearing
    tagged values. The three concrete structs remain available when a caller
    needs a statically specific variant.
    """

    comptime EMOJI = "emoji"
    comptime CUSTOM_EMOJI = "custom_emoji"
    comptime PAID = "paid"

    var type: String
    var has_variant: Bool
    var emoji: String
    var custom_emoji_id: String
    var api_kwargs: JsonDocument

    def __init__(out self, type: String):
        self.type = type.copy()
        self.has_variant = False
        self.emoji = String()
        self.custom_emoji_id = String()
        self.api_kwargs = empty_json_object()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.has_variant = existing.has_variant
        self.emoji = existing.emoji.copy()
        self.custom_emoji_id = existing.custom_emoji_id.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.type != other.type or self.has_variant != other.has_variant:
            return False
        if not self.has_variant:
            return True
        if self.type == Self.EMOJI:
            return self.emoji == other.emoji
        if self.type == Self.CUSTOM_EMOJI:
            return self.custom_emoji_id == other.custom_emoji_id
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.has_variant and self.type == Self.EMOJI:
            hasher.update(self.emoji.as_bytes())
        elif self.has_variant and self.type == Self.CUSTOM_EMOJI:
            hasher.update(self.custom_emoji_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.has_variant and self.type == Self.EMOJI:
            result.set_string(result.root, "emoji", self.emoji)
        elif self.has_variant and self.type == Self.CUSTOM_EMOJI:
            result.set_string(result.root, "custom_emoji_id", self.custom_emoji_id)
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _require_reaction_object(data, "ReactionType")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1 or data.nodes[type_index].kind != JSON_STRING:
            raise Error("ReactionType JSON object is missing string type")
        var reaction_type = data.string_value(type_index)
        var result = ReactionType(reaction_type)
        if reaction_type == Self.EMOJI:
            var item = ReactionTypeEmoji.de_json(data.copy())
            result.emoji = item.emoji.copy()
            result.has_variant = True
            result.api_kwargs = item.api_kwargs.copy()
        elif reaction_type == Self.CUSTOM_EMOJI:
            var item = ReactionTypeCustomEmoji.de_json(data.copy())
            result.custom_emoji_id = item.custom_emoji_id.copy()
            result.has_variant = True
            result.api_kwargs = item.api_kwargs.copy()
        elif reaction_type == Self.PAID:
            var item = ReactionTypePaid.de_json(data.copy())
            result.has_variant = True
            result.api_kwargs = item.api_kwargs.copy()
        else:
            result.api_kwargs = _reaction_api_kwargs(data, "type")
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct ReactionCount(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A reaction type and the number of times it was added to a message."""

    var type: ReactionType
    var total_count: Int
    var api_kwargs: JsonDocument

    def __init__(out self, type: ReactionType, total_count: Int):
        self.type = type.copy()
        self.total_count = total_count
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: ReactionType, total_count: Int, api_kwargs: JsonDocument):
        self.type = type.copy()
        self.total_count = total_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.total_count = existing.total_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.total_count == other.total_count

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.type.has_variant and self.type.type == ReactionType.EMOJI:
            hasher.update(self.type.emoji.as_bytes())
        elif self.type.has_variant and self.type.type == ReactionType.CUSTOM_EMOJI:
            hasher.update(self.type.custom_emoji_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.total_count).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "total_count", String(self.total_count))
        var type_data = self.type.to_dict(recursive)
        var type_node = result.copy_subtree_from(type_data, type_data.root)
        result.object_set(result.root, "type", type_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _require_reaction_object(data, "ReactionCount")
        var type_index = data.object_get(data.root, "type")
        var count_index = data.object_get(data.root, "total_count")
        if type_index == -1 or count_index == -1:
            raise Error("ReactionCount JSON object is missing a required field")
        var reaction_type = ReactionType.de_json(_reaction_subdocument(data, type_index))
        var total_count = data.integer_value(count_index)
        return Self(
            reaction_type,
            total_count,
            _reaction_api_kwargs(data, "type", "total_count"),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
