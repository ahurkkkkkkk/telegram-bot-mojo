from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import GiveawayCompleted
from telegram._utils.json import parse_json


def main() raises:
    var message = parse_json('{"message_id":41,"chat":{"id":-100,"type":"group"}}')
    var event = GiveawayCompleted(
        3,
        Optional[Int](1),
        Optional(message.copy()),
        Optional[Bool](True),
    )
    var encoded = event.to_json()
    var decoded = GiveawayCompleted.de_json(parse_json(encoded))
    assert_equal(decoded == event, True)
    assert_equal(decoded.unclaimed_prize_count.value(), 1)
    assert_equal(decoded.giveaway_message.value().object_get(decoded.giveaway_message.value().root, "message_id") != -1, True)
    assert_equal(decoded.is_star_giveaway.value(), True)
    assert_equal(len(GiveawayCompleted.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var minimal = GiveawayCompleted.de_json(parse_json('{"winner_count":2,"future":"field"}'))
    assert_equal(minimal.to_json(), '{"winner_count": 2, "future": "field"}')
    assert_equal(GiveawayCompleted.de_json(parse_json('{"winner_count":2}')) == GiveawayCompleted(2), True)
    with assert_raises():
        _ = GiveawayCompleted.de_json(parse_json("{}"))
