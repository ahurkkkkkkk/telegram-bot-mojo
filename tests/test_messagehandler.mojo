from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import MessageHandler
from telegram.ext.filters import BaseFilter, TEXT


def main() raises:
    var text_update = Update.de_json(parse_json(
        '{"update_id":1,"message":{"message_id":1,"date":10,'
        '"chat":{"id":5,"type":"private"},"text":"hello"}}'
    ))
    var no_text_update = Update.de_json(parse_json(
        '{"update_id":2,"message":{"message_id":2,"date":10,'
        '"chat":{"id":5,"type":"private"}}}'
    ))
    var some_text_update = Optional[Update](text_update^)
    var some_no_text_update = Optional[Update](no_text_update^)
    var no_update: Optional[Update] = None

    var default_handler = MessageHandler(None)
    assert_equal(default_handler.check_update(no_update) is None, True)
    assert_equal(default_handler.check_update(some_text_update).value(), True)

    var optional_text_filter = Optional[BaseFilter](TEXT)
    var text_handler = MessageHandler(optional_text_filter)
    assert_equal(text_handler.check_update(some_text_update).value(), True)
    assert_equal(text_handler.check_update(some_no_text_update).value(), False)

    var nonblocking = MessageHandler(optional_text_filter, False)
    assert_equal(nonblocking.resolve_block(True), False)
    assert_equal(nonblocking.check_update(some_text_update).value(), True)
