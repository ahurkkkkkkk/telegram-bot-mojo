from std.testing import assert_equal, assert_raises

from telegram._update import Update
from telegram._utils.json import parse_json
from telegram.ext.filters import CaptionRegex, Regex


def main() raises:
    var text_update = Update.de_json(
        parse_json(
            '{"update_id":1,"message":{"message_id":1,"date":1,'
            '"chat":{"id":10,"type":"private"},"text":"please help me"}}'
        )
    )
    var text_filter = Regex("help")
    assert_equal(text_filter.data_filter, True)
    assert_equal(text_filter.check_update(text_update), True)
    assert_equal(Regex("^help").check_update(text_update), False)

    var caption_update = Update.de_json(
        parse_json(
            '{"update_id":2,"message":{"message_id":2,"date":1,'
            '"chat":{"id":10,"type":"private"},"caption":"hello photo"}}'
        )
    )
    assert_equal(CaptionRegex("^hello").check_update(caption_update), True)
    assert_equal(CaptionRegex("goodbye").check_update(caption_update), False)

    with assert_raises():
        _ = Regex("[")
