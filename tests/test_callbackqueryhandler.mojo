from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import CallbackQueryHandler


def main() raises:
    var no_update: Optional[Update] = None
    var no_pattern = CallbackQueryHandler()
    assert_equal(no_pattern.check_update(no_update) is None, True)

    var update = Update.de_json(
        parse_json(
            '{"update_id":1,"callback_query":{"id":"q-1",'
            '"from":{"id":7,"is_bot":false,"first_name":"A"},'
            '"chat_instance":"ci","data":"open:42"}}'
        )
    )
    var update_value = Optional[Update](update^)
    assert_equal(no_pattern.check_update(update_value).value(), True)

    var data_handler = CallbackQueryHandler(
        pattern=Optional[String]("^open:[0-9]+$")
    )
    assert_equal(data_handler.check_update(update_value).value(), True)
    var no_match_handler = CallbackQueryHandler(
        pattern=Optional[String]("^close:")
    )
    assert_equal(no_match_handler.check_update(update_value).value(), False)

    var game_update = Update.de_json(
        parse_json(
            '{"update_id":2,"callback_query":{"id":"q-2",'
            '"from":{"id":7,"is_bot":false,"first_name":"A"},'
            '"chat_instance":"ci","game_short_name":"chess"}}'
        )
    )
    var game_update_value = Optional[Update](game_update^)
    var game_handler = CallbackQueryHandler(
        game_pattern=Optional[String]("^chess$")
    )
    assert_equal(game_handler.check_update(game_update_value).value(), True)
    assert_equal(data_handler.check_update(game_update_value).value(), False)

    var empty_data_update = Update.de_json(
        parse_json(
            '{"update_id":3,"callback_query":{"id":"q-3",'
            '"from":{"id":7,"is_bot":false,"first_name":"A"},'
            '"chat_instance":"ci","data":""}}'
        )
    )
    var empty_data_value = Optional[Update](empty_data_update^)
    assert_equal(data_handler.check_update(empty_data_value).value(), True)
