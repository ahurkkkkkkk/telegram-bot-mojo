from std.testing import assert_equal

from telegram import KeyboardButtonPollType, SentWebAppMessage
from telegram._utils.json import parse_json


def main() raises:
    var missing = SentWebAppMessage.de_json(parse_json("{}"))
    assert_equal(missing.inline_message_id is None, True)
    assert_equal(missing.to_json(), "{}")
    assert_equal(missing == SentWebAppMessage(), True)
    assert_equal(hash(missing), hash(SentWebAppMessage()))

    var explicit_null = SentWebAppMessage.de_json(
        parse_json("{\"inline_message_id\":null}")
    )
    assert_equal(explicit_null == missing, True)

    var present = SentWebAppMessage.de_json(
        parse_json("{\"inline_message_id\":\"inline-2\"}")
    )
    assert_equal(present.inline_message_id.value(), "inline-2")
    assert_equal(present.to_json(), "{\"inline_message_id\": \"inline-2\"}")
    assert_equal(present == SentWebAppMessage("inline-2"), True)
    assert_equal(hash(present), hash(SentWebAppMessage("inline-2")))

    var unspecified_poll = KeyboardButtonPollType.de_json(parse_json("{}"))
    assert_equal(unspecified_poll.type is None, True)
    assert_equal(unspecified_poll.to_json(), "{}")

    var quiz = KeyboardButtonPollType.de_json(
        parse_json("{\"type\":\"quiz\"}")
    )
    assert_equal(quiz.type.value(), "quiz")
    assert_equal(quiz.to_json(), "{\"type\": \"quiz\"}")
    assert_equal(quiz == KeyboardButtonPollType("quiz"), True)
