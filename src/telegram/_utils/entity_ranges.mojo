#!/usr/bin/env mojo
#
# Native UTF-16 entity range extraction for python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Low-level UTF-16 slicing kept free of Telegram model imports."""


def _utf16_code_units(character: StringSlice) -> Int:
    if ord(character) > 0xFFFF:
        return 2
    return 1


def slice_message_entity(text: String, offset: Int, length: Int) raises -> String:
    """Extract the text range addressed by Telegram UTF-16 code-unit offsets."""
    var total_units = 0
    for character in text.codepoint_slices():
        total_units += _utf16_code_units(character)

    var start = offset
    var end = offset + length
    if start < 0:
        start += total_units
    if end < 0:
        end += total_units
    if start < 0:
        start = 0
    elif start > total_units:
        start = total_units
    if end < 0:
        end = 0
    elif end > total_units:
        end = total_units
    if end <= start:
        return String()

    var result = String()
    var current_unit = 0
    for character in text.codepoint_slices():
        var width = _utf16_code_units(character)
        var next_unit = current_unit + width
        if current_unit < end and next_unit > start:
            if current_unit < start or next_unit > end:
                raise Error("UTF-16 entity range splits a surrogate pair")
            result.write_string(character)
        current_unit = next_unit
    return result
