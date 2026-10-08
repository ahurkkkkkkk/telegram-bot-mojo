from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._files._basemedium import _BaseMedium
from telegram._utils.json import parse_json


def main() raises:
    var medium = _BaseMedium("file-1", "unique-1", Optional[Int](2048))
    assert_equal(
        medium.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"file_size\": 2048}",
    )

    var decoded = _BaseMedium.de_json(
        parse_json(
            "{\"file_id\":\"file-1\",\"file_unique_id\":\"unique-1\",\"file_size\":null,\"future\":{\"ready\":true}}"
        )
    )
    assert_equal(decoded.file_id, "file-1")
    assert_equal(decoded.file_size is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"future\": {\"ready\": true}}",
    )

    var equal_identity = _BaseMedium("replacement-id", "unique-1")
    assert_equal(decoded == equal_identity, True)
    assert_equal(hash(decoded), hash(equal_identity))
    assert_equal(
        len(_BaseMedium.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\"}]"), 0)),
        1,
    )
    with assert_raises():
        _ = _BaseMedium.de_json(parse_json("{}"))
