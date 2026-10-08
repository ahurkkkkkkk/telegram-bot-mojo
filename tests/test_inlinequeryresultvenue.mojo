from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    InlineQueryResultVenue,
    InputMessageContent,
)
from telegram._utils.json import parse_json


def main() raises:
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("map"))
    var content = InputMessageContent()
    var result = InlineQueryResultVenue(
        "venue-id", 37.8, -122.4, "Cafe", "Main Street",
        Optional[String]("fsq"), Optional[String]("food/cafe"),
        Optional[InlineKeyboardMarkup](markup.copy()),
        Optional[InputMessageContent](content.copy()),
        Optional[String]("google-id"), Optional[String]("restaurant"),
        Optional[String]("https://example.com/thumb.png"), Optional[Int](90), Optional[Int](60),
    )
    assert_equal(result.type, "venue")
    assert_equal(result.latitude, 37.8)
    assert_equal(result.longitude, -122.4)
    assert_equal(result.google_place_type.value(), "restaurant")

    var decoded = InlineQueryResultVenue.de_json(
        parse_json(
            '{"type":"venue","id":"venue-id","latitude":37.8,"longitude":-122.4,"title":"Cafe","address":"Main Street","foursquare_id":"fsq","foursquare_type":"food/cafe","reply_markup":{"inline_keyboard":[[{"text":"map"}]]},"input_message_content":{"text":"venue content"},"google_place_id":"google-id","google_place_type":"restaurant","thumbnail_url":"https://example.com/thumb.png","thumbnail_width":90,"thumbnail_height":60,"future":true}'
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "google_place_id") != -1, True)
    assert_equal(len(InlineQueryResultVenue.de_list(parse_json('[{"id":"v","latitude":0,"longitude":0,"title":"t","address":"a"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultVenue.de_json(parse_json('{"id":"missing"}'))
