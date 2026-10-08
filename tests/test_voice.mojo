from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Voice
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var voice = Voice(
        "file-1", "unique-1", TimeDelta(12), Optional[String]("audio/ogg"), Optional[Int](321)
    )
    assert_equal(
        voice.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"duration\": 12, \"mime_type\": \"audio/ogg\", \"file_size\": 321}",
    )
    var decoded = Voice.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"duration\":1.25,\"future\":true}")
    )
    assert_equal(decoded.duration, TimeDelta(1.25))
    assert_equal(decoded.mime_type is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"duration\": 1.25, \"future\": true}",
    )
    assert_equal(decoded == Voice("other", "u", TimeDelta(99)), True)
    assert_equal(hash(decoded), hash(Voice("other", "u", TimeDelta(99))))
    assert_equal(
        len(Voice.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"duration\":0}]"), 0)),
        1,
    )
    with assert_raises():
        _ = Voice.de_json(parse_json("{}"))
