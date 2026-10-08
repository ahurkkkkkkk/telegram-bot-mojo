from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    InlineQueryResultCachedAudio,
    InputMessageContent,
    MessageEntity,
)
from telegram._utils.json import parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity(MessageEntity.BOLD, 0, 4))
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("listen"))
    var content = InputMessageContent()
    var result = InlineQueryResultCachedAudio(
        "audio-result",
        "audio-file",
        Optional[String]("caption"),
        Optional[InlineKeyboardMarkup](markup.copy()),
        Optional[InputMessageContent](content.copy()),
        Optional[String]("HTML"),
        Optional[List[MessageEntity]](entities^),
    )
    assert_equal(result.type, "audio")
    assert_equal(result.id, "audio-result")
    assert_equal(result.audio_file_id, "audio-file")
    assert_equal(result.caption_entities[0].type, MessageEntity.BOLD)
    assert_equal(result.reply_markup.value() == markup, True)

    var decoded = InlineQueryResultCachedAudio.de_json(
        parse_json(
            "{\"type\":\"audio\",\"id\":\"audio-result\",\"audio_file_id\":\"audio-file\",\"caption\":\"caption\",\"parse_mode\":\"HTML\",\"caption_entities\":[{\"type\":\"bold\",\"offset\":0,\"length\":4}],\"reply_markup\":{\"inline_keyboard\":[[{\"text\":\"listen\"}]]},\"input_message_content\":{\"future_content\":true},\"future_result\":9}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.caption.value(), "caption")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(decoded.input_message_content.value().api_kwargs.object_get(decoded.input_message_content.value().api_kwargs.root, "future_content") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "caption_entities") != -1, True)
    assert_equal(len(InlineQueryResultCachedAudio.de_list(parse_json('[{"id":"x","audio_file_id":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedAudio.de_json(parse_json('{"id":"missing-audio"}'))
