from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Location, Venue
from telegram._utils.json import parse_json


def main() raises:
    var location = Location(-122.25, 37.5)
    var venue = Venue(
        location,
        "Cafe",
        "1 Main Street",
        Optional[String]("fsq-id"),
        Optional[String]("food/cafe"),
        Optional[String]("place-id"),
        Optional[String]("restaurant"),
    )
    assert_equal(
        venue.to_json(),
        "{\"address\": \"1 Main Street\", \"foursquare_id\": \"fsq-id\", \"foursquare_type\": \"food/cafe\", \"google_place_id\": \"place-id\", \"google_place_type\": \"restaurant\", \"location\": {\"latitude\": 37.5, \"longitude\": -122.25}, \"title\": \"Cafe\"}",
    )
    var decoded = Venue.de_json(
        parse_json("{\"location\":{\"longitude\":-122.25,\"latitude\":37.5},\"title\":\"Cafe\",\"address\":\"1 Main Street\",\"future\":true}")
    )
    assert_equal(decoded.location.longitude, -122.25)
    assert_equal(decoded.location.latitude, 37.5)
    assert_equal(decoded.foursquare_id is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"address\": \"1 Main Street\", \"location\": {\"latitude\": 37.5, \"longitude\": -122.25}, \"title\": \"Cafe\", \"future\": true}",
    )
    assert_equal(decoded == Venue(location, "Cafe", "Elsewhere"), True)
    assert_equal(hash(decoded), hash(Venue(location, "Cafe", "Elsewhere")))
    var listed = Venue.de_list(
        parse_json("[{\"location\":{\"longitude\":1,\"latitude\":2},\"title\":\"T\",\"address\":\"A\"}]"),
        0,
    )
    assert_equal(len(listed), 1)
    with assert_raises():
        _ = Venue.de_json(parse_json("{\"title\":\"T\",\"address\":\"A\"}"))
