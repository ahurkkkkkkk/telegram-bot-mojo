from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import InlineQueryHandler


def main() raises:
    var no_update: Optional[Update] = None
    var handler = InlineQueryHandler()
    assert_equal(handler.check_update(no_update) is None, True)

    var update = Update.de_json(
        parse_json(
            '{"update_id":4,"inline_query":{"id":"iq-1",'
            '"from":{"id":2,"first_name":"A","is_bot":false},'
            '"query":"hello","offset":"","chat_type":"sender"}}'
        )
    )
    var update_value = Optional[Update](update^)
    assert_equal(handler.check_update(update_value).value(), True)

    var allowed_types = List[String]()
    allowed_types.append("sender")
    var allowed_handler = InlineQueryHandler(
        Optional[List[String]](allowed_types.copy())
    )
    assert_equal(allowed_handler.check_update(update_value).value(), True)
    var excluded_types = List[String]()
    excluded_types.append("private")
    var excluded_handler = InlineQueryHandler(
        Optional[List[String]](excluded_types.copy())
    )
    assert_equal(excluded_handler.check_update(update_value).value(), False)

    var matching_pattern = InlineQueryHandler(
        pattern=Optional[String]("^hel")
    )
    assert_equal(matching_pattern.check_update(update_value).value(), True)
    var nonmatching_pattern = InlineQueryHandler(
        pattern=Optional[String]("^bye")
    )
    assert_equal(nonmatching_pattern.check_update(update_value) is None, True)

    var nonblocking = InlineQueryHandler(False)
    assert_equal(nonblocking.resolve_block(True), False)
