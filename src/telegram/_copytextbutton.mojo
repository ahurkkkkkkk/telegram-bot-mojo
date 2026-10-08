#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""An inline keyboard button that copies specified text to the clipboard."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object, parse_string_field, string_field_to_json


struct CopyTextButton(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents the text copied by an inline keyboard button; equality uses `text`."""

    var text: String
    var api_kwargs: JsonDocument

    def __init__(out self, text: String):
        self.text = text
        self.api_kwargs = empty_json_object()

    def __init__(out self, text: String, api_kwargs: JsonDocument):
        self.text = text
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.text == other.text

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return string_field_to_json("text", self.text, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        var parsed = parse_string_field(data, "text")
        return CopyTextButton(parsed.value, parsed.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(CopyTextButton.de_json(items[index].copy()))
        return result^
