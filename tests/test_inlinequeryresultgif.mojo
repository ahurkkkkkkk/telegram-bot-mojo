from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultgif import InlineQueryResultGif
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultGif(
        "gif-result",
        "https://example.test/anim.gif",
        "https://example.test/thumb.jpg",
        Optional[Int](480),
        Optional[Int](270),
        Optional[String]("Loop"),
        gif_duration=Optional[TimeDelta](TimeDelta(4, 500000)),
        thumbnail_mime_type=Optional[String]("image/gif"),
    )
    assert_equal(result.type, "gif")
    assert_equal(result.id, "gif-result")
    assert_equal(result.gif_url, "https://example.test/anim.gif")
    assert_equal(result.title.value(), "Loop")
    assert_equal(result.gif_duration.value().total_seconds(), 4.5)

    var decoded = InlineQueryResultGif.de_json(
        parse_json(
            "{\"type\":\"gif\",\"id\":\"gif-result\",\"gif_url\":\"https://example.test/anim.gif\",\"thumbnail_url\":\"https://example.test/thumb.jpg\",\"gif_width\":480,\"gif_height\":270,\"title\":\"Loop\",\"caption\":\"watch\",\"gif_duration\":4.5,\"thumbnail_mime_type\":\"image/gif\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.gif_width.value(), 480)
    assert_equal(decoded.gif_duration.value().total_seconds(), 4.5)
    assert_equal(decoded.thumbnail_mime_type.value(), "image/gif")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultGif.de_list(parse_json('[{"id":"x","gif_url":"u","thumbnail_url":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultGif.de_json(parse_json('{"id":"missing-thumbnail","gif_url":"u"}'))
