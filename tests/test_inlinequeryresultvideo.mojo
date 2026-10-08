from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultvideo import InlineQueryResultVideo
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultVideo(
        "video-result",
        "https://example.test/video.mp4",
        "video/mp4",
        "https://example.test/thumb.jpg",
        "Trailer",
        Optional[String]("Watch"),
        Optional[Int](1280),
        Optional[Int](720),
        Optional[TimeDelta](TimeDelta(90, 250000)),
    )
    assert_equal(result.type, "video")
    assert_equal(result.id, "video-result")
    assert_equal(result.video_url, "https://example.test/video.mp4")
    assert_equal(result.mime_type, "video/mp4")
    assert_equal(result.title, "Trailer")
    assert_equal(result.video_duration.value().total_seconds(), 90.25)

    var decoded = InlineQueryResultVideo.de_json(
        parse_json(
            "{\"type\":\"video\",\"id\":\"video-result\",\"video_url\":\"https://example.test/video.mp4\",\"mime_type\":\"video/mp4\",\"thumbnail_url\":\"https://example.test/thumb.jpg\",\"title\":\"Trailer\",\"caption\":\"Watch\",\"video_width\":1280,\"video_height\":720,\"video_duration\":90.25,\"description\":\"Teaser\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.video_width.value(), 1280)
    assert_equal(decoded.video_height.value(), 720)
    assert_equal(decoded.video_duration.value().total_seconds(), 90.25)
    assert_equal(decoded.description.value(), "Teaser")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultVideo.de_list(parse_json('[{"id":"x","video_url":"u","mime_type":"video/mp4","thumbnail_url":"t","title":"v"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultVideo.de_json(parse_json('{"id":"missing-type","video_url":"u","thumbnail_url":"t","title":"v"}'))
