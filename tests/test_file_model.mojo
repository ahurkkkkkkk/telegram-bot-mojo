from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import File
from telegram._utils.json import parse_json


def main() raises:
    var file_value = File(
        "id-1", "unique-1", Optional[Int](1024), Optional[String]("documents/report.pdf")
    )
    assert_equal(
        file_value.to_json(),
        "{\"file_id\": \"id-1\", \"file_unique_id\": \"unique-1\", \"file_size\": 1024, \"file_path\": \"documents/report.pdf\"}",
    )
    var decoded = File.de_json(
        parse_json("{\"file_id\":\"id\",\"file_unique_id\":\"u\",\"file_size\":null,\"file_path\":null,\"future\":true}")
    )
    assert_equal(decoded.file_size is None, True)
    assert_equal(decoded.file_path is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"id\", \"file_unique_id\": \"u\", \"future\": true}",
    )
    assert_equal(decoded == File("another", "u"), True)
    assert_equal(hash(decoded), hash(File("another", "u")))
    assert_equal(len(File.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\"}]"), 0)), 1)
    with assert_raises():
        _ = File.de_json(parse_json("{}"))
