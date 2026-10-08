from std.testing import assert_equal

from telegram import BusinessOpeningHoursInterval
from telegram._utils.json import parse_json


def main() raises:
    var interval = BusinessOpeningHoursInterval(8, 2890)
    assert_equal(interval.opening_time(), (0, 0, 8))
    assert_equal(interval.closing_time(), (2, 0, 10))
    assert_equal(
        interval.to_json(),
        "{\"closing_minute\": 2890, \"opening_minute\": 8}",
    )
    var decoded = BusinessOpeningHoursInterval.de_json(parse_json(interval.to_json()))
    assert_equal(decoded == interval, True)
    assert_equal(decoded.opening_time(), (0, 0, 8))
