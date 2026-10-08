from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultcachedmpeg4gif import InlineQueryResultCachedMpeg4Gif
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultCachedMpeg4Gif("mpeg4-result", "mpeg4-file")
    assert_equal(result.type, "mpeg4_gif")
    assert_equal(result.id, "mpeg4-result")
    assert_equal(result.mpeg4_file_id, "mpeg4-file")
    assert_equal(result.title is None, True)

    var decoded = InlineQueryResultCachedMpeg4Gif.de_json(
        parse_json(
            "{\"type\":\"gif\",\"id\":\"mpeg4-result\",\"mpeg4_file_id\":\"mpeg4-file\",\"title\":\"Loop\",\"caption\":\"watch\",\"parse_mode\":\"HTML\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.title.value(), "Loop")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "show_caption_above_media") != -1, True)
    assert_equal(len(InlineQueryResultCachedMpeg4Gif.de_list(parse_json('[{"id":"x","mpeg4_file_id":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedMpeg4Gif.de_json(parse_json('{"mpeg4_file_id":"f"}'))

    var show_false = InlineQueryResultCachedMpeg4Gif(
        "other", "mpeg4-file-2", show_caption_above_media=Optional[Bool](False)
    )
    assert_equal(show_false.show_caption_above_media.value(), False)
