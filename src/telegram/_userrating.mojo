#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _userrating.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct UserRating(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream UserRating."""

    var level: Int
    var rating: Int
    var current_level_rating: Int
    var next_level_rating: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, level: Int, rating: Int, current_level_rating: Int, next_level_rating: Optional[Int] = None):
        self.level = level
        self.rating = rating
        self.current_level_rating = current_level_rating
        self.next_level_rating = next_level_rating
        self.api_kwargs = empty_json_object()

    def __init__(out self, level: Int, rating: Int, current_level_rating: Int, next_level_rating: Optional[Int] = None, *, api_kwargs: JsonDocument):
        self.level = level
        self.rating = rating
        self.current_level_rating = current_level_rating
        self.next_level_rating = next_level_rating
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.level = existing.level
        self.rating = existing.rating
        self.current_level_rating = existing.current_level_rating
        self.next_level_rating = existing.next_level_rating
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.level == other.level and self.rating == other.rating

    def __hash__[H: Hasher](self, mut hasher: H):
        var level_hash_text = String(self.level)
        hasher.update(level_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var rating_hash_text = String(self.rating)
        hasher.update(rating_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "current_level_rating", String(self.current_level_rating))
        result.set_number(result.root, "level", String(self.level))
        if self.next_level_rating is not None:
            result.set_number(result.root, "next_level_rating", String(self.next_level_rating.value()))
        result.set_number(result.root, "rating", String(self.rating))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> UserRating:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("UserRating JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UserRating JSON value is not an object")
        var parsed_level_index = data.object_get(data.root, "level")
        if parsed_level_index == -1:
            raise Error("UserRating JSON object is missing level")
        var parsed_level = data.integer_value(parsed_level_index)
        var parsed_rating_index = data.object_get(data.root, "rating")
        if parsed_rating_index == -1:
            raise Error("UserRating JSON object is missing rating")
        var parsed_rating = data.integer_value(parsed_rating_index)
        var parsed_current_level_rating_index = data.object_get(data.root, "current_level_rating")
        if parsed_current_level_rating_index == -1:
            raise Error("UserRating JSON object is missing current_level_rating")
        var parsed_current_level_rating = data.integer_value(parsed_current_level_rating_index)
        var parsed_next_level_rating_index = data.object_get(data.root, "next_level_rating")
        var parsed_next_level_rating: Optional[Int] = None
        if parsed_next_level_rating_index != -1 and not data.is_null(parsed_next_level_rating_index):
            parsed_next_level_rating = Optional[Int](data.integer_value(parsed_next_level_rating_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "level" and key != "rating" and key != "current_level_rating" and key != "next_level_rating":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return UserRating(parsed_level, parsed_rating, parsed_current_level_rating, parsed_next_level_rating, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[UserRating]:
        var items = data.array_documents(array_index)
        var result = List[UserRating]()
        for index in range(len(items)):
            result.append(UserRating.de_json(items[index].copy()))
        return result^
