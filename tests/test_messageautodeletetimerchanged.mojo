from std.testing import assert_equal, assert_raises

from telegram import MessageAutoDeleteTimerChanged
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var integer_seconds = MessageAutoDeleteTimerChanged(60)
    assert_equal(integer_seconds.message_auto_delete_time, TimeDelta(60))
    assert_equal(integer_seconds.to_json(), "{\"message_auto_delete_time\": 60}")

    var fractional = MessageAutoDeleteTimerChanged(TimeDelta(1, 250000))
    assert_equal(fractional.to_json(), "{\"message_auto_delete_time\": 1.25}")
    var decoded = MessageAutoDeleteTimerChanged.de_json(
        parse_json("{\"message_auto_delete_time\":3600,\"future\":\"x\"}")
    )
    assert_equal(decoded.message_auto_delete_time.total_seconds(), 3600.0)
    assert_equal(
        decoded.to_json(),
        "{\"message_auto_delete_time\": 3600, \"future\": \"x\"}",
    )
    assert_equal(decoded == MessageAutoDeleteTimerChanged(3600), True)
    assert_equal(hash(decoded), hash(MessageAutoDeleteTimerChanged(3600)))
    var listed = MessageAutoDeleteTimerChanged.de_list(
        parse_json("[{\"message_auto_delete_time\":1}]"), 0
    )
    assert_equal(len(listed), 1)
    with assert_raises():
        _ = MessageAutoDeleteTimerChanged.de_json(parse_json("{}"))
