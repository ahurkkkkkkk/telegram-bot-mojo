#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""Information about a Telegram Web App."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object, parse_string_field, string_field_to_json


struct WebAppInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a Web App URL; equality uses `url`."""

    var url: String
    var api_kwargs: JsonDocument

    def __init__(out self, url: String):
        self.url = url
        self.api_kwargs = empty_json_object()

    def __init__(out self, url: String, api_kwargs: JsonDocument):
        self.url = url
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.url = existing.url.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.url == other.url

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.url.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return string_field_to_json("url", self.url, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        var parsed = parse_string_field(data, "url")
        return WebAppInfo(parsed.value, parsed.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(WebAppInfo.de_json(items[index].copy()))
        return result^
