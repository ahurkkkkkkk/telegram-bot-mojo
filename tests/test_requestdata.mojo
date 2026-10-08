from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import InputFile
from telegram.request import RequestData, RequestParameter
from telegram._utils.json import JsonDocument, parse_json


def main() raises:
    var parameters = List[RequestParameter]()
    parameters.append(RequestParameter.from_input("message", "hello world"))
    parameters.append(RequestParameter.from_input("count", 3))
    var file = InputFile("file bytes", filename=Optional[String]("note.txt"), attach=True)
    parameters.append(RequestParameter.from_input("upload", file))
    parameters.append(RequestParameter("omitted", Optional[JsonDocument](None)))

    var data = RequestData(parameters)
    assert_equal(data.contains_files, True)
    var payload = data.json_payload()
    assert_equal(len(payload) > 2, True)
    assert_equal(payload[0], UInt8(123))
    assert_equal(payload[len(payload) - 1], UInt8(125))
    var decoded = data.json_parameters()
    assert_equal(decoded.nodes[decoded.root].kind, 5)
    assert_equal(decoded.string_value(decoded.object_get(decoded.root, "message")), "hello world")
    assert_equal(decoded.string_value(decoded.object_get(decoded.root, "count")), "3")
    assert_equal(decoded.object_get(decoded.root, "omitted"), -1)

    var url = data.url_encoded_parameters()
    var encoded_message = "message=hello+world".as_bytes()
    var encoded_url = url.as_bytes()
    var found = False
    for index in range(len(encoded_url) - len(encoded_message) + 1):
        var matches = True
        for offset in range(len(encoded_message)):
            if encoded_url[index + offset] != encoded_message[offset]:
                matches = False
                break
        if matches:
            found = True
    assert_equal(found, True)
    var parametrized = data.parametrized_url("https://example.test/send")
    var expected_prefix = "https://example.test/send?".as_bytes()
    var actual_prefix = parametrized.as_bytes()
    var prefix_matches = len(actual_prefix) >= len(expected_prefix)
    for index in range(len(expected_prefix)):
        if actual_prefix[index] != expected_prefix[index]:
            prefix_matches = False
    assert_equal(prefix_matches, True)

    var multipart = data.multipart_data()
    assert_equal(len(multipart), 1)
    assert_equal(multipart[0].field.filename, "note.txt")
    assert_equal(multipart[0].field.mimetype, "text/plain")
