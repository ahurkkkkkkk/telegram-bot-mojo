from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    InlineQueryResultContact,
    InputMessageContent,
)
from telegram._utils.json import parse_json


def main() raises:
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("open"))
    var content = InputMessageContent()
    var result = InlineQueryResultContact(
        "contact-id", "+15551234567", "Ada", Optional[String]("Lovelace"),
        Optional[InlineKeyboardMarkup](markup.copy()),
        Optional[InputMessageContent](content.copy()),
        Optional[String]("BEGIN:VCARD"), Optional[String]("https://example.com/p.png"),
        Optional[Int](240), Optional[Int](320),
    )
    assert_equal(result.type, "contact")
    assert_equal(result.phone_number, "+15551234567")
    assert_equal(result.first_name, "Ada")
    assert_equal(result.last_name.value(), "Lovelace")
    assert_equal(result.thumbnail_height.value(), 320)

    var decoded = InlineQueryResultContact.de_json(
        parse_json(
            '{"type":"contact","id":"contact-id","phone_number":"+15551234567","first_name":"Ada","last_name":"Lovelace","reply_markup":{"inline_keyboard":[[{"text":"open"}]]},"input_message_content":{"text":"raw content"},"vcard":"BEGIN:VCARD","thumbnail_url":"https://example.com/p.png","thumbnail_width":240,"thumbnail_height":320,"future":true}'
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(decoded.input_message_content.value().api_kwargs.object_get(decoded.input_message_content.value().api_kwargs.root, "text") != -1, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "vcard") != -1, True)
    assert_equal(len(InlineQueryResultContact.de_list(parse_json('[{"id":"i","phone_number":"p","first_name":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultContact.de_json(parse_json('{"id":"missing-phone"}'))
