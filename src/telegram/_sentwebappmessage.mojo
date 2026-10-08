#!/usr/bin/env mojo
#
# Derived from python-telegram-bot v22.8; LGPL-3.0-or-later. See LICENSE.

"""Information about an inline message sent by a Web App."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JsonDocument, dumps_json
from telegram._utils.json_model import (
    empty_json_object,
    optional_string_field_to_json,
    parse_optional_string_field,
)


struct SentWebAppMessage(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Contains an optional inline message identifier."""

    var inline_message_id: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, inline_message_id: Optional[String] = None):
        self.inline_message_id = inline_message_id
        self.api_kwargs = empty_json_object()

    def __init__(out self, inline_message_id: Optional[String], api_kwargs: JsonDocument):
        self.inline_message_id = inline_message_id
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.inline_message_id = existing.inline_message_id
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.inline_message_id == other.inline_message_id

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.inline_message_id is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.inline_message_id.value().as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return optional_string_field_to_json(
            "inline_message_id", self.inline_message_id, self.api_kwargs
        )

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        var parsed = parse_optional_string_field(data, "inline_message_id")
        return SentWebAppMessage(parsed.value, parsed.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(SentWebAppMessage.de_json(items[index].copy()))
        return result^
