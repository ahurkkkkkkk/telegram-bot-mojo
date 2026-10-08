from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    InlineQueryResultArticle,
    InputMessageContent,
)
from telegram._utils.json import parse_json


def main() raises:
    var content = InputMessageContent()
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("open"))
    var article = InlineQueryResultArticle(
        "article-id", "A title", content.copy(),
        Optional[InlineKeyboardMarkup](markup.copy()),
        Optional[String]("https://example.com"),
        Optional[String]("A short description"),
        Optional[String]("https://example.com/thumb.png"),
        Optional[Int](120),
        Optional[Int](80),
    )
    assert_equal(article.type, "article")
    assert_equal(article.title, "A title")
    assert_equal(article.thumbnail_width.value(), 120)
    assert_equal(article.thumbnail_height.value(), 80)
    assert_equal(article.reply_markup.value() == markup, True)

    var decoded = InlineQueryResultArticle.de_json(
        parse_json(
            '{"type":"article","id":"article-id","title":"A title","input_message_content":{"message_text":"hello"},"reply_markup":{"inline_keyboard":[[{"text":"open"}]]},"url":"https://example.com","description":"A short description","thumbnail_url":"https://example.com/thumb.png","thumbnail_width":120,"thumbnail_height":80,"future":true}'
        )
    )
    assert_equal(decoded == article, True)
    assert_equal(decoded.input_message_content.api_kwargs.object_get(decoded.input_message_content.api_kwargs.root, "message_text") != -1, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "thumbnail_width") != -1, True)
    assert_equal(len(InlineQueryResultArticle.de_list(parse_json('[{"id":"i","title":"t","input_message_content":{}}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultArticle.de_json(parse_json('{"id":"missing-content"}'))
