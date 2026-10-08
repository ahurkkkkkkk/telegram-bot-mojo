#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _webappdata.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct WebAppData(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream WebAppData."""

    var data: String
    var button_text: String
    var api_kwargs: JsonDocument

    def __init__(out self, data: String, button_text: String):
        self.data = data
        self.button_text = button_text
        self.api_kwargs = empty_json_object()

    def __init__(out self, data: String, button_text: String, api_kwargs: JsonDocument):
        self.data = data
        self.button_text = button_text
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.button_text = existing.button_text.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.data == other.data and self.button_text == other.button_text

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.data.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.button_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "button_text", self.button_text)
        result.set_string(result.root, "data", self.data)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> WebAppData:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("WebAppData JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("WebAppData JSON value is not an object")
        var parsed_data_index = data.object_get(data.root, "data")
        if parsed_data_index == -1:
            raise Error("WebAppData JSON object is missing data")
        var parsed_data = data.string_value(parsed_data_index)
        var parsed_button_text_index = data.object_get(data.root, "button_text")
        if parsed_button_text_index == -1:
            raise Error("WebAppData JSON object is missing button_text")
        var parsed_button_text = data.string_value(parsed_button_text_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "data" and key != "button_text":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return WebAppData(parsed_data, parsed_button_text, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[WebAppData]:
        var items = data.array_documents(array_index)
        var result = List[WebAppData]()
        for index in range(len(items)):
            result.append(WebAppData.de_json(items[index].copy()))
        return result^
