from std.testing import assert_equal, assert_raises

from telegram import ChatPhoto
from telegram._utils.json import parse_json


def main() raises:
    var photo = ChatPhoto("small", "small-u", "big", "big-u")
    assert_equal(ChatPhoto.SIZE_SMALL, 160)
    assert_equal(ChatPhoto.SIZE_BIG, 640)
    assert_equal(
        photo.to_json(),
        "{\"small_file_id\": \"small\", \"small_file_unique_id\": \"small-u\", \"big_file_id\": \"big\", \"big_file_unique_id\": \"big-u\"}",
    )
    var decoded = ChatPhoto.de_json(
        parse_json("{\"small_file_id\":\"s\",\"small_file_unique_id\":\"su\",\"big_file_id\":\"b\",\"big_file_unique_id\":\"bu\",\"future\":1}")
    )
    assert_equal(decoded.small_file_id, "s")
    assert_equal(
        decoded.to_json(),
        "{\"small_file_id\": \"s\", \"small_file_unique_id\": \"su\", \"big_file_id\": \"b\", \"big_file_unique_id\": \"bu\", \"future\": 1}",
    )
    assert_equal(decoded == ChatPhoto("x", "su", "y", "bu"), True)
    assert_equal(hash(decoded), hash(ChatPhoto("x", "su", "y", "bu")))
    assert_equal(
        len(ChatPhoto.de_list(parse_json("[{\"small_file_id\":\"s\",\"small_file_unique_id\":\"su\",\"big_file_id\":\"b\",\"big_file_unique_id\":\"bu\"}]"), 0)),
        1,
    )
    with assert_raises():
        _ = ChatPhoto.de_json(parse_json("{}"))
