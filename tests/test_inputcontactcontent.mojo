from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InputContactMessageContent
from telegram._utils.json import parse_json


def main() raises:
    var content = InputContactMessageContent(
        "+15551234567", "Ada", Optional[String]("Lovelace"), Optional[String]("VCARD")
    )
    assert_equal(
        content.to_json(),
        "{\"phone_number\": \"+15551234567\", \"first_name\": \"Ada\", \"last_name\": \"Lovelace\", \"vcard\": \"VCARD\"}",
    )
    var decoded = InputContactMessageContent.de_json(
        parse_json("{\"phone_number\":\"+15551234567\",\"first_name\":\"Ada\",\"future\":9}")
    )
    assert_equal(decoded.last_name is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"phone_number\": \"+15551234567\", \"first_name\": \"Ada\", \"future\": 9}",
    )
    assert_equal(
        decoded == InputContactMessageContent("+15551234567", "Different"),
        True,
    )
    assert_equal(
        hash(decoded),
        hash(InputContactMessageContent("+15551234567", "Different")),
    )
    var listed = InputContactMessageContent.de_list(
        parse_json("[{\"phone_number\":\"1\",\"first_name\":\"A\"}]"), 0
    )
    assert_equal(len(listed), 1)
    assert_equal(listed[0].phone_number, "1")
    with assert_raises():
        _ = InputContactMessageContent.de_json(parse_json("{}"))
