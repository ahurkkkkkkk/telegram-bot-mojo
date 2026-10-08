from std.testing import assert_equal

from telegram._utils.entities import parse_message_entity


def main() raises:
    var text = "A😀BC"
    assert_equal(parse_message_entity(text, 0, 1), "A")
    assert_equal(parse_message_entity(text, 1, 2), "😀")
    assert_equal(parse_message_entity(text, 3, 2), "BC")
    assert_equal(parse_message_entity(text, -2, 1), "B")
    assert_equal(parse_message_entity(text, 50, 5), "")
    assert_equal(parse_message_entity(text, 2, 0), "")
