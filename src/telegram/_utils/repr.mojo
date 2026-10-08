#!/usr/bin/env mojo
#
# Native representation helpers corresponding to telegram._utils.repr.
# LGPL-3.0-or-later; see LICENSE.

"""Helpers for assembling selected-attribute representations in native Mojo."""

from std.collections import List


struct ReprField(Copyable, Equatable):
    """One already-rendered name/value pair for a selected-attribute repr."""

    var name: String
    var value: String

    def __init__(out self, name: String, value: String):
        self.name = name.copy()
        self.value = value.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.value = existing.value.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name and self.value == other.value


def build_repr_with_selected_attrs(class_name: String, fields: List[ReprField]) -> String:
    """Build ``ClassName[name=value, ...]`` while preserving field order.

    Mojo has no Python-style runtime keyword argument mapping or dynamic
    ``__class__`` lookup, so callers pass the type name and selected values
    explicitly. ``value`` is the value's string form, matching Python's
    ``f"{value}"`` behavior; callers representing callables pass their
    qualified name.
    """
    var result = String(class_name, "[")
    for index in range(len(fields)):
        if index > 0:
            result += ", "
        result += fields[index].name
        result += "="
        result += fields[index].value
    result += "]"
    return result


def stringify_repr_field(name: String, value: String) -> ReprField:
    """Format a string-valued selected attribute using the source helper's rule."""
    return ReprField(name, value)


def stringify_repr_field(name: String, value: Bool) -> ReprField:
    """Format a Boolean selected attribute using Python's lowercase spelling."""
    if value:
        return ReprField(name, "True")
    return ReprField(name, "False")


def stringify_repr_field(name: String, value: Int) -> ReprField:
    return ReprField(name, String(value))


def stringify_repr_field(name: String, value: Int64) -> ReprField:
    return ReprField(name, String(value))


def stringify_repr_field(name: String, value: Float64) -> ReprField:
    return ReprField(name, String(value))
