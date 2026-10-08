#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""Bot profile descriptions represented by the Telegram Bot API."""

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object, parse_string_field, string_field_to_json
from std.hashlib.hasher import Hasher


struct BotDescription(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a bot description; equality depends on ``description``."""

    var description: String
    var api_kwargs: JsonDocument

    def __init__(out self, description: String):
        self.description = description
        self.api_kwargs = empty_json_object()

    def __init__(out self, description: String, api_kwargs: JsonDocument):
        self.description = description
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.description = existing.description.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.description == other.description

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.description.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return string_field_to_json("description", self.description, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        var parsed = parse_string_field(data, "description")
        return BotDescription(parsed.value, parsed.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotDescription.de_json(items[index].copy()))
        return result^


struct BotShortDescription(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a bot short description; equality depends on its value."""

    var short_description: String
    var api_kwargs: JsonDocument

    def __init__(out self, short_description: String):
        self.short_description = short_description
        self.api_kwargs = empty_json_object()

    def __init__(out self, short_description: String, api_kwargs: JsonDocument):
        self.short_description = short_description
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.short_description = existing.short_description.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.short_description == other.short_description

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.short_description.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return string_field_to_json("short_description", self.short_description, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        var parsed = parse_string_field(data, "short_description")
        return BotShortDescription(parsed.value, parsed.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotShortDescription.de_json(items[index].copy()))
        return result^
