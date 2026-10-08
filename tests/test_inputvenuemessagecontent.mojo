from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InputVenueMessageContent
from telegram._utils.json import parse_json


def main() raises:
    var venue = InputVenueMessageContent(
        40.5,
        -73.9,
        "Cafe",
        "1 Main St",
        Optional[String]("fsq"),
        Optional[String]("food/cafe"),
        Optional[String]("place"),
        Optional[String]("restaurant"),
    )
    assert_equal(venue.latitude, 40.5)
    assert_equal(venue.longitude, -73.9)
    assert_equal(venue.to_json(), "{\"address\": \"1 Main St\", \"foursquare_id\": \"fsq\", \"foursquare_type\": \"food/cafe\", \"google_place_id\": \"place\", \"google_place_type\": \"restaurant\", \"latitude\": 40.5, \"longitude\": -73.9, \"title\": \"Cafe\"}")

    var decoded = InputVenueMessageContent.de_json(
        parse_json("{\"latitude\":40.5,\"longitude\":-73.9,\"title\":\"Cafe\",\"address\":\"1 Main St\",\"future\":true}")
    )
    assert_equal(decoded.latitude, 40.5)
    assert_equal(decoded.longitude, -73.9)
    assert_equal(decoded.foursquare_id is None, True)
    assert_equal(decoded.to_json(), "{\"address\": \"1 Main St\", \"latitude\": 40.5, \"longitude\": -73.9, \"title\": \"Cafe\", \"future\": true}")
    assert_equal(
        decoded == InputVenueMessageContent(40.5, -73.9, "Cafe", "Different address"),
        True,
    )
    var positive_zero = InputVenueMessageContent(0.0, 0.0, "Zero", "A")
    var negative_zero = InputVenueMessageContent(-0.0, 0.0, "Zero", "B")
    assert_equal(positive_zero == negative_zero, True)
    assert_equal(hash(positive_zero), hash(negative_zero))
    var listed = InputVenueMessageContent.de_list(
        parse_json("[{\"latitude\":1.25,\"longitude\":2.5,\"title\":\"T\",\"address\":\"A\"}]"),
        0,
    )
    assert_equal(len(listed), 1)
    assert_equal(listed[0].latitude, 1.25)
    with assert_raises():
        _ = InputVenueMessageContent.de_json(parse_json("{}"))
