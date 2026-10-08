from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import VideoQuality
from telegram._utils.json import parse_json


def main() raises:
    var quality = VideoQuality("file", "stable", 1920, 1080, "h264", Optional[Int](4096))
    assert_equal(
        quality.to_json(),
        "{\"file_id\": \"file\", \"file_unique_id\": \"stable\", \"file_size\": 4096, \"codec\": \"h264\", \"height\": 1080, \"width\": 1920}",
    )
    var decoded = VideoQuality.de_json(
        parse_json("{\"file_id\":\"file\",\"file_unique_id\":\"stable\",\"width\":1920,\"height\":1080,\"codec\":\"h264\",\"future\":1}")
    )
    assert_equal(decoded.codec, "h264")
    assert_equal(decoded.file_size is None, True)
    assert_equal(decoded == VideoQuality("other", "stable", 1, 1, "vp9"), True)
    assert_equal(hash(decoded), hash(VideoQuality("other", "stable", 1, 1, "vp9")))
    var listed = VideoQuality.de_list(
        parse_json("[{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"width\":1,\"height\":2,\"codec\":\"av01\"}]"),
        0,
    )
    assert_equal(len(listed), 1)
    assert_equal(listed[0].codec, "av01")
    with assert_raises():
        _ = VideoQuality.de_json(parse_json("{}"))
