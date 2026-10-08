from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultcachedvideo import InlineQueryResultCachedVideo
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultCachedVideo("video-result", "video-file", "Trailer")
    assert_equal(result.type, "video")
    assert_equal(result.id, "video-result")
    assert_equal(result.video_file_id, "video-file")
    assert_equal(result.title, "Trailer")

    var decoded = InlineQueryResultCachedVideo.de_json(
        parse_json(
            "{\"type\":\"video\",\"id\":\"video-result\",\"video_file_id\":\"video-file\",\"title\":\"Trailer\",\"description\":\"Teaser\",\"caption\":\"watch\",\"parse_mode\":\"HTML\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.description.value(), "Teaser")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultCachedVideo.de_list(parse_json('[{"id":"x","video_file_id":"f","title":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedVideo.de_json(parse_json('{"id":"missing-title","video_file_id":"f"}'))

    var show_false = InlineQueryResultCachedVideo(
        "other", "video-file-2", "Clip", show_caption_above_media=Optional[Bool](False)
    )
    assert_equal(show_false.show_caption_above_media.value(), False)
