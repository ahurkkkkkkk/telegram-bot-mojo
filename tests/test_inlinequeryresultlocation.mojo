from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    InlineQueryResultLocation,
    InputMessageContent,
)
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("open map"))
    var content = InputMessageContent()
    var result = InlineQueryResultLocation(
        "location-id", 37.8, -122.4, "Here", Optional[TimeDelta](TimeDelta(3600)),
        Optional[InlineKeyboardMarkup](markup.copy()),
        Optional[InputMessageContent](content.copy()), Optional[Float64](5.5),
        Optional[Int](90), Optional[Int](100), Optional[String]("https://example.com/map.png"),
        Optional[Int](120), Optional[Int](80),
    )
    assert_equal(result.type, "location")
    assert_equal(result.latitude, 37.8)
    assert_equal(result.live_period.value().total_seconds(), 3600.0)
    assert_equal(result.horizontal_accuracy.value(), 5.5)
    assert_equal(result.proximity_alert_radius.value(), 100)

    var decoded = InlineQueryResultLocation.de_json(
        parse_json(
            '{"type":"location","id":"location-id","latitude":37.8,"longitude":-122.4,"title":"Here","live_period":3600,"reply_markup":{"inline_keyboard":[[{"text":"open map"}]]},"input_message_content":{"text":"location content"},"horizontal_accuracy":5.5,"heading":90,"proximity_alert_radius":100,"thumbnail_url":"https://example.com/map.png","thumbnail_width":120,"thumbnail_height":80,"future":true}'
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(decoded.live_period.value().total_seconds(), 3600.0)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "live_period") != -1, True)
    assert_equal(len(InlineQueryResultLocation.de_list(parse_json('[{"id":"i","latitude":0,"longitude":0,"title":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultLocation.de_json(parse_json('{"id":"missing-coordinates"}'))
