from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import CallbackGame, InputMessageContent, ReplyKeyboardRemove
from telegram._utils.json import parse_json


def main() raises:
    var callback = CallbackGame.de_json(parse_json("{\"future\":1}"))
    assert_equal(callback.to_json(), "{\"future\": 1}")
    var callback_list = CallbackGame.de_list(parse_json("[{}, {\"future\":2}]"), 0)
    assert_equal(len(callback_list), 2)
    assert_equal(callback_list[1].to_json(), "{\"future\": 2}")

    var input_content = InputMessageContent.de_json(parse_json("{}"))
    assert_equal(input_content.to_json(), "{}")
    var extended_content = InputMessageContent.de_json(parse_json("{\"future\":\"x\"}"))
    assert_equal(extended_content.to_json(), "{\"future\": \"x\"}")

    var remove = ReplyKeyboardRemove()
    assert_equal(remove.remove_keyboard, True)
    assert_equal(remove.selective is None, True)
    assert_equal(remove.to_json(), "{\"remove_keyboard\": true}")

    var selective = ReplyKeyboardRemove(Optional[Bool](False))
    assert_equal(selective.to_json(), "{\"remove_keyboard\": true, \"selective\": false}")
    var decoded = ReplyKeyboardRemove.de_json(
        parse_json("{\"remove_keyboard\":true,\"selective\":false,\"future\":3}")
    )
    assert_equal(decoded.selective.value(), False)
    assert_equal(
        decoded.to_json(),
        "{\"remove_keyboard\": true, \"selective\": false, \"future\": 3}",
    )
    var listed = ReplyKeyboardRemove.de_list(parse_json("[{\"remove_keyboard\":true}]"), 0)
    assert_equal(len(listed), 1)

    with assert_raises():
        _ = CallbackGame.de_json(parse_json("[]"))
