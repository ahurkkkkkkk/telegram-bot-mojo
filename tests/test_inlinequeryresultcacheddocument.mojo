from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._inline.inlinequeryresultcacheddocument import InlineQueryResultCachedDocument
from telegram._utils.json import parse_json


def main() raises:
    var result = InlineQueryResultCachedDocument("document-result", "Report", "document-file")
    assert_equal(result.type, "document")
    assert_equal(result.id, "document-result")
    assert_equal(result.title, "Report")
    assert_equal(result.document_file_id, "document-file")

    var decoded = InlineQueryResultCachedDocument.de_json(
        parse_json(
            "{\"type\":\"document\",\"id\":\"document-result\",\"title\":\"Report\",\"document_file_id\":\"document-file\",\"description\":\"PDF\",\"caption\":\"Open\",\"parse_mode\":\"HTML\",\"future_result\":true}"
        )
    )
    assert_equal(decoded == result, True)
    assert_equal(hash(decoded), hash(result))
    assert_equal(decoded.description.value(), "PDF")
    assert_equal(decoded.caption.value(), "Open")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_result") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "title") != -1, True)
    assert_equal(len(InlineQueryResultCachedDocument.de_list(parse_json('[{"id":"x","title":"t","document_file_id":"f"}]'), 0)), 1)
    with assert_raises():
        _ = InlineQueryResultCachedDocument.de_json(parse_json('{"id":"missing-title","document_file_id":"f"}'))

    var with_description = InlineQueryResultCachedDocument(
        "other", "Slides", "document-file-2", description=Optional[String]("deck")
    )
    assert_equal(with_description.description.value(), "deck")
