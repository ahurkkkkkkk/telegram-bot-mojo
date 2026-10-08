from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import LocationAddress, StoryArea, StoryAreaPosition, StoryAreaType
from telegram._reaction import ReactionType
from telegram._utils.json import parse_json


def main() raises:
    var position = StoryAreaPosition(25.5, 40.25, 15.0, 20.0, 1.5, 2.0)
    var decoded_position = StoryAreaPosition.de_json(parse_json(position.to_json()))
    assert_equal(decoded_position == position, True)
    assert_equal(decoded_position.x_percentage, 25.5)

    var address = LocationAddress("US", city=Optional[String]("Oakland"))
    var location = StoryAreaType.location(37.8, -122.3, Optional[LocationAddress](address.copy()))
    var link = StoryAreaType.link("https://example.com")
    var weather = StoryAreaType.weather(19.75, "☀️", 0xFF112233)
    var gift = StoryAreaType.unique_gift("gift-123")
    var emoji_reaction = ReactionType.de_json(parse_json('{"type":"emoji","emoji":"🔥"}'))
    var reaction = StoryAreaType.suggested_reaction(emoji_reaction, Optional[Bool](True))

    assert_equal(StoryAreaType.de_json(parse_json(location.to_json())) == location, True)
    assert_equal(StoryAreaType.de_json(parse_json(link.to_json())) == link, True)
    assert_equal(StoryAreaType.de_json(parse_json(weather.to_json())) == weather, True)
    assert_equal(StoryAreaType.de_json(parse_json(gift.to_json())) == gift, True)
    assert_equal(StoryAreaType.de_json(parse_json(reaction.to_json())) == reaction, True)

    var area = StoryArea(position, link)
    var area_json = area.to_json()
    var decoded_area = StoryArea.de_json(parse_json(area_json))
    assert_equal(decoded_area == area, True)
    assert_equal(decoded_area.type.url, "https://example.com")
    assert_equal(len(StoryArea.de_list(parse_json("[" + area_json + "]"), 0)), 1)

    var future = StoryAreaType.de_json(
        parse_json('{"type":"future_area","latitude":12.5,"future":{"enabled":true}}')
    )
    assert_equal(
        future.to_json(),
        '{"type": "future_area", "latitude": 12.5, "future": {"enabled": true}}',
    )
    with assert_raises():
        _ = StoryAreaType.de_json(parse_json('{"type":"weather","temperature":2}'))
