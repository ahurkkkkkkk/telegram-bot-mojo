from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InputLocationMessageContent
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var live_period = Optional[TimeDelta](TimeDelta(1, 500000))
    var location = InputLocationMessageContent(
        37.5,
        -122.25,
        live_period,
        Optional[Float64](5.5),
        Optional[Int](180),
        Optional[Int](100),
    )
    assert_equal(location.live_period.value().total_seconds(), 1.5)
    assert_equal(
        location.to_json(),
        "{\"heading\": 180, \"horizontal_accuracy\": 5.5, \"latitude\": 37.5, \"live_period\": 1.5, \"longitude\": -122.25, \"proximity_alert_radius\": 100}",
    )

    var decoded = InputLocationMessageContent.de_json(
        parse_json("{\"latitude\":37.5,\"longitude\":-122.25,\"live_period\":60,\"horizontal_accuracy\":10.25,\"heading\":90,\"proximity_alert_radius\":0,\"future\":true}")
    )
    assert_equal(decoded.live_period.value().total_seconds(), 60.0)
    assert_equal(decoded.horizontal_accuracy.value(), 10.25)
    assert_equal(decoded.heading.value(), 90)
    assert_equal(decoded.proximity_alert_radius is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"heading\": 90, \"horizontal_accuracy\": 10.25, \"latitude\": 37.5, \"live_period\": 60, \"longitude\": -122.25, \"future\": true}",
    )
    assert_equal(decoded == InputLocationMessageContent(37.5, -122.25), True)
    assert_equal(hash(decoded), hash(InputLocationMessageContent(37.5, -122.25)))
    var positive_zero = InputLocationMessageContent(0.0, 0.0)
    var negative_zero = InputLocationMessageContent(-0.0, 0.0)
    assert_equal(positive_zero == negative_zero, True)
    assert_equal(hash(positive_zero), hash(negative_zero))
    assert_equal(InputLocationMessageContent.MAX_LIVE_PERIOD, 86400)
    with assert_raises():
        _ = InputLocationMessageContent.de_json(parse_json("{\"latitude\":1}"))
