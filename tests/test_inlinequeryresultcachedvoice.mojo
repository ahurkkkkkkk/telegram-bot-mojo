from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InlineQueryResultCachedVoice
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultCachedVoice("voice-result", "voice-file", "note")
    assert_equal(result.type, "voice")
    assert_equal(result.id, "voice-result")
    assert_equal(result.voice_file_id, "voice-file")
    assert_equal(result.title, "note")

    var decoded = InlineQueryResultCachedVoice.de_json(
        parse_json(
            "{\"type\":\"voice\",\"id\":\"voice-result\",\"voice_file_id\":\"voice-file\",\"title\":\"note\",\"caption\":\"say this\",\"parse_mode\":\"HTML\",\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.caption.value(), "say this")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "title") != -1, True)
    assert_equal(len(InlineQueryResultCachedVoice.de_list(parse_json('[{"id":"x","voice_file_id":"f","title":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedVoice.de_json(parse_json('{"id":"missing-title","voice_file_id":"f"}'))

    var with_caption = InlineQueryResultCachedVoice(
        "other", "voice-file-2", "memo", caption=Optional[String]("caption")
    )
    assert_equal(with_caption.caption.value(), "caption")
