#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineKeyboardMarkup.
# LGPL-3.0-or-later; see LICENSE.

"""A rectangular or ragged grid of inline Telegram buttons."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardbutton import InlineKeyboardButton
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct InlineKeyboardMarkup(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Keyboard grid; equality compares the rows and buttons in order."""

    var inline_keyboard: List[List[InlineKeyboardButton]]
    var api_kwargs: JsonDocument

    def __init__(out self, inline_keyboard: List[List[InlineKeyboardButton]]):
        self.inline_keyboard = _copy_inline_keyboard(inline_keyboard)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        inline_keyboard: List[List[InlineKeyboardButton]],
        *,
        api_kwargs: JsonDocument,
    ):
        self.inline_keyboard = _copy_inline_keyboard(inline_keyboard)
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.inline_keyboard = _copy_inline_keyboard(existing.inline_keyboard)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if len(self.inline_keyboard) != len(other.inline_keyboard):
            return False
        for row_index in range(len(self.inline_keyboard)):
            var left_row = self.inline_keyboard[row_index].copy()
            var right_row = other.inline_keyboard[row_index].copy()
            if len(left_row) != len(right_row):
                return False
            for button_index in range(len(left_row)):
                if left_row[button_index] != right_row[button_index]:
                    return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        # The grid dimensions are a valid hash subset of the full identity value.
        hasher.update(String("InlineKeyboardMarkup\0").as_bytes())
        hasher.update(String(len(self.inline_keyboard)).as_bytes())
        for row_index in range(len(self.inline_keyboard)):
            hasher.update(String("\0").as_bytes())
            hasher.update(String(len(self.inline_keyboard[row_index])).as_bytes())

    @staticmethod
    def from_button(button: InlineKeyboardButton) -> Self:
        var row = List[InlineKeyboardButton]()
        row.append(button.copy())
        var grid = List[List[InlineKeyboardButton]]()
        grid.append(row^)
        return InlineKeyboardMarkup(grid)

    @staticmethod
    def from_row(button_row: List[InlineKeyboardButton]) -> Self:
        var grid = List[List[InlineKeyboardButton]]()
        grid.append(button_row.copy())
        return InlineKeyboardMarkup(grid)

    @staticmethod
    def from_column(button_column: List[InlineKeyboardButton]) -> Self:
        var grid = List[List[InlineKeyboardButton]]()
        for index in range(len(button_column)):
            var row = List[InlineKeyboardButton]()
            row.append(button_column[index].copy())
            grid.append(row^)
        return InlineKeyboardMarkup(grid)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var grid = result.add_array()
        for row_index in range(len(self.inline_keyboard)):
            var row = result.add_array()
            for button_index in range(len(self.inline_keyboard[row_index])):
                var button_data = self.inline_keyboard[row_index][button_index].to_dict(recursive)
                var button = result.copy_subtree_from(button_data, button_data.root)
                result.append_child(row, button)
            result.append_child(grid, row)
        result.object_set(result.root, "inline_keyboard", grid)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineKeyboardMarkup JSON value must be an object")
        var keyboard_index = data.object_get(data.root, "inline_keyboard")
        if keyboard_index == -1 or data.nodes[keyboard_index].kind != JSON_ARRAY:
            raise Error("InlineKeyboardMarkup JSON object is missing an inline_keyboard array")
        var grid = List[List[InlineKeyboardButton]]()
        var row_index = data.nodes[keyboard_index].first_child
        while row_index != -1:
            if data.nodes[row_index].kind != JSON_ARRAY:
                raise Error("InlineKeyboardMarkup rows must be arrays")
            var row = List[InlineKeyboardButton]()
            var button_index = data.nodes[row_index].first_child
            while button_index != -1:
                if data.nodes[button_index].kind != JSON_OBJECT:
                    raise Error("InlineKeyboardMarkup buttons must be objects")
                var button_data = JsonDocument()
                button_data.root = button_data.copy_subtree_from(data, button_index)
                row.append(InlineKeyboardButton.de_json(button_data))
                button_index = data.nodes[button_index].next_sibling
            grid.append(row^)
            row_index = data.nodes[row_index].next_sibling

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "inline_keyboard":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineKeyboardMarkup(grid, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineKeyboardMarkup.de_json(items[index].copy()))
        return result^


def _copy_inline_keyboard(
    inline_keyboard: List[List[InlineKeyboardButton]],
) -> List[List[InlineKeyboardButton]]:
    var result = List[List[InlineKeyboardButton]]()
    for row_index in range(len(inline_keyboard)):
        var source_row = inline_keyboard[row_index].copy()
        var row = List[InlineKeyboardButton]()
        for button_index in range(len(source_row)):
            row.append(source_row[button_index].copy())
        result.append(row^)
    return result^
