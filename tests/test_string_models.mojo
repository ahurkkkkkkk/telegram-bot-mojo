from std.testing import assert_equal

from telegram import CopyTextButton, PreparedKeyboardButton, SentGuestMessage
from telegram._utils.json import parse_json


def main() raises:
    var copy_button = CopyTextButton.de_json(
        parse_json("{\"text\":\"Copy me\",\"future\":true}")
    )
    assert_equal(copy_button.text, "Copy me")
    assert_equal(copy_button == CopyTextButton("Copy me"), True)
    assert_equal(hash(copy_button), hash(CopyTextButton("Copy me")))
    assert_equal(
        copy_button.to_json(),
        "{\"text\": \"Copy me\", \"future\": true}",
    )
    var copy_items = CopyTextButton.de_list(
        parse_json("[{\"text\":\"one\"},{\"text\":\"two\"}]"), 0
    )
    assert_equal(len(copy_items), 2)
    assert_equal(copy_items[1].text, "two")

    var guest = SentGuestMessage.de_json(
        parse_json("{\"inline_message_id\":\"inline-1\"}")
    )
    assert_equal(guest.inline_message_id, "inline-1")
    assert_equal(guest == SentGuestMessage("inline-1"), True)
    assert_equal(hash(guest), hash(SentGuestMessage("inline-1")))
    assert_equal(guest.to_json(), "{\"inline_message_id\": \"inline-1\"}")

    var prepared = PreparedKeyboardButton.de_json(
        parse_json("{\"id\":\"button-1\"}")
    )
    assert_equal(prepared.id, "button-1")
    assert_equal(prepared == PreparedKeyboardButton("button-1"), True)
    assert_equal(hash(prepared), hash(PreparedKeyboardButton("button-1")))
    assert_equal(prepared.to_json(), "{\"id\": \"button-1\"}")
