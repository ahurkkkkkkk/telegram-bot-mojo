from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import PhotoSize
from telegram._utils.json import parse_json


def main() raises:
    var photo = PhotoSize("file-1", "unique-1", 320, 240, Optional[Int](1024))
    assert_equal(
        photo.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"file_size\": 1024, \"height\": 240, \"width\": 320}",
    )
    var decoded = PhotoSize.de_json(
        parse_json("{\"file_id\":\"file-1\",\"file_unique_id\":\"unique-1\",\"width\":320,\"height\":240,\"file_size\":null,\"future\":true}")
    )
    assert_equal(decoded.file_id, "file-1")
    assert_equal(decoded.width, 320)
    assert_equal(decoded.height, 240)
    assert_equal(decoded.file_size is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"height\": 240, \"width\": 320, \"future\": true}",
    )
    assert_equal(decoded == PhotoSize("different-id", "unique-1", 1, 1), True)
    assert_equal(hash(decoded), hash(PhotoSize("different-id", "unique-1", 1, 1)))
    var listed = PhotoSize.de_list(
        parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"width\":1,\"height\":2}]"),
        0,
    )
    assert_equal(len(listed), 1)
    with assert_raises():
        _ = PhotoSize.de_json(parse_json("{}"))
