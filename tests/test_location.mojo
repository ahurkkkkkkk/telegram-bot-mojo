from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Location
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var location = Location(
        -122.25,
        37.5,
        Optional[Float64](8.5),
        Optional[TimeDelta](TimeDelta(90)),
        Optional[Int](180),
        Optional[Int](250),
    )
    assert_equal(location.longitude, -122.25)
    assert_equal(location.latitude, 37.5)
    assert_equal(location.live_period.value().total_seconds(), 90.0)
    assert_equal(
        location.to_json(),
        "{\"heading\": 180, \"horizontal_accuracy\": 8.5, \"latitude\": 37.5, \"live_period\": 90, \"longitude\": -122.25, \"proximity_alert_radius\": 250}",
    )

    var decoded = Location.de_json(
        parse_json("{\"longitude\":-122.25,\"latitude\":37.5,\"live_period\":1.25,\"proximity_alert_radius\":0,\"future\":true}")
    )
    assert_equal(decoded.live_period.value().total_seconds(), 1.25)
    assert_equal(decoded.proximity_alert_radius is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"latitude\": 37.5, \"live_period\": 1.25, \"longitude\": -122.25, \"future\": true}",
    )
    assert_equal(decoded == Location(-122.25, 37.5), True)
    assert_equal(hash(decoded), hash(Location(-122.25, 37.5)))
    assert_equal(Location.MAX_HEADING, 360)
    var positive_zero = Location(0.0, 0.0)
    var negative_zero = Location(-0.0, 0.0)
    assert_equal(positive_zero == negative_zero, True)
    assert_equal(hash(positive_zero), hash(negative_zero))
    var listed = Location.de_list(parse_json("[{\"longitude\":1,\"latitude\":2}]"), 0)
    assert_equal(len(listed), 1)
    with assert_raises():
        _ = Location.de_json(parse_json("{}"))
