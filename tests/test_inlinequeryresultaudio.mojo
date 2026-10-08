from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultaudio import InlineQueryResultAudio
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultAudio(
        "audio-result",
        "https://example.test/audio.mp3",
        "Song",
        performer=Optional[String]("Artist"),
        audio_duration=Optional[TimeDelta](TimeDelta(12, 500000)),
    )
    assert_equal(result.type, "audio")
    assert_equal(result.id, "audio-result")
    assert_equal(result.audio_url, "https://example.test/audio.mp3")
    assert_equal(result.title, "Song")
    assert_equal(result.performer.value(), "Artist")
    assert_equal(result.audio_duration.value().total_seconds(), 12.5)

    var decoded = InlineQueryResultAudio.de_json(
        parse_json(
            "{\"type\":\"audio\",\"id\":\"audio-result\",\"audio_url\":\"https://example.test/audio.mp3\",\"title\":\"Song\",\"performer\":\"Artist\",\"audio_duration\":12.5,\"caption\":\"listen\",\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.audio_duration.value().total_seconds(), 12.5)
    assert_equal(decoded.caption.value(), "listen")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultAudio.de_list(parse_json('[{"id":"x","audio_url":"u","title":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultAudio.de_json(parse_json('{"id":"missing-title","audio_url":"u"}'))
