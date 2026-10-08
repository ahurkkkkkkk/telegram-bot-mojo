from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    Chat,
    MessageReactionCountUpdated,
    MessageReactionUpdated,
    ReactionCount,
    ReactionType,
    User,
)
from telegram._utils.datetime import TimestampDateTime, to_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var chat = Chat(-100123, "supergroup", title=Optional[String]("reactions"))
    var date = TimestampDateTime(2026, 10, 1, 12, 30, 0)
    var emoji = ReactionType.de_json(parse_json('{"type":"emoji","emoji":"👍"}'))
    var reaction_count = List[ReactionCount]()
    reaction_count.append(ReactionCount(emoji, 3))
    var count_update = MessageReactionCountUpdated(chat, 55, date, reaction_count)
    var count_json = count_update.to_json()
    var decoded_count = MessageReactionCountUpdated.de_json(parse_json(count_json))
    assert_equal(decoded_count == count_update, True)
    assert_equal(hash(decoded_count), hash(count_update))
    assert_equal(decoded_count.reactions[0].total_count, 3)
    assert_equal(decoded_count.date.year, date.year)
    var same_instant = TimestampDateTime(2026, 10, 1, 13, 30, 0, utc_offset_seconds=3600)
    var same_instant_count = MessageReactionCountUpdated(chat, 55, same_instant, reaction_count.copy())
    assert_equal(same_instant_count == count_update, True)
    assert_equal(hash(same_instant_count), hash(count_update))
    assert_equal(
        len(MessageReactionCountUpdated.de_list(parse_json("[" + count_json + "]"), 0)),
        1,
    )

    var old_reactions = List[ReactionType]()
    old_reactions.append(emoji.copy())
    var new_reactions = List[ReactionType]()
    new_reactions.append(ReactionType.de_json(parse_json('{"type":"paid"}')))
    var actor = User(7, "Ada", False)
    var update = MessageReactionUpdated(
        chat,
        55,
        date,
        old_reactions,
        new_reactions,
        Optional[User](actor.copy()),
    )
    var update_json = update.to_json()
    var decoded_update = MessageReactionUpdated.de_json(parse_json(update_json))
    assert_equal(decoded_update == update, True)
    assert_equal(hash(decoded_update), hash(update))
    assert_equal(decoded_update.user.value().id, actor.id)
    assert_equal(decoded_update.api_kwargs.object_get(decoded_update.api_kwargs.root, "user"), -1)
    assert_equal(decoded_update.old_reaction[0].emoji, "👍")
    assert_equal(decoded_update.new_reaction[0].type, ReactionType.PAID)
    assert_equal(len(MessageReactionUpdated.de_list(parse_json("[" + update_json + "]"), 0)), 1)

    var anonymous = MessageReactionUpdated.de_json(
        parse_json(
            '{"chat":{"id":-100123,"type":"supergroup"},"message_id":55,'
            '"date":1790857800,"old_reaction":[],"new_reaction":[],'
            '"actor_chat":{"id":-100123,"type":"channel"},"future":true}'
        )
    )
    assert_equal(anonymous.actor_chat.value().chat_type, "channel")
    assert_equal(anonymous.user is None, True)
    assert_equal(anonymous.api_kwargs.object_get(anonymous.api_kwargs.root, "future") != -1, True)
    assert_equal(to_timestamp(anonymous.date), 1790857800)

    var with_extra = MessageReactionCountUpdated.de_json(
        parse_json(
            '{"chat":{"id":-100123,"type":"supergroup"},"message_id":55,'
            '"date":1790857800,"reactions":[],"future":true}'
        )
    )
    assert_equal(with_extra.api_kwargs.object_get(with_extra.api_kwargs.root, "future") != -1, True)
    with assert_raises():
        _ = MessageReactionUpdated.de_json(parse_json("{}"))
    with assert_raises():
        _ = MessageReactionCountUpdated.de_json(parse_json("{}"))
