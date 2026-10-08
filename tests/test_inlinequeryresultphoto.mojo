from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultphoto import InlineQueryResultPhoto
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultPhoto(
        "photo-result",
        "https://example.test/photo.jpg",
        "https://example.test/thumb.jpg",
        Optional[Int](640),
        Optional[Int](480),
        Optional[String]("Sunset"),
    )
    assert_equal(result.type, "photo")
    assert_equal(result.id, "photo-result")
    assert_equal(result.photo_url, "https://example.test/photo.jpg")
    assert_equal(result.thumbnail_url, "https://example.test/thumb.jpg")
    assert_equal(result.photo_width.value(), 640)
    assert_equal(result.title.value(), "Sunset")

    var decoded = InlineQueryResultPhoto.de_json(
        parse_json(
            "{\"type\":\"photo\",\"id\":\"photo-result\",\"photo_url\":\"https://example.test/photo.jpg\",\"thumbnail_url\":\"https://example.test/thumb.jpg\",\"photo_width\":640,\"photo_height\":480,\"title\":\"Sunset\",\"description\":\"Evening\",\"caption\":\"look\",\"show_caption_above_media\":true,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.photo_height.value(), 480)
    assert_equal(decoded.description.value(), "Evening")
    assert_equal(decoded.show_caption_above_media.value(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultPhoto.de_list(parse_json('[{"id":"x","photo_url":"u","thumbnail_url":"t"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultPhoto.de_json(parse_json('{"id":"missing-thumbnail","photo_url":"u"}'))

    var no_above = InlineQueryResultPhoto(
        "other", "photo-url", "thumb-url", show_caption_above_media=Optional[Bool](False)
    )
    assert_equal(no_above.show_caption_above_media.value(), False)
