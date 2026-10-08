from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultvoice import InlineQueryResultVoice
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultVoice(
        "voice-result",
        "https://example.test/voice.ogg",
        "Note",
        Optional[TimeDelta](TimeDelta(8, 250000)),
    )
    assert_equal(result.type, "voice")
    assert_equal(result.id, "voice-result")
    assert_equal(result.voice_url, "https://example.test/voice.ogg")
    assert_equal(result.title, "Note")
    assert_equal(result.voice_duration.value().total_seconds(), 8.25)

    var decoded = InlineQueryResultVoice.de_json(
        parse_json(
            "{\"type\":\"voice\",\"id\":\"voice-result\",\"voice_url\":\"https://example.test/voice.ogg\",\"title\":\"Note\",\"voice_duration\":8.25,\"caption\":\"listen\",\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.voice_duration.value().total_seconds(), 8.25)
    assert_equal(decoded.caption.value(), "listen")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultVoice.de_list(parse_json('[{"id":"x","voice_url":"u","title":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultVoice.de_json(parse_json('{"id":"missing-title","voice_url":"u"}'))
