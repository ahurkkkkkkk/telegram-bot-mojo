from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import WebhookInfo
from telegram._utils.datetime import TimestampDateTime, to_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var updates = List[String]()
    updates.append("message")
    updates.append("callback_query")
    var last_error = TimestampDateTime(2026, 10, 1, 12, 30, 10)
    var last_sync = TimestampDateTime(2026, 9, 30, 8, 15, 0)
    var status = WebhookInfo(
        "https://example.test/hook",
        True,
        5,
        Optional[TimestampDateTime](last_error.copy()),
        Optional[String]("timeout"),
        Optional[Int](40),
        updates,
        Optional[String]("192.0.2.1"),
        Optional[TimestampDateTime](last_sync.copy()),
    )
    var wire = status.to_json()
    var decoded = WebhookInfo.de_json(parse_json(wire))
    assert_equal(decoded == status, True)
    assert_equal(hash(decoded), hash(status))
    assert_equal(decoded.allowed_updates[1], "callback_query")
    assert_equal(to_timestamp(decoded.last_error_date.value()), to_timestamp(last_error))
    assert_equal(to_timestamp(decoded.last_synchronization_error_date.value()), to_timestamp(last_sync))
    assert_equal(len(WebhookInfo.de_list(parse_json("[" + wire + "]"), 0)), 1)
    var same_instant_error = TimestampDateTime(
        2026, 10, 1, 13, 30, 10, utc_offset_seconds=3600
    )
    var same_instant_status = WebhookInfo(
        "https://example.test/hook", True, 5,
        Optional[TimestampDateTime](same_instant_error.copy()),
        Optional[String]("timeout"), Optional[Int](40), updates.copy(),
        Optional[String]("192.0.2.1"), Optional[TimestampDateTime](last_sync.copy()),
    )
    assert_equal(same_instant_status == status, True)
    assert_equal(hash(same_instant_status), hash(status))

    var minimal = WebhookInfo.de_json(
        parse_json('{"url":"","has_custom_certificate":false,"pending_update_count":0}')
    )
    assert_equal(len(minimal.allowed_updates), 0)
    assert_equal(minimal.ip_address is None, True)
    assert_equal(minimal.last_error_date is None, True)
    assert_equal(minimal.to_json(), '{"has_custom_certificate": false, "pending_update_count": 0, "url": ""}')

    var future = WebhookInfo.de_json(
        parse_json(
            '{"url":"","has_custom_certificate":false,"pending_update_count":0,'
            '"allowed_updates":null,"future_field":{"enabled":true}}'
        )
    )
    assert_equal(future.api_kwargs.object_get(future.api_kwargs.root, "future_field") != -1, True)
    with assert_raises():
        _ = WebhookInfo.de_json(parse_json("{}"))
    with assert_raises():
        _ = WebhookInfo.de_json(
            parse_json(
                '{"url":"","has_custom_certificate":false,"pending_update_count":0,'
                '"allowed_updates":["message",false]}'
            )
        )
