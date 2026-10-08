from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import ChosenInlineResultHandler


def main() raises:
    var no_update: Optional[Update] = None
    var handler = ChosenInlineResultHandler()
    assert_equal(handler.check_update(no_update) is None, True)

    var update = Update.de_json(
        parse_json(
            '{"update_id":3,"chosen_inline_result":{"result_id":"r-1",'
            '"from":{"id":2,"first_name":"A","is_bot":false},"query":"q"}}'
        )
    )
    var update_value = Optional[Update](update^)
    assert_equal(handler.check_update(update_value).value(), True)

    var matching = ChosenInlineResultHandler(
        pattern=Optional[String]("^r-[0-9]+$")
    )
    assert_equal(matching.check_update(update_value).value(), True)
    var nonmatching = ChosenInlineResultHandler(
        pattern=Optional[String]("^other")
    )
    assert_equal(nonmatching.check_update(update_value) is None, True)

    var nonblocking = ChosenInlineResultHandler(False)
    assert_equal(nonblocking.resolve_block(True), False)
