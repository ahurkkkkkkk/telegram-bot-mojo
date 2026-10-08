from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    InlineQueryResultCachedSticker,
    InputMessageContent,
)
from telegram._utils.json import parse_json


def main() raises:
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("open"))
    var content = InputMessageContent()
    var result = InlineQueryResultCachedSticker(
        "sticker-result", "sticker-file",
        Optional[InlineKeyboardMarkup](markup.copy()),
        Optional[InputMessageContent](content.copy()),
    )
    assert_equal(result.type, "sticker")
    assert_equal(result.id, "sticker-result")
    assert_equal(result.sticker_file_id, "sticker-file")
    assert_equal(result.reply_markup.value() == markup, True)

    var decoded = InlineQueryResultCachedSticker.de_json(
        parse_json(
            '{"type":"sticker","id":"sticker-result","sticker_file_id":"sticker-file","reply_markup":{"inline_keyboard":[[{"text":"open"}]]},"input_message_content":{"future_content":true},"future_result":9}'
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(decoded.input_message_content.value().api_kwargs.object_get(decoded.input_message_content.value().api_kwargs.root, "future_content") != -1, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "input_message_content") != -1, True)
    assert_equal(len(InlineQueryResultCachedSticker.de_list(parse_json('[{"id":"x","sticker_file_id":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedSticker.de_json(parse_json('{"id":"missing-sticker"}'))
