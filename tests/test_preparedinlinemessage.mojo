from std.testing import assert_equal, assert_raises

from telegram import PreparedInlineMessage
from telegram._utils.datetime import TimestampDateTime, from_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var prepared = PreparedInlineMessage("opaque-id", TimestampDateTime(2026, 1, 2, 3, 4, 5))
    assert_equal(prepared.id, "opaque-id")
    assert_equal(prepared.expiration_date == TimestampDateTime(2026, 1, 2, 3, 4, 5), True)
    assert_equal(
        prepared.to_json(),
        '{"expiration_date": 1767323045, "id": "opaque-id"}',
    )

    var decoded = PreparedInlineMessage.de_json(
        parse_json('{"id":"opaque-id","expiration_date":1767323045,"future":"kept"}')
    )
    assert_equal(decoded == prepared, True)
    assert_equal(decoded.expiration_date == from_timestamp(1767323045), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(
        decoded.to_json(),
        '{"expiration_date": 1767323045, "id": "opaque-id", "future": "kept"}',
    )
    assert_equal(
        len(PreparedInlineMessage.de_list(parse_json('[{"id":"x","expiration_date":0}]'), 0)),
        1,
    )
    with assert_raises():
        _ = PreparedInlineMessage.de_json(parse_json('{"id":"missing-date"}'))
