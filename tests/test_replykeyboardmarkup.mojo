from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import KeyboardButton, ReplyKeyboardMarkup
from telegram._utils.json import parse_json


def main() raises:
    var decoded = ReplyKeyboardMarkup.de_json(parse_json(
        '{"keyboard":[["A",{"text":"B","request_contact":false}],["C"]],'
        '"resize_keyboard":true,"one_time_keyboard":false,"selective":true,'
        '"input_field_placeholder":"Choose","is_persistent":false,"future":8}'
    ))
    assert_equal(len(decoded.keyboard), 2)
    assert_equal(len(decoded.keyboard[0]), 2)
    assert_equal(decoded.keyboard[0][0].text, "A")
    assert_equal(decoded.keyboard[0][1].text, "B")
    assert_equal(decoded.keyboard[0][1].request_contact.value(), False)
    assert_equal(decoded.keyboard[1][0].text, "C")
    assert_equal(decoded.resize_keyboard.value(), True)
    assert_equal(decoded.one_time_keyboard.value(), False)
    assert_equal(decoded.selective.value(), True)
    assert_equal(decoded.input_field_placeholder.value(), "Choose")
    assert_equal(decoded.is_persistent.value(), False)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)

    var encoded = decoded.to_dict()
    var keyboard_index = encoded.object_get(encoded.root, "keyboard")
    assert_equal(encoded.nodes[keyboard_index].kind, 4)
    var round_trip = ReplyKeyboardMarkup.de_json(parse_json(decoded.to_json()))
    assert_equal(round_trip == decoded, True)
    assert_equal(hash(round_trip), hash(decoded))

    var strings = List[List[String]]()
    var string_row = List[String]()
    string_row.append("x")
    string_row.append("y")
    strings.append(string_row^)
    var from_strings = ReplyKeyboardMarkup(strings)
    assert_equal(from_strings.keyboard[0][1].text, "y")
    var explicit_extras = ReplyKeyboardMarkup(strings, api_kwargs=parse_json('{"custom":3}'))
    assert_equal(explicit_extras.api_kwargs.object_get(explicit_extras.api_kwargs.root, "custom") != -1, True)

    var buttons = List[List[KeyboardButton]]()
    var button_row = List[KeyboardButton]()
    button_row.append(KeyboardButton("q"))
    buttons.append(button_row^)
    var from_buttons = ReplyKeyboardMarkup(buttons)
    assert_equal(from_buttons.keyboard[0][0].text, "q")
    assert_equal(ReplyKeyboardMarkup.MIN_INPUT_FIELD_PLACEHOLDER, 1)
    assert_equal(ReplyKeyboardMarkup.MAX_INPUT_FIELD_PLACEHOLDER, 64)

    var one = ReplyKeyboardMarkup.from_button(
        "one", resize_keyboard=True, api_kwargs=parse_json('{"custom":4}')
    )
    assert_equal(one.keyboard[0][0].text, "one")
    assert_equal(one.resize_keyboard.value(), True)
    assert_equal(one.api_kwargs.object_get(one.api_kwargs.root, "custom") != -1, True)
    var model_button = ReplyKeyboardMarkup.from_button(
        KeyboardButton("model"), one_time_keyboard=True
    )
    assert_equal(model_button.keyboard[0][0].text, "model")
    assert_equal(model_button.one_time_keyboard.value(), True)
    var row_items = List[String]()
    row_items.append("r1")
    row_items.append("r2")
    var row_markup = ReplyKeyboardMarkup.from_row(row_items)
    assert_equal(len(row_markup.keyboard[0]), 2)
    var model_row_items = List[KeyboardButton]()
    model_row_items.append(KeyboardButton("mr1"))
    model_row_items.append(KeyboardButton("mr2"))
    var model_row_markup = ReplyKeyboardMarkup.from_row(model_row_items)
    assert_equal(len(model_row_markup.keyboard[0]), 2)
    var column_items = List[String]()
    column_items.append("c1")
    column_items.append("c2")
    var column_markup = ReplyKeyboardMarkup.from_column(column_items)
    assert_equal(len(column_markup.keyboard), 2)
    var model_column_items = List[KeyboardButton]()
    model_column_items.append(KeyboardButton("mc1"))
    model_column_items.append(KeyboardButton("mc2"))
    var model_column_markup = ReplyKeyboardMarkup.from_column(model_column_items)
    assert_equal(len(model_column_markup.keyboard), 2)
    var empty = ReplyKeyboardMarkup.de_json(parse_json('{"keyboard":[]}'))
    assert_equal(len(empty.keyboard), 0)
