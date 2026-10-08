#!/usr/bin/env mojo
#
# Derived from python-telegram-bot v22.8; LGPL-3.0-or-later. See LICENSE.

"""The poll type allowed by a poll-creation keyboard button."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JsonDocument, dumps_json
from telegram._utils.json_model import (
    empty_json_object,
    optional_string_field_to_json,
    parse_optional_string_field,
)


struct KeyboardButtonPollType(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Restricts polls created from the corresponding keyboard button."""

    var type: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, type: Optional[String] = None):
        self.type = type
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: Optional[String], api_kwargs: JsonDocument):
        self.type = type
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.type is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.type.value().as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return optional_string_field_to_json("type", self.type, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        var parsed = parse_optional_string_field(data, "type")
        return KeyboardButtonPollType(parsed.value, parsed.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(KeyboardButtonPollType.de_json(items[index].copy()))
        return result^
