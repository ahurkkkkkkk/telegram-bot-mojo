from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Audio, PhotoSize
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var thumbnail = PhotoSize("cover", "cover-u", 300, 300)
    var audio = Audio(
        "file-1",
        "unique-1",
        TimeDelta(180),
        Optional[String]("Artist"),
        Optional[String]("Song"),
        Optional[String]("audio/mpeg"),
        Optional[Int](7000),
        Optional[String]("song.mp3"),
        Optional[PhotoSize](thumbnail.copy()),
    )
    assert_equal(
        audio.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"duration\": 180, \"performer\": \"Artist\", \"title\": \"Song\", \"mime_type\": \"audio/mpeg\", \"file_size\": 7000, \"file_name\": \"song.mp3\", \"thumbnail\": {\"file_id\": \"cover\", \"file_unique_id\": \"cover-u\", \"height\": 300, \"width\": 300}}",
    )
    var decoded = Audio.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"duration\":60,\"performer\":null,\"thumbnail\":{\"file_id\":\"t\",\"file_unique_id\":\"tu\",\"width\":64,\"height\":48},\"future\":{\"x\":1}}")
    )
    assert_equal(decoded.performer is None, True)
    assert_equal(decoded.thumbnail is not None, True)
    assert_equal(decoded.thumbnail.value().width, 64)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"duration\": 60, \"thumbnail\": {\"file_id\": \"t\", \"file_unique_id\": \"tu\", \"height\": 48, \"width\": 64}, \"future\": {\"x\": 1}}",
    )
    assert_equal(decoded == Audio("other", "u", TimeDelta(1)), True)
    assert_equal(hash(decoded), hash(Audio("other", "u", TimeDelta(2))))
    assert_equal(
        len(Audio.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"duration\":0}]"), 0)),
        1,
    )
    with assert_raises():
        _ = Audio.de_json(parse_json("{}"))
