from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultmpeg4gif import InlineQueryResultMpeg4Gif
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultMpeg4Gif(
        "mpeg4-result",
        "https://example.test/clip.mp4",
        "https://example.test/thumb.jpg",
        Optional[Int](480),
        Optional[Int](270),
        Optional[String]("Loop"),
        mpeg4_duration=Optional[TimeDelta](TimeDelta(4, 500000)),
        thumbnail_mime_type=Optional[String]("image/gif"),
    )
    assert_equal(result.type, "mpeg4_gif")
    assert_equal(result.id, "mpeg4-result")
    assert_equal(result.mpeg4_url, "https://example.test/clip.mp4")
    assert_equal(result.title.value(), "Loop")
    assert_equal(result.mpeg4_duration.value().total_seconds(), 4.5)

    var decoded = InlineQueryResultMpeg4Gif.de_json(
        parse_json(
            "{\"type\":\"gif\",\"id\":\"mpeg4-result\",\"mpeg4_url\":\"https://example.test/clip.mp4\",\"thumbnail_url\":\"https://example.test/thumb.jpg\",\"mpeg4_width\":480,\"mpeg4_height\":270,\"title\":\"Loop\",\"caption\":\"watch\",\"mpeg4_duration\":4.5,\"thumbnail_mime_type\":\"image/gif\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.mpeg4_width.value(), 480)
    assert_equal(decoded.mpeg4_duration.value().total_seconds(), 4.5)
    assert_equal(decoded.thumbnail_mime_type.value(), "image/gif")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultMpeg4Gif.de_list(parse_json('[{"id":"x","mpeg4_url":"u","thumbnail_url":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultMpeg4Gif.de_json(parse_json('{"id":"missing-thumbnail","mpeg4_url":"u"}'))
