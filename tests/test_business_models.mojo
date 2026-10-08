from std.collections.optional import Optional
from std.testing import assert_equal

from std.collections import List

from telegram import (
    BusinessIntro,
    BusinessLocation,
    BusinessOpeningHours,
    BusinessOpeningHoursInterval,
    Location,
    Sticker,
)
from telegram._utils.json import parse_json


def main() raises:
    var intro_json = parse_json(
        '{"title":"Welcome","message":"Contact us",'
        '"sticker":{"file_id":"sticker-1","file_unique_id":"unique-1",'
        '"width":64,"height":64,"is_animated":false,"is_video":false,'
        '"type":"regular"},"future_intro_field":true}'
    )
    var intro = BusinessIntro.de_json(intro_json)
    assert_equal(intro.title.value(), "Welcome")
    assert_equal(intro.message.value(), "Contact us")
    assert_equal(intro.sticker.value().file_unique_id, "unique-1")
    assert_equal(intro.api_kwargs.object_get(intro.api_kwargs.root, "future_intro_field") != -1, True)
    var intro_round_trip = BusinessIntro.de_json(parse_json(intro.to_json()))
    assert_equal(intro_round_trip == intro, True)
    assert_equal(hash(intro_round_trip), hash(intro))
    assert_equal(len(BusinessIntro.de_list(parse_json('[{"title":"one"}]'), 0)), 1)

    var no_intro = BusinessIntro()
    assert_equal(no_intro.title is None, True)
    assert_equal(no_intro.to_json(), "{}")

    var location_json = parse_json(
        '{"address":"221B Baker Street",'
        '"location":{"longitude":-0.1586,"latitude":51.5237},'
        '"future_location_field":"kept"}'
    )
    var location = BusinessLocation.de_json(location_json)
    assert_equal(location.address, "221B Baker Street")
    assert_equal(location.location.value().latitude, 51.5237)
    assert_equal(location.api_kwargs.object_get(location.api_kwargs.root, "future_location_field") != -1, True)
    var location_round_trip = BusinessLocation.de_json(parse_json(location.to_json()))
    assert_equal(location_round_trip == location, True)
    assert_equal(hash(location_round_trip), hash(location))

    var first_location = BusinessLocation("same address", Optional[Location](Location(1.0, 2.0)))
    var second_location = BusinessLocation("same address", Optional[Location](Location(9.0, 8.0)))
    assert_equal(first_location == second_location, True)
    assert_equal(hash(first_location), hash(second_location))
    assert_equal(len(BusinessLocation.de_list(parse_json('[{"address":"a"}]'), 0)), 1)

    var intervals = List[BusinessOpeningHoursInterval]()
    intervals.append(BusinessOpeningHoursInterval(480, 1020))
    intervals.append(BusinessOpeningHoursInterval(1920, 2400))
    var hours = BusinessOpeningHours("Europe/London", intervals^)
    var decoded_hours = BusinessOpeningHours.de_json(parse_json(
        '{"time_zone_name":"Europe/London","opening_hours":['
        '{"opening_minute":480,"closing_minute":1020},'
        '{"opening_minute":1920,"closing_minute":2400}],"future_hours":1}'
    ))
    assert_equal(decoded_hours == hours, True)
    assert_equal(hash(decoded_hours), hash(hours))
    assert_equal(decoded_hours.opening_hours[1].opening_minute, 1920)
    assert_equal(decoded_hours.api_kwargs.object_get(decoded_hours.api_kwargs.root, "future_hours") != -1, True)
    assert_equal(len(BusinessOpeningHours.de_list(parse_json(
        '[{"time_zone_name":"UTC","opening_hours":[]}]'
    ), 0)), 1)
