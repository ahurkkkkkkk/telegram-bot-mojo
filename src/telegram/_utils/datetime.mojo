#!/usr/bin/env mojo
#
# Native calendar date value support for python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native date value used by Telegram objects with calendar dates."""

from std.hashlib.hasher import Hasher
from std.io import Writer
from std.collections.optional import Optional

struct Date(Equatable, Hashable, Copyable):
    """A validated proleptic-Gregorian calendar date."""

    var year: Int
    var month: Int
    var day: Int

    def __init__(out self, year: Int, month: Int, day: Int) raises:
        if year < 1 or year > 9999:
            raise Error("year must be in 1..9999")
        if month < 1 or month > 12:
            raise Error("month must be in 1..12")
        var days_in_month = 31
        if month == 4 or month == 6 or month == 9 or month == 11:
            days_in_month = 30
        elif month == 2:
            days_in_month = 28
            if year % 4 == 0 and (year % 100 != 0 or year % 400 == 0):
                days_in_month = 29
        if day < 1 or day > days_in_month:
            raise Error("day is out of range for month")
        self.year = year
        self.month = month
        self.day = day

    def __copyinit__(out self, existing: Self):
        self.year = existing.year
        self.month = existing.month
        self.day = existing.day

    def __eq__(self, other: Self) -> Bool:
        return self.year == other.year and self.month == other.month and self.day == other.day

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.year).as_bytes())
        hasher.update(String("-").as_bytes())
        hasher.update(String(self.month).as_bytes())
        hasher.update(String("-").as_bytes())
        hasher.update(String(self.day).as_bytes())

    def isoformat(self) -> String:
        var result = String(self.year) + "-"
        if self.month < 10:
            result += "0"
        result += String(self.month) + "-"
        if self.day < 10:
            result += "0"
        result += String(self.day)
        return result


struct TimeDelta(Equatable, Hashable, Copyable, Writable):
    """Native fixed-precision duration with Python ``timedelta`` normalization."""

    var days: Int
    var seconds: Int
    var microseconds: Int

    def __init__(out self, seconds: Int = 0, microseconds: Int = 0):
        var normalized_seconds = seconds
        var normalized_microseconds: Int
        if microseconds >= 0:
            normalized_seconds += microseconds / 1000000
            normalized_microseconds = microseconds % 1000000
        else:
            var negative_microseconds = -microseconds
            var borrowed_seconds = (negative_microseconds + 999999) / 1000000
            normalized_seconds -= borrowed_seconds
            normalized_microseconds = microseconds + borrowed_seconds * 1000000

        var normalized_days: Int
        var seconds_in_day: Int
        if normalized_seconds >= 0:
            normalized_days = normalized_seconds / 86400
            seconds_in_day = normalized_seconds % 86400
        else:
            var negative_seconds = -normalized_seconds
            var whole_negative_days = negative_seconds / 86400
            var remainder_seconds = negative_seconds % 86400
            if remainder_seconds == 0:
                normalized_days = -whole_negative_days
                seconds_in_day = 0
            else:
                normalized_days = -(whole_negative_days + 1)
                seconds_in_day = 86400 - remainder_seconds
        self.days = normalized_days
        self.seconds = seconds_in_day
        self.microseconds = normalized_microseconds

    def __init__(out self, seconds: Float64):
        var whole_seconds = Int(seconds)
        var fractional_seconds = seconds - Float64(whole_seconds)
        var fractional_microseconds = fractional_seconds * 1000000.0
        var rounded_microseconds = Int(fractional_microseconds)
        var remainder = fractional_microseconds - Float64(rounded_microseconds)
        if remainder > 0.5 or (remainder == 0.5 and rounded_microseconds % 2 != 0):
            rounded_microseconds += 1
        elif remainder < -0.5 or (remainder == -0.5 and rounded_microseconds % 2 != 0):
            rounded_microseconds -= 1
        var normalized = TimeDelta(whole_seconds, rounded_microseconds)
        self.days = normalized.days
        self.seconds = normalized.seconds
        self.microseconds = normalized.microseconds

    def __copyinit__(out self, existing: Self):
        self.days = existing.days
        self.seconds = existing.seconds
        self.microseconds = existing.microseconds

    def write_to(self, mut writer: Some[Writer]):
        writer.write(
            String(
                "TimeDelta(days=",
                self.days,
                ", seconds=",
                self.seconds,
                ", microseconds=",
                self.microseconds,
                ")",
            )
        )

    def __eq__(self, other: Self) -> Bool:
        return (
            self.days == other.days
            and self.seconds == other.seconds
            and self.microseconds == other.microseconds
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.days).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.seconds).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.microseconds).as_bytes())

    def total_seconds(self) -> Float64:
        var whole_seconds = self.days * 86400 + self.seconds
        if whole_seconds < 0 and self.microseconds > 0:
            return Float64(whole_seconds + 1) - Float64(
                1000000 - self.microseconds
            ) / 1000000.0
        return Float64(whole_seconds) + Float64(self.microseconds) / 1000000.0

    def seconds_json_number(self) -> String:
        if self.microseconds == 0:
            return String(self.days * 86400 + self.seconds)
        return String(self.total_seconds())


def to_timedelta(seconds: Int) -> TimeDelta:
    """Convert integral seconds to a native normalized duration."""
    return TimeDelta(seconds)


def to_timedelta(seconds: Float64) -> TimeDelta:
    """Convert fractional seconds using nearest-microsecond, ties-to-even rounding."""
    return TimeDelta(seconds)


def get_timedelta_value(value: TimeDelta) -> TimeDelta:
    """Return the duration value in Mojo's explicit native time representation."""
    return value.copy()


struct TimestampDateTime(Equatable, Hashable, Copyable):
    """Gregorian wall-clock fields with a fixed UTC offset, for POSIX conversions."""

    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
    var microsecond: Int
    var utc_offset_seconds: Int

    def __init__(
        out self,
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        microsecond: Int = 0,
        utc_offset_seconds: Int = 0,
    ) raises:
        _ = Date(year, month, day)
        if hour < 0 or hour > 23:
            raise Error("hour must be in 0..23")
        if minute < 0 or minute > 59:
            raise Error("minute must be in 0..59")
        if second < 0 or second > 59:
            raise Error("second must be in 0..59")
        if microsecond < 0 or microsecond > 999999:
            raise Error("microsecond must be in 0..999999")
        if utc_offset_seconds <= -86400 or utc_offset_seconds >= 86400:
            raise Error("UTC offset must be strictly between -24 and +24 hours")
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.microsecond = microsecond
        self.utc_offset_seconds = utc_offset_seconds

    def __copyinit__(out self, existing: Self):
        self.year = existing.year
        self.month = existing.month
        self.day = existing.day
        self.hour = existing.hour
        self.minute = existing.minute
        self.second = existing.second
        self.microsecond = existing.microsecond
        self.utc_offset_seconds = existing.utc_offset_seconds

    def __eq__(self, other: Self) -> Bool:
        return _timestamp_datetime_microseconds(self) == _timestamp_datetime_microseconds(other)

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(_timestamp_datetime_microseconds(self)).as_bytes())

    def timestamp(self) -> Float64:
        return _timestamp_datetime_seconds(self)


def _timestamp_floor_div(value: Int, divisor: Int) -> Int:
    var quotient = value / divisor
    if value < 0 and value % divisor != 0:
        quotient -= 1
    return quotient


def _timestamp_datetime_seconds(value: TimestampDateTime) -> Float64:
    var year = value.year
    var month = value.month
    if month <= 2:
        year -= 1
    var era = year / 400
    var year_of_era = year - era * 400
    var adjusted_month = month
    if month > 2:
        adjusted_month -= 3
    else:
        adjusted_month += 9
    var day_of_year = (153 * adjusted_month + 2) / 5 + value.day - 1
    var day_of_era = (
        year_of_era * 365 + year_of_era / 4 - year_of_era / 100 + day_of_year
    )
    var days_since_epoch = era * 146097 + day_of_era - 719468
    var local_seconds = (
        days_since_epoch * 86400 + value.hour * 3600 + value.minute * 60 + value.second
    )
    var utc_seconds = local_seconds - value.utc_offset_seconds
    return Float64(utc_seconds) + Float64(value.microsecond) / 1000000.0


def _timestamp_datetime_microseconds(value: TimestampDateTime) -> Int:
    var whole_seconds = Int(_timestamp_datetime_seconds(value))
    if _timestamp_datetime_seconds(value) < Float64(whole_seconds):
        whole_seconds -= 1
    return whole_seconds * 1000000 + value.microsecond


def from_timestamp(timestamp: Int, utc_offset_seconds: Int = 0) raises -> TimestampDateTime:
    """Convert integral Unix seconds to a fixed-offset Gregorian date/time."""
    var local_seconds = timestamp + utc_offset_seconds
    if local_seconds < -62135596800 or local_seconds > 253402300799:
        raise Error("timestamp is outside the supported Gregorian year range")
    var days = _timestamp_floor_div(local_seconds, 86400)
    var seconds_in_day = local_seconds - days * 86400
    var z = days + 719468
    var era = z / 146097
    var day_of_era = z - era * 146097
    var year_of_era = (
        day_of_era - day_of_era / 1460 + day_of_era / 36524 - day_of_era / 146096
    ) / 365
    var year = year_of_era + era * 400
    var day_of_year = day_of_era - (
        365 * year_of_era + year_of_era / 4 - year_of_era / 100
    )
    var month_part = (5 * day_of_year + 2) / 153
    var day = day_of_year - (153 * month_part + 2) / 5 + 1
    var month = month_part + 3
    if month_part >= 10:
        month = month_part - 9
    if month <= 2:
        year += 1
    return TimestampDateTime(
        year,
        month,
        day,
        seconds_in_day / 3600,
        (seconds_in_day % 3600) / 60,
        seconds_in_day % 60,
        0,
        utc_offset_seconds,
    )


def from_timestamp(timestamp: Optional[Int], utc_offset_seconds: Int = 0) raises -> Optional[TimestampDateTime]:
    if timestamp is None:
        return None
    return Optional[TimestampDateTime](from_timestamp(timestamp.value(), utc_offset_seconds))


def from_float_timestamp(timestamp: Float64, utc_offset_seconds: Int = 0) raises -> TimestampDateTime:
    """Convert POSIX seconds with nearest-microsecond, ties-to-even rounding."""
    if utc_offset_seconds <= -86400 or utc_offset_seconds >= 86400:
        raise Error("UTC offset must be strictly between -24 and +24 hours")
    if timestamp < Float64(-62135596800 - utc_offset_seconds) or timestamp > Float64(
        253402300799 - utc_offset_seconds
    ):
        raise Error("timestamp is outside the supported Gregorian year range")
    var whole_seconds = Int(timestamp)
    if timestamp < Float64(whole_seconds):
        whole_seconds -= 1
    var fractional_microseconds = (timestamp - Float64(whole_seconds)) * 1000000.0
    var microseconds = Int(fractional_microseconds)
    var remainder = fractional_microseconds - Float64(microseconds)
    if remainder > 0.5 or (remainder == 0.5 and microseconds % 2 != 0):
        microseconds += 1
    if microseconds == 1000000:
        whole_seconds += 1
        microseconds = 0
    var result = from_timestamp(whole_seconds, utc_offset_seconds)
    result.microsecond = microseconds
    return result^


def to_float_timestamp(value: TimestampDateTime) -> Float64:
    return _timestamp_datetime_seconds(value)


def to_timestamp(value: TimestampDateTime) -> Int:
    """Return the POSIX timestamp truncated toward zero, matching upstream behavior."""
    return Int(_timestamp_datetime_seconds(value))


def to_timestamp(value: Optional[TimestampDateTime]) -> Optional[Int]:
    if value is None:
        return None
    return Optional[Int](to_timestamp(value.value()))
