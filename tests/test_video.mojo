from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import PhotoSize, Video, VideoQuality
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var cover = List[PhotoSize]()
    cover.append(PhotoSize("cover", "cover-u", 200, 100))
    var qualities = List[VideoQuality]()
    qualities.append(VideoQuality("hq", "hq-u", 1280, 720, "h264"))
    var video = Video(
        "f", "u", 1280, 720, TimeDelta(30),
        Optional[String]("video/mp4"), Optional[Int](9000), Optional[String]("clip.mp4"),
        None, Optional[List[PhotoSize]](cover^), Optional[TimeDelta](TimeDelta(2)),
        Optional[List[VideoQuality]](qualities^)
    )
    assert_equal(
        video.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"width\": 1280, \"height\": 720, \"duration\": 30, \"mime_type\": \"video/mp4\", \"file_size\": 9000, \"file_name\": \"clip.mp4\", \"cover\": [{\"file_id\": \"cover\", \"file_unique_id\": \"cover-u\", \"height\": 100, \"width\": 200}], \"start_timestamp\": 2, \"qualities\": [{\"file_id\": \"hq\", \"file_unique_id\": \"hq-u\", \"codec\": \"h264\", \"height\": 720, \"width\": 1280}]}"
    )
    var decoded = Video.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"width\":640,\"height\":360,\"duration\":12,\"cover\":[{\"file_id\":\"c\",\"file_unique_id\":\"cu\",\"width\":1,\"height\":2}],\"start_timestamp\":1.5,\"qualities\":[{\"file_id\":\"q\",\"file_unique_id\":\"qu\",\"width\":2,\"height\":1,\"codec\":\"vp9\"}],\"future\":true}")
    )
    assert_equal(decoded.duration, TimeDelta(12))
    assert_equal(decoded.start_timestamp is not None, True)
    assert_equal(decoded.start_timestamp.value(), TimeDelta(1.5))
    assert_equal(len(decoded.cover), 1)
    assert_equal(decoded.cover[0].file_unique_id, "cu")
    assert_equal(len(decoded.qualities), 1)
    assert_equal(decoded.qualities[0].codec, "vp9")
    assert_equal(decoded == Video("other", "u", 1, 1, TimeDelta(1)), True)
    assert_equal(hash(decoded), hash(Video("other", "u", 1, 1, TimeDelta(2))))
    assert_equal(
        len(Video.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"width\":1,\"height\":1,\"duration\":0}]"), 0)),
        1,
    )
    with assert_raises():
        _ = Video.de_json(parse_json("{}"))
