from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Birthdate
from telegram._utils.json import parse_json


def main() raises:
    var leap_day = Birthdate(29, 2, 2024)
    var leap_date = leap_day.to_date()
    assert_equal(leap_date.year, 2024)
    assert_equal(leap_date.month, 2)
    assert_equal(leap_date.day, 29)
    assert_equal(leap_date.isoformat(), "2024-02-29")

    var inferred_year = Birthdate(29, 2)
    var dated = inferred_year.to_date(Optional[Int](2000))
    assert_equal(dated.isoformat(), "2000-02-29")

    var no_year = Birthdate(4, 7)
    var no_year_round_trip = Birthdate.de_json(parse_json(no_year.to_json()))
    assert_equal(no_year_round_trip == no_year, True)
    assert_equal(no_year_round_trip.year is None, True)

    var with_year_round_trip = Birthdate.de_json(parse_json(leap_day.to_json()))
    assert_equal(with_year_round_trip == leap_day, True)
    assert_equal(with_year_round_trip.year.value(), 2024)
