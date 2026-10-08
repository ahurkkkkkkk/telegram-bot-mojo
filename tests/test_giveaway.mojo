from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Chat, Giveaway, GiveawayCreated, GiveawayWinners, User
from telegram._utils.datetime import TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var chats = List[Chat]()
    chats.append(Chat(-1001, "supergroup", title=Optional[String]("Alpha")))
    chats.append(Chat(-1002, "channel", title=Optional[String]("Beta")))
    var country_codes = List[String]()
    country_codes.append("US")
    country_codes.append("CA")
    var date = TimestampDateTime(2026, 10, 1, 12, 30)
    var giveaway = Giveaway(
        chats,
        date,
        3,
        Optional[Bool](True),
        Optional[Bool](False),
        Optional[String]("Bonus"),
        country_codes,
        Optional[Int](12),
        Optional[Int](500),
    )
    var giveaway_json = giveaway.to_json()
    var decoded = Giveaway.de_json(parse_json(giveaway_json))
    assert_equal(decoded == giveaway, True)
    assert_equal(decoded.chats[1].id, -1002)
    assert_equal(decoded.winners_selection_date.year, 2026)
    assert_equal(decoded.country_codes[0], "US")
    assert_equal(decoded.only_new_members.value(), True)
    assert_equal(decoded.prize_star_count.value(), 500)
    assert_equal(len(Giveaway.de_list(parse_json("[" + giveaway_json + "]"), 0)), 1)

    var future = Giveaway.de_json(
        parse_json('{"chats":[],"winners_selection_date":1790857800,"winner_count":2,"future":17}')
    )
    assert_equal(future.to_json(), '{"chats": [], "winners_selection_date": 1790857800, "winner_count": 2, "future": 17}')

    var created = GiveawayCreated(Optional[Int](80))
    var created_roundtrip = GiveawayCreated.de_json(parse_json(created.to_json()))
    assert_equal(created_roundtrip.prize_star_count.value(), 80)
    assert_equal(GiveawayCreated.de_json(parse_json("{}")) == GiveawayCreated(), True)

    var winners = List[User]()
    winners.append(User(10, "Ada", False))
    winners.append(User(11, "Lin", False))
    var summary = GiveawayWinners(
        Chat(-1001, "supergroup"),
        77,
        date,
        2,
        winners,
        Optional[Int](4),
        Optional[Int](3),
        Optional[Int](1),
        Optional[Bool](True),
        Optional[Bool](False),
        Optional[String]("Prize"),
        Optional[Int](100),
    )
    var summary_json = summary.to_json()
    var summary_roundtrip = GiveawayWinners.de_json(parse_json(summary_json))
    assert_equal(summary_roundtrip == summary, True)
    assert_equal(summary_roundtrip.winners[1].id, 11)
    assert_equal(summary_roundtrip.prize_description.value(), "Prize")
    assert_equal(len(GiveawayWinners.de_list(parse_json("[" + summary_json + "]"), 0)), 1)
    assert_equal(summary == GiveawayWinners(Chat(-1001, "group"), 77, date, 2, winners), True)

    with assert_raises():
        _ = Giveaway.de_json(parse_json('{"chats":[],"winner_count":1}'))
