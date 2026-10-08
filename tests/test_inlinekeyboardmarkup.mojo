from std.collections import List
from std.testing import assert_equal, assert_raises

from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from telegram._utils.json import parse_json


def main() raises:
    var first_row = List[InlineKeyboardButton]()
    first_row.append(InlineKeyboardButton("one"))
    first_row.append(InlineKeyboardButton("two"))
    var second_row = List[InlineKeyboardButton]()
    second_row.append(InlineKeyboardButton("three"))
    var grid = List[List[InlineKeyboardButton]]()
    grid.append(first_row^)
    grid.append(second_row^)

    var markup = InlineKeyboardMarkup(grid)
    assert_equal(len(markup.inline_keyboard), 2)
    assert_equal(markup.inline_keyboard[0][1].text, "two")
    assert_equal(markup.to_json(), '{"inline_keyboard": [[{"text": "one"}, {"text": "two"}], [{"text": "three"}]]}')

    var decoded = InlineKeyboardMarkup.de_json(
        parse_json('{"inline_keyboard":[[{"text":"one"},{"text":"two"}],[{"text":"three"}]],"future":true}')
    )
    assert_equal(decoded == markup, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "future") != -1, True)
    assert_equal(InlineKeyboardMarkup.from_button(InlineKeyboardButton("solo")).inline_keyboard[0][0].text, "solo")

    var column = List[InlineKeyboardButton]()
    column.append(InlineKeyboardButton("top"))
    column.append(InlineKeyboardButton("bottom"))
    assert_equal(len(InlineKeyboardMarkup.from_column(column).inline_keyboard), 2)
    assert_equal(len(InlineKeyboardMarkup.from_row(column).inline_keyboard), 1)
    assert_equal(len(InlineKeyboardMarkup.de_list(parse_json('[{"inline_keyboard":[]}]'), 0)), 1)
    with assert_raises():
        _ = InlineKeyboardMarkup.de_json(parse_json('{"inline_keyboard":[[1]]}'))
