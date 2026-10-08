#!/usr/bin/env mojo
#
# Native object-conversion protocol corresponding to TelegramObject's shared
# JSON conversion contract. LGPL-3.0-or-later; see LICENSE.

"""Compile-time protocol for native Telegram model JSON conversion."""

from std.collections import List

from telegram._utils.json import JsonDocument


trait TelegramJsonDecodable(Copyable):
    """Static decode requirements shared by JSON-backed Telegram model structs."""

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self: ...

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]: ...


trait TelegramJsonObject(TelegramJsonDecodable):
    """JSON decode and serialization operations shared by native model structs."""

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument: ...

    def to_json(self) raises -> String: ...
