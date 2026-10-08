from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultcachedphoto import InlineQueryResultCachedPhoto
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultCachedPhoto("photo-result", "photo-file")
    assert_equal(result.type, "photo")
    assert_equal(result.id, "photo-result")
    assert_equal(result.photo_file_id, "photo-file")
    assert_equal(result.title is None, True)

    var decoded = InlineQueryResultCachedPhoto.de_json(
        parse_json(
            "{\"type\":\"photo\",\"id\":\"photo-result\",\"photo_file_id\":\"photo-file\",\"title\":\"Sunset\",\"description\":\"Evening\",\"caption\":\"look\",\"parse_mode\":\"HTML\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.title.value(), "Sunset")
    assert_equal(decoded.description.value(), "Evening")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultCachedPhoto.de_list(parse_json('[{"id":"x","photo_file_id":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedPhoto.de_json(parse_json('{"id":"missing-photo"}'))

    var show_false = InlineQueryResultCachedPhoto(
        "other", "photo-file-2", show_caption_above_media=Optional[Bool](False)
    )
    assert_equal(show_false.show_caption_above_media.value(), False)
