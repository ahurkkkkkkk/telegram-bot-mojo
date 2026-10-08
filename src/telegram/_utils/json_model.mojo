#!/usr/bin/env mojo
#
# Native JSON model helpers for the Mojo port of python-telegram-bot v22.8.
# Licensed under LGPL-3.0-or-later; see LICENSE.

"""Shared field conversion helpers for Telegram model structs."""

from telegram._utils.json import JSON_OBJECT, JsonDocument
from std.collections.optional import Optional


struct ParsedStringField(Copyable):
    var value: String
    var api_kwargs: JsonDocument

    def __init__(out self, value: String, api_kwargs: JsonDocument):
        self.value = value
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.value = existing.value.copy()
        self.api_kwargs = existing.api_kwargs.copy()


struct ParsedOptionalStringField(Copyable):
    var value: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, value: Optional[String], api_kwargs: JsonDocument):
        self.value = value
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.value = existing.value
        self.api_kwargs = existing.api_kwargs.copy()


def empty_json_object() -> JsonDocument:
    var document = JsonDocument()
    document.root = document.add_object()
    return document^


def parse_string_field(data: JsonDocument, key: String) raises -> ParsedStringField:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("JSON value is not an object")
    var value_index = data.object_get(data.root, key)
    if value_index == -1:
        raise Error("JSON object is missing required string field")
    var value = data.string_value(value_index)
    var api_kwargs = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        if data.nodes[child].name != key:
            var copied = api_kwargs.copy_subtree_from(data, child)
            api_kwargs.object_set(api_kwargs.root, data.nodes[child].name.copy(), copied)
        child = data.nodes[child].next_sibling
    return ParsedStringField(value, api_kwargs)


def string_field_to_json(key: String, value: String, api_kwargs: JsonDocument) raises -> JsonDocument:
    var result = empty_json_object()
    result.set_string(result.root, key, value)
    result.merge_object(result.root, api_kwargs.copy(), api_kwargs.root)
    return result^


def parse_optional_string_field(data: JsonDocument, key: String) raises -> ParsedOptionalStringField:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("JSON value is not an object")
    var value_index = data.object_get(data.root, key)
    var value: Optional[String] = None
    if value_index != -1 and not data.is_null(value_index):
        value = Optional[String](data.string_value(value_index))
    var api_kwargs = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        if data.nodes[child].name != key:
            var copied = api_kwargs.copy_subtree_from(data, child)
            api_kwargs.object_set(api_kwargs.root, data.nodes[child].name.copy(), copied)
        child = data.nodes[child].next_sibling
    return ParsedOptionalStringField(value, api_kwargs)


def optional_string_field_to_json(
    key: String, value: Optional[String], api_kwargs: JsonDocument
) raises -> JsonDocument:
    var result = empty_json_object()
    if value is not None:
        result.set_string(result.root, key, value.value())
    result.merge_object(result.root, api_kwargs.copy(), api_kwargs.root)
    return result^
