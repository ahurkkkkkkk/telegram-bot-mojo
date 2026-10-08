from std.collections import List
from std.testing import assert_equal

from telegram._utils.markup import check_keyboard_type


def main() raises:
    var keyboard = List[List[String]]()
    var row = List[String]()
    row.append("A")
    row.append("B")
    keyboard.append(row.copy())
    assert_equal(check_keyboard_type(keyboard), True)

    var empty_keyboard = List[List[String]]()
    assert_equal(check_keyboard_type(empty_keyboard), True)

    var flat = List[String]()
    flat.append("not a row")
    assert_equal(check_keyboard_type(flat), False)
    assert_equal(check_keyboard_type(List[String]()), True)
    assert_equal(check_keyboard_type("not a keyboard"), False)

    var nested = List[List[List[String]]]()
    var nested_row = List[List[String]]()
    var nested_button = List[String]()
    nested_button.append("too deep")
    nested_row.append(nested_button.copy())
    nested.append(nested_row.copy())
    assert_equal(check_keyboard_type(nested), False)

    var nested_empty = List[List[List[String]]]()
    nested_empty.append(List[List[String]]())
    assert_equal(check_keyboard_type(nested_empty), True)
