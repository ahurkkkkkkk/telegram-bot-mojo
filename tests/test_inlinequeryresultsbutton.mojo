from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InlineQueryResultsButton, WebAppInfo
from telegram._utils.json import parse_json


def main() raises:
    var button = InlineQueryResultsButton(
        "Open", Optional[WebAppInfo](WebAppInfo("https://example.test/app").copy())
    )
    assert_equal(InlineQueryResultsButton.MIN_START_PARAMETER_LENGTH, 1)
    assert_equal(InlineQueryResultsButton.MAX_START_PARAMETER_LENGTH, 64)
    assert_equal(
        button.to_json(),
        "{\"text\": \"Open\", \"web_app\": {\"url\": \"https://example.test/app\"}}",
    )
    var decoded = InlineQueryResultsButton.de_json(
        parse_json("{\"text\":\"Start\",\"start_parameter\":\"join_1\",\"web_app\":null,\"future\":1}")
    )
    assert_equal(decoded.start_parameter.value(), "join_1")
    assert_equal(
        decoded.to_json(),
        "{\"text\": \"Start\", \"start_parameter\": \"join_1\", \"future\": 1}",
    )
    assert_equal(
        decoded == InlineQueryResultsButton("Start", None, Optional[String]("join_1")),
        True,
    )
    assert_equal(
        hash(decoded), hash(InlineQueryResultsButton("Start", None, Optional[String]("join_1")))
    )
    assert_equal(len(InlineQueryResultsButton.de_list(parse_json("[{\"text\":\"x\"}]"), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultsButton.de_json(parse_json("{}"))
