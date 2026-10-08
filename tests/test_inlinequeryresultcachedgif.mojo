from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultcachedgif import InlineQueryResultCachedGif
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultCachedGif("gif-result", "gif-file")
    assert_equal(result.type, "gif")
    assert_equal(result.id, "gif-result")
    assert_equal(result.gif_file_id, "gif-file")
    assert_equal(result.title is None, True)

    var decoded = InlineQueryResultCachedGif.de_json(
        parse_json(
            "{\"type\":\"gif\",\"id\":\"gif-result\",\"gif_file_id\":\"gif-file\",\"title\":\"Loop\",\"caption\":\"watch\",\"parse_mode\":\"HTML\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.title.value(), "Loop")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "show_caption_above_media") != -1, True)
    assert_equal(len(InlineQueryResultCachedGif.de_list(parse_json('[{"id":"x","gif_file_id":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedGif.de_json(parse_json('{"gif_file_id":"f"}'))

    var show_false = InlineQueryResultCachedGif(
        "other", "gif-file-2", show_caption_above_media=Optional[Bool](False)
    )
    assert_equal(show_false.show_caption_above_media.value(), False)
