from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultdocument import InlineQueryResultDocument
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultDocument(
        "document-result",
        "https://example.test/report.pdf",
        "Report",
        "application/pdf",
        thumbnail_url=Optional[String]("https://example.test/thumb.jpg"),
        thumbnail_width=Optional[Int](160),
        thumbnail_height=Optional[Int](90),
    )
    assert_equal(result.type, "document")
    assert_equal(result.id, "document-result")
    assert_equal(result.document_url, "https://example.test/report.pdf")
    assert_equal(result.title, "Report")
    assert_equal(result.mime_type, "application/pdf")

    var decoded = InlineQueryResultDocument.de_json(
        parse_json(
            "{\"type\":\"document\",\"id\":\"document-result\",\"document_url\":\"https://example.test/report.pdf\",\"title\":\"Report\",\"mime_type\":\"application/pdf\",\"description\":\"Annual report\",\"caption\":\"open\",\"thumbnail_url\":\"https://example.test/thumb.jpg\",\"thumbnail_width\":160,\"thumbnail_height\":90,\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.description.value(), "Annual report")
    assert_equal(decoded.thumbnail_width.value(), 160)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(len(InlineQueryResultDocument.de_list(parse_json('[{"id":"x","document_url":"u","title":"t","mime_type":"application/pdf"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultDocument.de_json(parse_json('{"id":"missing-mime","document_url":"u","title":"t"}'))
