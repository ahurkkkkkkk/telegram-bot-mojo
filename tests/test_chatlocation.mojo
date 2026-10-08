from std.testing import assert_equal, assert_raises

from telegram import ChatLocation, Location
from telegram._utils.json import parse_json


def main() raises:
    var point = Location(-122.25, 37.5)
    var chat_location = ChatLocation(point, "1 Main Street")
    assert_equal(ChatLocation.MIN_ADDRESS, 1)
    assert_equal(ChatLocation.MAX_ADDRESS, 64)
    assert_equal(
        chat_location.to_json(),
        "{\"location\": {\"latitude\": 37.5, \"longitude\": -122.25}, \"address\": \"1 Main Street\"}",
    )

    var decoded = ChatLocation.de_json(
        parse_json("{\"location\":{\"longitude\":-122.25,\"latitude\":37.5},\"address\":\"1 Main Street\",\"future\":true}")
    )
    assert_equal(decoded.location.longitude, point.longitude)
    assert_equal(decoded.location.latitude, point.latitude)
    assert_equal(decoded.address, "1 Main Street")
    assert_equal(
        decoded.to_json(),
        "{\"location\": {\"latitude\": 37.5, \"longitude\": -122.25}, \"address\": \"1 Main Street\", \"future\": true}",
    )
    assert_equal(decoded == ChatLocation(Location(-122.25, 37.5), "Elsewhere"), True)
    assert_equal(
        hash(decoded),
        hash(ChatLocation(Location(-122.25, 37.5), "Elsewhere")),
    )
    var listed = ChatLocation.de_list(
        parse_json("[{\"location\":{\"longitude\":1,\"latitude\":2},\"address\":\"A\"}]"),
        0,
    )
    assert_equal(len(listed), 1)
    with assert_raises():
        _ = ChatLocation.de_json(parse_json("{\"address\":\"A\"}"))
