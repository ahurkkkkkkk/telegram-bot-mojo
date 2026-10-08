from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import LivePhoto, PhotoSize
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var photos = List[PhotoSize]()
    photos.append(PhotoSize("p", "pu", 200, 100))
    var live = LivePhoto(
        "f", "u", 640, 480, TimeDelta(3), Optional[List[PhotoSize]](photos^),
        Optional[String]("video/mp4"), Optional[Int](2048)
    )
    assert_equal(
        live.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"width\": 640, \"height\": 480, \"duration\": 3, \"photo\": [{\"file_id\": \"p\", \"file_unique_id\": \"pu\", \"height\": 100, \"width\": 200}], \"mime_type\": \"video/mp4\", \"file_size\": 2048}"
    )
    var decoded = LivePhoto.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"width\":1,\"height\":2,\"duration\":2.5,\"photo\":[{\"file_id\":\"p\",\"file_unique_id\":\"pu\",\"width\":3,\"height\":4}],\"future\":true}")
    )
    assert_equal(decoded.duration, TimeDelta(2.5))
    assert_equal(len(decoded.photo), 1)
    assert_equal(decoded.photo[0].file_unique_id, "pu")
    assert_equal(decoded == LivePhoto("x", "u", 1, 1, TimeDelta(0)), True)
    assert_equal(hash(decoded), hash(LivePhoto("x", "u", 1, 1, TimeDelta(1))))
    assert_equal(
        len(LivePhoto.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"width\":1,\"height\":1,\"duration\":0}]"), 0)),
        1,
    )
    with assert_raises():
        _ = LivePhoto.de_json(parse_json("{}"))
