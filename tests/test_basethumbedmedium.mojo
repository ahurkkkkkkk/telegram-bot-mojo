from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._files._basethumbedmedium import _BaseThumbedMedium
from telegram._files.photosize import PhotoSize
from telegram._utils.json import parse_json


def main() raises:
    var thumbnail = PhotoSize("thumb-1", "thumb-u1", 80, 60)
    var medium = _BaseThumbedMedium(
        "file-1",
        "unique-1",
        Optional[Int](4096),
        Optional[PhotoSize](thumbnail.copy()),
    )
    assert_equal(
        medium.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"file_size\": 4096, \"thumbnail\": {\"file_id\": \"thumb-1\", \"file_unique_id\": \"thumb-u1\", \"height\": 60, \"width\": 80}}",
    )

    var decoded = _BaseThumbedMedium.de_json(
        parse_json(
            "{\"file_id\":\"file-1\",\"file_unique_id\":\"unique-1\",\"thumbnail\":{\"file_id\":\"thumb-1\",\"file_unique_id\":\"thumb-u1\",\"width\":80,\"height\":60},\"thumb\":{\"legacy\":true},\"future\":[1,2]}"
        )
    )
    assert_equal(decoded.file_id, "file-1")
    assert_equal(decoded.thumbnail is not None, True)
    assert_equal(decoded.thumbnail.value().width, 80)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"thumbnail\": {\"file_id\": \"thumb-1\", \"file_unique_id\": \"thumb-u1\", \"height\": 60, \"width\": 80}, \"thumb\": {\"legacy\": true}, \"future\": [1, 2]}",
    )

    var explicit_null_legacy = _BaseThumbedMedium.de_json(
        parse_json("{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"thumbnail\":null,\"thumb\":null}")
    )
    assert_equal(explicit_null_legacy.thumbnail is None, True)
    assert_equal(
        explicit_null_legacy.to_json(),
        "{\"file_id\": \"a\", \"file_unique_id\": \"b\", \"thumb\": null}",
    )
    assert_equal(
        len(_BaseThumbedMedium.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\"}]"), 0)),
        1,
    )
    with assert_raises():
        _ = _BaseThumbedMedium.de_json(parse_json("{}"))
