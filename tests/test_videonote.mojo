from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import PhotoSize, VideoNote
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var thumb = PhotoSize("thumb", "tu", 80, 60)
    var note = VideoNote("f", "u", 240, TimeDelta(12), Optional[Int](4096), Optional[PhotoSize](thumb.copy()))
    assert_equal(
        note.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"length\": 240, \"duration\": 12, \"file_size\": 4096, \"thumbnail\": {\"file_id\": \"thumb\", \"file_unique_id\": \"tu\", \"height\": 60, \"width\": 80}}",
    )
    var decoded = VideoNote.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"length\":2,\"duration\":1.25,\"future\":true}")
    )
    assert_equal(decoded.duration, TimeDelta(1.25))
    assert_equal(decoded.to_json(), "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"length\": 2, \"duration\": 1.25, \"future\": true}")
    assert_equal(decoded == VideoNote("x", "u", 1, TimeDelta(0)), True)
    assert_equal(hash(decoded), hash(VideoNote("x", "u", 1, TimeDelta(8))))
    assert_equal(len(VideoNote.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"length\":1,\"duration\":0}]"), 0)), 1)
    with assert_raises():
        _ = VideoNote.de_json(parse_json("{}"))
