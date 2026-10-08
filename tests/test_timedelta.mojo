from std.testing import assert_equal

from telegram._utils.datetime import TimeDelta, get_timedelta_value, to_timedelta


def main() raises:
    var zero = TimeDelta()
    assert_equal(zero.days, 0)
    assert_equal(zero.seconds, 0)
    assert_equal(zero.microseconds, 0)

    var minute = TimeDelta(60)
    assert_equal(minute.total_seconds(), 60.0)
    assert_equal(minute.seconds_json_number(), "60")
    assert_equal(to_timedelta(60), minute)
    assert_equal(get_timedelta_value(minute), minute)

    var fractional = TimeDelta(1.234567)
    assert_equal(fractional, TimeDelta(1, 234567))
    assert_equal(fractional.seconds_json_number(), "1.234567")
    assert_equal(TimeDelta(0.0000005).microseconds, 0)
    assert_equal(TimeDelta(0.0000015).microseconds, 2)

    var negative_microsecond = TimeDelta(0, -1)
    assert_equal(negative_microsecond.days, -1)
    assert_equal(negative_microsecond.seconds, 86399)
    assert_equal(negative_microsecond.microseconds, 999999)
    assert_equal(negative_microsecond.total_seconds(), -0.000001)
    assert_equal(negative_microsecond.seconds_json_number(), "-1e-06")
    assert_equal(negative_microsecond, TimeDelta(-1, 999999))

    var normalized = TimeDelta(90061, 1500000)
    assert_equal(normalized.days, 1)
    assert_equal(normalized.seconds, 3662)
    assert_equal(normalized.microseconds, 500000)
