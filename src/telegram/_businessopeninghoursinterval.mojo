#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _business.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct BusinessOpeningHoursInterval(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream BusinessOpeningHoursInterval."""

    var opening_minute: Int
    var closing_minute: Int
    var api_kwargs: JsonDocument

    def __init__(out self, opening_minute: Int, closing_minute: Int):
        self.opening_minute = opening_minute
        self.closing_minute = closing_minute
        self.api_kwargs = empty_json_object()

    def __init__(out self, opening_minute: Int, closing_minute: Int, api_kwargs: JsonDocument):
        self.opening_minute = opening_minute
        self.closing_minute = closing_minute
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.opening_minute = existing.opening_minute
        self.closing_minute = existing.closing_minute
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.opening_minute == other.opening_minute and self.closing_minute == other.closing_minute

    def __hash__[H: Hasher](self, mut hasher: H):
        var opening_minute_hash_text = String(self.opening_minute)
        hasher.update(opening_minute_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var closing_minute_hash_text = String(self.closing_minute)
        hasher.update(closing_minute_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "closing_minute", String(self.closing_minute))
        result.set_number(result.root, "opening_minute", String(self.opening_minute))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessOpeningHoursInterval:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BusinessOpeningHoursInterval JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessOpeningHoursInterval JSON value is not an object")
        var parsed_opening_minute_index = data.object_get(data.root, "opening_minute")
        if parsed_opening_minute_index == -1:
            raise Error("BusinessOpeningHoursInterval JSON object is missing opening_minute")
        var parsed_opening_minute = data.integer_value(parsed_opening_minute_index)
        var parsed_closing_minute_index = data.object_get(data.root, "closing_minute")
        if parsed_closing_minute_index == -1:
            raise Error("BusinessOpeningHoursInterval JSON object is missing closing_minute")
        var parsed_closing_minute = data.integer_value(parsed_closing_minute_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "opening_minute" and key != "closing_minute":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return BusinessOpeningHoursInterval(parsed_opening_minute, parsed_closing_minute, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessOpeningHoursInterval]:
        var items = data.array_documents(array_index)
        var result = List[BusinessOpeningHoursInterval]()
        for index in range(len(items)):
            result.append(BusinessOpeningHoursInterval.de_json(items[index].copy()))
        return result^

    def _parse_minute(self, minute: Int) -> Tuple[Int, Int, Int]:
        var weekday = minute // 1440
        var minute_of_day = minute % 1440
        var hour = minute_of_day // 60
        var minute_component = minute_of_day % 60
        return (weekday, hour, minute_component)

    def opening_time(self) -> Tuple[Int, Int, Int]:
        return self._parse_minute(self.opening_minute)

    def closing_time(self) -> Tuple[Int, Int, Int]:
        return self._parse_minute(self.closing_minute)
