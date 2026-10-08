#!/usr/bin/env mojo
#
# Native Birthdate value translation from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""The Telegram user's birthdate."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.datetime import Date
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Birthdate(Equatable, Hashable, Copyable):
    """Birthdate with day/month identity and an optional year."""

    var day: Int
    var month: Int
    var year: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, day: Int, month: Int, year: Optional[Int] = None):
        self.day = day
        self.month = month
        self.year = year
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        day: Int,
        month: Int,
        year: Optional[Int],
        *,
        api_kwargs: JsonDocument,
    ):
        self.day = day
        self.month = month
        self.year = year
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.day = existing.day
        self.month = existing.month
        self.year = existing.year
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.day == other.day and self.month == other.month

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.day).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.month).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "day", String(self.day))
        result.set_number(result.root, "month", String(self.month))
        if self.year is not None:
            result.set_number(result.root, "year", String(self.year.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def to_date(self, year: Optional[Int] = None) raises -> Date:
        var resolved_year = year
        if resolved_year is None or resolved_year.value() == 0:
            resolved_year = self.year
        if resolved_year is None:
            raise Error("year is required when Birthdate.year is not set")
        return Date(resolved_year.value(), self.month, self.day)

    @staticmethod
    def de_json(data: JsonDocument) raises -> Birthdate:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Birthdate JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Birthdate JSON value is not an object")
        var day_index = data.object_get(data.root, "day")
        var month_index = data.object_get(data.root, "month")
        if day_index == -1 or month_index == -1:
            raise Error("Birthdate JSON object is missing day or month")
        var year_index = data.object_get(data.root, "year")
        var year: Optional[Int] = None
        if year_index != -1 and not data.is_null(year_index):
            year = Optional[Int](data.integer_value(year_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "day" and key != "month" and key != "year":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Birthdate(
            data.integer_value(day_index),
            data.integer_value(month_index),
            year,
            api_kwargs=api_kwargs,
        )
