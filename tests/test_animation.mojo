from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Animation, PhotoSize
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var thumb = PhotoSize("thumb", "tu", 80, 60)
    var animation = Animation(
        "f", "u", 640, 480, TimeDelta(4), Optional[String]("clip.gif"),
        Optional[String]("image/gif"), Optional[Int](1000), Optional[PhotoSize](thumb.copy())
    )
    assert_equal(
        animation.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"width\": 640, \"height\": 480, \"duration\": 4, \"file_name\": \"clip.gif\", \"mime_type\": \"image/gif\", \"file_size\": 1000, \"thumbnail\": {\"file_id\": \"thumb\", \"file_unique_id\": \"tu\", \"height\": 60, \"width\": 80}}",
    )
    var decoded = Animation.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"width\":1,\"height\":2,\"duration\":1.5,\"future\":false}")
    )
    assert_equal(decoded.duration, TimeDelta(1.5))
    assert_equal(decoded.to_json(), "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"width\": 1, \"height\": 2, \"duration\": 1.5, \"future\": false}")
    assert_equal(decoded == Animation("x", "u", 2, 3, TimeDelta(1)), True)
    assert_equal(hash(decoded), hash(Animation("x", "u", 2, 3, TimeDelta(1))))
    assert_equal(len(Animation.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"width\":1,\"height\":1,\"duration\":0}]"), 0)), 1)
    with assert_raises():
        _ = Animation.de_json(parse_json("{}"))
