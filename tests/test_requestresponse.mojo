from std.collections import List
from std.testing import assert_equal

from telegram.error import TelegramError
from telegram.request import (
    HttpResponseOutcome,
    extract_post_result,
    handle_http_response,
    raise_response_error,
)
from telegram._utils.json import JSON_OBJECT


def _body(value: String) -> List[UInt8]:
    var result = List[UInt8]()
    for byte in value.as_bytes():
        result.append(byte)
    return result^


def _raise_outcome(outcome: HttpResponseOutcome) raises TelegramError:
    raise_response_error(outcome)


def main() raises:
    var ok = handle_http_response(200, _body("{\"ok\":true,\"result\":{\"id\":9}}"))
    assert_equal(ok.is_success, True)
    var result = extract_post_result(ok.response)
    assert_equal(result.nodes[result.root].kind, JSON_OBJECT)
    assert_equal(result.integer_value(result.object_get(result.root, "id")), 9)

    var forbidden = handle_http_response(
        403,
        _body("{\"ok\":false,\"description\":\"Access denied\"}"),
    )
    assert_equal(forbidden.is_success, False)
    assert_equal(forbidden.error.value().kind, TelegramError.FORBIDDEN)
    assert_equal(forbidden.error.value().message, "Access denied")
    var raised_forbidden = False
    try:
        _raise_outcome(forbidden)
    except caught:
        raised_forbidden = caught.kind == TelegramError.FORBIDDEN
    assert_equal(raised_forbidden, True)

    var migrated = handle_http_response(
        400,
        _body(
            "{\"description\":\"Bad Request: moved\",\"parameters\":{\"migrate_to_chat_id\":-1005}}"
        ),
    )
    assert_equal(migrated.error.value().kind, TelegramError.CHAT_MIGRATED)
    assert_equal(migrated.error.value().new_chat_id, -1005)

    var retry = handle_http_response(
        429,
        _body("{\"description\":\"slow down\",\"parameters\":{\"retry_after\":3}}"),
    )
    assert_equal(retry.error.value().kind, TelegramError.RETRY_AFTER)
    assert_equal(retry.error.value().retry_after, 3.0)

    var malformed = handle_http_response(502, _body("not-json"))
    assert_equal(malformed.error.value().kind, TelegramError.NETWORK)
