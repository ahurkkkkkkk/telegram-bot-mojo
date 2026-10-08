from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Document, PhotoSize
from telegram._utils.json import parse_json


def main() raises:
    var thumbnail = PhotoSize("thumb", "thumb-u", 80, 60)
    var document = Document(
        "file-1",
        "unique-1",
        Optional[String]("report.pdf"),
        Optional[String]("application/pdf"),
        Optional[Int](4096),
        Optional[PhotoSize](thumbnail.copy()),
    )
    assert_equal(
        document.to_json(),
        "{\"file_id\": \"file-1\", \"file_unique_id\": \"unique-1\", \"file_name\": \"report.pdf\", \"mime_type\": \"application/pdf\", \"file_size\": 4096, \"thumbnail\": {\"file_id\": \"thumb\", \"file_unique_id\": \"thumb-u\", \"height\": 60, \"width\": 80}}",
    )
    var decoded = Document.de_json(
        parse_json("{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"file_name\":null,\"thumbnail\":null,\"thumb\":{\"legacy\":true},\"future\":[1,2]}")
    )
    assert_equal(decoded.file_id, "f")
    assert_equal(decoded.file_name is None, True)
    assert_equal(decoded.thumbnail is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"file_id\": \"f\", \"file_unique_id\": \"u\", \"thumb\": {\"legacy\": true}, \"future\": [1, 2]}",
    )
    assert_equal(decoded == Document("other", "u"), True)
    assert_equal(hash(decoded), hash(Document("other", "u")))
    assert_equal(
        len(Document.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\"}]"), 0)),
        1,
    )
    with assert_raises():
        _ = Document.de_json(parse_json("{}"))
