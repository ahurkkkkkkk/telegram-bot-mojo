#!/usr/bin/env mojo
#
# Native Mojo translation of ReplyKeyboardMarkup from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""A custom reply keyboard made up of rows of keyboard buttons."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._keyboardbutton import KeyboardButton
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._utils.markup import check_keyboard_type


struct ReplyKeyboardMarkup(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A two-dimensional reply keyboard with Telegram serialization support."""

    comptime MIN_INPUT_FIELD_PLACEHOLDER = 1
    comptime MAX_INPUT_FIELD_PLACEHOLDER = 64

    var keyboard: List[List[KeyboardButton]]
    var resize_keyboard: Optional[Bool]
    var one_time_keyboard: Optional[Bool]
    var selective: Optional[Bool]
    var input_field_placeholder: Optional[String]
    var is_persistent: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        keyboard: List[List[KeyboardButton]],
        resize_keyboard: Optional[Bool] = None,
        one_time_keyboard: Optional[Bool] = None,
        selective: Optional[Bool] = None,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
    ) raises:
        if not check_keyboard_type(keyboard):
            raise Error("keyboard must be a sequence of rows of buttons")
        self.keyboard = _copy_reply_keyboard(keyboard)
        self.resize_keyboard = resize_keyboard.copy()
        self.one_time_keyboard = one_time_keyboard.copy()
        self.selective = selective.copy()
        self.input_field_placeholder = input_field_placeholder.copy()
        self.is_persistent = is_persistent.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        keyboard: List[List[KeyboardButton]],
        resize_keyboard: Optional[Bool] = None,
        one_time_keyboard: Optional[Bool] = None,
        selective: Optional[Bool] = None,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ) raises:
        if not check_keyboard_type(keyboard):
            raise Error("keyboard must be a sequence of rows of buttons")
        self.keyboard = _copy_reply_keyboard(keyboard)
        self.resize_keyboard = resize_keyboard.copy()
        self.one_time_keyboard = one_time_keyboard.copy()
        self.selective = selective.copy()
        self.input_field_placeholder = input_field_placeholder.copy()
        self.is_persistent = is_persistent.copy()
        self.api_kwargs = api_kwargs.copy()

    def __init__(
        out self,
        keyboard: List[List[String]],
        resize_keyboard: Optional[Bool] = None,
        one_time_keyboard: Optional[Bool] = None,
        selective: Optional[Bool] = None,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
    ) raises:
        if not check_keyboard_type(keyboard):
            raise Error("keyboard must be a sequence of rows of strings")
        self.keyboard = _reply_keyboard_from_strings(keyboard)
        self.resize_keyboard = resize_keyboard.copy()
        self.one_time_keyboard = one_time_keyboard.copy()
        self.selective = selective.copy()
        self.input_field_placeholder = input_field_placeholder.copy()
        self.is_persistent = is_persistent.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        keyboard: List[List[String]],
        resize_keyboard: Optional[Bool] = None,
        one_time_keyboard: Optional[Bool] = None,
        selective: Optional[Bool] = None,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ) raises:
        if not check_keyboard_type(keyboard):
            raise Error("keyboard must be a sequence of rows of strings")
        self.keyboard = _reply_keyboard_from_strings(keyboard)
        self.resize_keyboard = resize_keyboard.copy()
        self.one_time_keyboard = one_time_keyboard.copy()
        self.selective = selective.copy()
        self.input_field_placeholder = input_field_placeholder.copy()
        self.is_persistent = is_persistent.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.keyboard = _copy_reply_keyboard(existing.keyboard)
        self.resize_keyboard = existing.resize_keyboard.copy()
        self.one_time_keyboard = existing.one_time_keyboard.copy()
        self.selective = existing.selective.copy()
        self.input_field_placeholder = existing.input_field_placeholder.copy()
        self.is_persistent = existing.is_persistent.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if len(self.keyboard) != len(other.keyboard):
            return False
        for row_index in range(len(self.keyboard)):
            var left_row = self.keyboard[row_index].copy()
            var right_row = other.keyboard[row_index].copy()
            if len(left_row) != len(right_row):
                return False
            for button_index in range(len(left_row)):
                if left_row[button_index] != right_row[button_index]:
                    return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        # Dimensions are a valid subset of the keyboard-based equality identity.
        hasher.update(String("ReplyKeyboardMarkup\0").as_bytes())
        hasher.update(String(len(self.keyboard)).as_bytes())
        for row_index in range(len(self.keyboard)):
            hasher.update(String("\0").as_bytes())
            hasher.update(String(len(self.keyboard[row_index])).as_bytes())

    @staticmethod
    def from_button(
        button: KeyboardButton,
        resize_keyboard: Bool = False,
        one_time_keyboard: Bool = False,
        selective: Bool = False,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var row = List[KeyboardButton]()
        row.append(button.copy())
        var grid = List[List[KeyboardButton]]()
        grid.append(row^)
        return _new_reply_keyboard_markup(
            grid,
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs,
        )

    @staticmethod
    def from_button(
        button: String,
        resize_keyboard: Bool = False,
        one_time_keyboard: Bool = False,
        selective: Bool = False,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var row = List[String]()
        row.append(button.copy())
        var grid = List[List[String]]()
        grid.append(row^)
        return _new_reply_keyboard_markup(
            _reply_keyboard_from_strings(grid),
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs,
        )

    @staticmethod
    def from_row(
        button_row: List[KeyboardButton],
        resize_keyboard: Bool = False,
        one_time_keyboard: Bool = False,
        selective: Bool = False,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var grid = List[List[KeyboardButton]]()
        grid.append(button_row.copy())
        return _new_reply_keyboard_markup(
            grid,
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs,
        )

    @staticmethod
    def from_row(
        button_row: List[String],
        resize_keyboard: Bool = False,
        one_time_keyboard: Bool = False,
        selective: Bool = False,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var grid = List[List[String]]()
        grid.append(button_row.copy())
        return _new_reply_keyboard_markup(
            _reply_keyboard_from_strings(grid),
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs,
        )

    @staticmethod
    def from_column(
        button_column: List[KeyboardButton],
        resize_keyboard: Bool = False,
        one_time_keyboard: Bool = False,
        selective: Bool = False,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var grid = List[List[KeyboardButton]]()
        for index in range(len(button_column)):
            var row = List[KeyboardButton]()
            row.append(button_column[index].copy())
            grid.append(row^)
        return _new_reply_keyboard_markup(
            grid,
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs,
        )

    @staticmethod
    def from_column(
        button_column: List[String],
        resize_keyboard: Bool = False,
        one_time_keyboard: Bool = False,
        selective: Bool = False,
        input_field_placeholder: Optional[String] = None,
        is_persistent: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var grid = List[List[String]]()
        for index in range(len(button_column)):
            var row = List[String]()
            row.append(button_column[index].copy())
            grid.append(row^)
        return _new_reply_keyboard_markup(
            _reply_keyboard_from_strings(grid),
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs,
        )

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.input_field_placeholder is not None:
            result.set_string(result.root, "input_field_placeholder", self.input_field_placeholder.value())
        if self.is_persistent is not None:
            result.set_boolean(result.root, "is_persistent", self.is_persistent.value())
        var grid = result.add_array()
        for row_index in range(len(self.keyboard)):
            var row = result.add_array()
            var buttons = self.keyboard[row_index].copy()
            for button_index in range(len(buttons)):
                var button_data = buttons[button_index].to_dict(recursive)
                var button = result.copy_subtree_from(button_data, button_data.root)
                result.append_child(row, button)
            result.append_child(grid, row)
        result.object_set(result.root, "keyboard", grid)
        if self.one_time_keyboard is not None:
            result.set_boolean(result.root, "one_time_keyboard", self.one_time_keyboard.value())
        if self.resize_keyboard is not None:
            result.set_boolean(result.root, "resize_keyboard", self.resize_keyboard.value())
        if self.selective is not None:
            result.set_boolean(result.root, "selective", self.selective.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ReplyKeyboardMarkup JSON value must be an object")
        var keyboard_index = data.object_get(data.root, "keyboard")
        if keyboard_index == -1 or data.nodes[keyboard_index].kind != JSON_ARRAY:
            raise Error("ReplyKeyboardMarkup JSON object is missing a keyboard array")
        var grid = List[List[KeyboardButton]]()
        var row_index = data.nodes[keyboard_index].first_child
        while row_index != -1:
            if data.nodes[row_index].kind != JSON_ARRAY:
                raise Error("ReplyKeyboardMarkup keyboard rows must be arrays")
            var row = List[KeyboardButton]()
            var button_index = data.nodes[row_index].first_child
            while button_index != -1:
                if data.nodes[button_index].kind == JSON_STRING:
                    row.append(KeyboardButton(data.string_value(button_index)))
                elif data.nodes[button_index].kind == JSON_OBJECT:
                    var button_data = JsonDocument()
                    button_data.root = button_data.copy_subtree_from(data, button_index)
                    row.append(KeyboardButton.de_json(button_data))
                else:
                    raise Error("ReplyKeyboardMarkup buttons must be strings or button objects")
                button_index = data.nodes[button_index].next_sibling
            grid.append(row^)
            row_index = data.nodes[row_index].next_sibling

        var resize_keyboard: Optional[Bool] = None
        var index = data.object_get(data.root, "resize_keyboard")
        if index != -1 and not data.is_null(index):
            resize_keyboard = Optional[Bool](data.boolean_value(index))
        var one_time_keyboard: Optional[Bool] = None
        index = data.object_get(data.root, "one_time_keyboard")
        if index != -1 and not data.is_null(index):
            one_time_keyboard = Optional[Bool](data.boolean_value(index))
        var selective: Optional[Bool] = None
        index = data.object_get(data.root, "selective")
        if index != -1 and not data.is_null(index):
            selective = Optional[Bool](data.boolean_value(index))
        var input_field_placeholder: Optional[String] = None
        index = data.object_get(data.root, "input_field_placeholder")
        if index != -1 and not data.is_null(index):
            input_field_placeholder = Optional[String](data.string_value(index))
        var is_persistent: Optional[Bool] = None
        index = data.object_get(data.root, "is_persistent")
        if index != -1 and not data.is_null(index):
            is_persistent = Optional[Bool](data.boolean_value(index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "keyboard" or key == "resize_keyboard" or key == "one_time_keyboard" or
                key == "selective" or key == "input_field_placeholder" or key == "is_persistent"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            grid,
            resize_keyboard,
            one_time_keyboard,
            selective,
            input_field_placeholder,
            is_persistent,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


def _new_reply_keyboard_markup(
    keyboard: List[List[KeyboardButton]],
    resize_keyboard: Bool,
    one_time_keyboard: Bool,
    selective: Bool,
    input_field_placeholder: Optional[String],
    is_persistent: Optional[Bool],
    api_kwargs: Optional[JsonDocument],
) raises -> ReplyKeyboardMarkup:
    if api_kwargs is None:
        return ReplyKeyboardMarkup(
            keyboard,
            Optional[Bool](resize_keyboard),
            Optional[Bool](one_time_keyboard),
            Optional[Bool](selective),
            input_field_placeholder,
            is_persistent,
        )
    return ReplyKeyboardMarkup(
        keyboard,
        Optional[Bool](resize_keyboard),
        Optional[Bool](one_time_keyboard),
        Optional[Bool](selective),
        input_field_placeholder,
        is_persistent,
        api_kwargs=api_kwargs.value(),
    )


def _copy_reply_keyboard(keyboard: List[List[KeyboardButton]]) -> List[List[KeyboardButton]]:
    var result = List[List[KeyboardButton]]()
    for row_index in range(len(keyboard)):
        var source_row = keyboard[row_index].copy()
        var row = List[KeyboardButton]()
        for button_index in range(len(source_row)):
            row.append(source_row[button_index].copy())
        result.append(row^)
    return result^


def _reply_keyboard_from_strings(keyboard: List[List[String]]) -> List[List[KeyboardButton]]:
    var result = List[List[KeyboardButton]]()
    for row_index in range(len(keyboard)):
        var source_row = keyboard[row_index].copy()
        var row = List[KeyboardButton]()
        for button_index in range(len(source_row)):
            row.append(KeyboardButton(source_row[button_index]))
        result.append(row^)
    return result^
