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
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""Sentinel values for defaults explicitly selected by a caller.

This corresponds to telegram._utils.defaultvalue. A wrapped value remains
distinguishable from the same value passed explicitly by the caller.
"""


struct DefaultValue[T: ImplicitlyCopyable & Deinitable](Copyable, ImplicitlyCopyable):
    """Wrapper that marks a value as the library-provided default.

    ``value`` stores the wrapped immutable value. Call ``unwrap`` to use it.
    """

    var value: Self.T
    var is_sentinel: Bool

    def __init__(out self, value: Self.T):
        self.value = value.copy()
        self.is_sentinel = False

    def __init__(out self, value: Self.T, *, sentinel: Bool):
        self.value = value.copy()
        self.is_sentinel = sentinel

    def unwrap(self) -> Self.T:
        return self.value.copy()

def get_value[U: ImplicitlyCopyable & Deinitable](obj: DefaultValue[U]) -> U:
    """Unwrap a library default without changing explicit values."""
    return obj.value.copy()


def get_value(obj: Bool) -> Bool:
    return obj


def get_value(obj: Int) -> Int:
    return obj


def get_value(obj: Float64) -> Float64:
    return obj


def get_value(obj: String) -> String:
    return obj.copy()


def get_value(obj: NoneType) -> NoneType:
    return None


def is_truthy[U: ImplicitlyCopyable & Deinitable & Boolable](
    obj: DefaultValue[U],
) -> Bool:
    """Evaluate a wrapped Boolean-capable value explicitly."""
    return Bool(obj.value)


comptime DEFAULT_NONE = DefaultValue[NoneType](None, sentinel=True)
comptime DEFAULT_FALSE = DefaultValue(False, sentinel=True)
comptime DEFAULT_TRUE = DefaultValue(True, sentinel=True)
comptime DEFAULT_20 = DefaultValue(20, sentinel=True)
comptime DEFAULT_IP = DefaultValue[String]("127.0.0.1", sentinel=True)
comptime DEFAULT_80 = DefaultValue(80, sentinel=True)
