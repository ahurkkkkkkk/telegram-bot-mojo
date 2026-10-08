from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._utils.datetime import TimestampDateTime, from_float_timestamp, from_timestamp, to_float_timestamp, to_timestamp


def main() raises:
    var epoch = from_timestamp(0)
    assert_equal(epoch.year, 1970)
    assert_equal(epoch.month, 1)
    assert_equal(epoch.day, 1)
    assert_equal(epoch.hour, 0)

    var leap_day = from_timestamp(951782400)
    assert_equal(leap_day.year, 2000)
    assert_equal(leap_day.month, 2)
    assert_equal(leap_day.day, 29)

    var before_epoch = from_timestamp(-1)
    assert_equal(before_epoch.year, 1969)
    assert_equal(before_epoch.month, 12)
    assert_equal(before_epoch.day, 31)
    assert_equal(before_epoch.hour, 23)
    assert_equal(before_epoch.minute, 59)
    assert_equal(before_epoch.second, 59)

    var shifted = from_timestamp(0, 19800)
    assert_equal(shifted.hour, 5)
    assert_equal(shifted.minute, 30)
    assert_equal(to_timestamp(shifted), 0)
    var same_instant = TimestampDateTime(1970, 1, 1, 5, 30, utc_offset_seconds=19800)
    assert_equal(same_instant == epoch, True)
    assert_equal(hash(same_instant), hash(epoch))
    var previous_local_day = from_timestamp(0, -3600)
    assert_equal(previous_local_day.year, 1969)
    assert_equal(previous_local_day.month, 12)
    assert_equal(previous_local_day.day, 31)
    assert_equal(previous_local_day.hour, 23)

    var fractional = from_float_timestamp(-0.25)
    assert_equal(fractional.year, 1969)
    assert_equal(fractional.month, 12)
    assert_equal(fractional.day, 31)
    assert_equal(fractional.second, 59)
    assert_equal(fractional.microsecond, 750000)
    assert_equal(to_float_timestamp(fractional), -0.25)

    var half_second = TimestampDateTime(1970, 1, 1, microsecond=500000)
    assert_equal(to_timestamp(half_second), 0)
    var min_date = from_timestamp(-62135596800)
    assert_equal(min_date.year, 1)
    assert_equal(min_date.month, 1)
    assert_equal(min_date.day, 1)
    var max_date = from_timestamp(253402300799)
    assert_equal(max_date.year, 9999)
    assert_equal(max_date.month, 12)
    assert_equal(max_date.day, 31)
    assert_equal(max_date.hour, 23)
    assert_equal(max_date.minute, 59)
    assert_equal(max_date.second, 59)
    assert_equal(from_timestamp(Optional[Int](0)).value().year, 1970)
    assert_equal(from_timestamp(Optional[Int]()) is None, True)
    assert_equal(to_timestamp(Optional[TimestampDateTime]()) is None, True)
    with assert_raises():
        _ = TimestampDateTime(1900, 2, 29)
    with assert_raises():
        _ = from_timestamp(253402300800)
    with assert_raises():
        _ = from_float_timestamp(1e20)
