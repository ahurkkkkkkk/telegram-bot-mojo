#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is derived from python-telegram-bot v22.8, which is distributed
# under the GNU Lesser General Public License version 3. See LICENSE.

"""Native Mojo string helpers corresponding to telegram._utils.strings."""

from ._unicode_case import (
    _is_cased_character,
    _lowercase_character,
    _titlecase_character,
)


@fieldwise_init
struct TextEncoding(Equatable, ImplicitlyCopyable):
    """This enum contains encoding schemes for text.

    .. versionadded:: 21.5
    """

    var value: String
    var name: String

    comptime UTF_8 = TextEncoding("utf-8", "UTF_8")
    comptime UTF_16_LE = TextEncoding("utf-16-le", "UTF_16_LE")

    def __init__(out self, value: String) raises:
        if value == "utf-8":
            self.value = "utf-8"
            self.name = "UTF_8"
            return
        if value == "utf-16-le":
            self.value = "utf-16-le"
            self.name = "UTF_16_LE"
            return
        raise Error("TextEncoding: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<TextEncoding." + self.name + ">"


def to_camel_case(snake_str: String) -> String:
    """Converts a snake_case string to camelCase.

    Args:
        snake_str (:obj:`str`): The string to convert.

    Returns:
        :obj:`str`: The converted string.
    """
    var result = String()
    var component_index = 0
    var at_component_start = False

    for character in snake_str.codepoint_slices():
        if character == "_":
            component_index += 1
            at_component_start = True
            continue

        if component_index == 0:
            result.write_string(character)
        elif at_component_start:
            result.write_string(_titlecase_character(character))
            if _is_cased_character(character):
                at_component_start = False
        else:
            result.write_string(_lowercase_character(character))
            if not _is_cased_character(character):
                at_component_start = True

    return result
