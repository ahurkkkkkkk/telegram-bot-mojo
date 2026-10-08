#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _utils/markup.py.
# LGPL-3.0-or-later; see LICENSE.

"""Keyboard shape checks for statically typed native Mojo lists."""

from std.collections import List


def check_keyboard_type(keyboard: String) -> Bool:
    """Strings are sequences in Python but are explicitly invalid keyboards."""
    return False


def check_keyboard_type(keyboard: List[String]) -> Bool:
    """A flat non-empty sequence has invalid row values; an empty keyboard is valid."""
    return len(keyboard) == 0


def check_keyboard_type[T: Copyable](keyboard: List[List[T]]) -> Bool:
    """Rows must be homogeneous list values; scalar/string buttons are accepted."""
    return True


def check_keyboard_type(keyboard: List[List[List[String]]]) -> Bool:
    """Reject native list buttons, which correspond to nested Sequence values."""
    for row in keyboard:
        if len(row) > 0:
            return False
    return True
