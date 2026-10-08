from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal, assert_raises

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import MessageReactionHandler


def main() raises:
    var no_update: Optional[Update] = None
    var default_handler = MessageReactionHandler()
    assert_equal(default_handler.check_update(no_update), False)

    var reaction_update = Update.de_json(
        parse_json(
            '{"update_id":1,"message_reaction":{"chat":{"id":-30,'
            '"type":"supergroup","username":"group"},"message_id":55,'
            '"date":1,"old_reaction":[],"new_reaction":[],"user":'
            '{"id":7,"first_name":"Ada","is_bot":false}}}'
        )
    )
    var reaction_value = Optional[Update](reaction_update^)
    var count_update = Update.de_json(
        parse_json(
            '{"update_id":2,"message_reaction_count":{"chat":{"id":-30,'
            '"type":"supergroup","username":"group"},"message_id":55,'
            '"date":1,"reactions":[]}}'
        )
    )
    var count_value = Optional[Update](count_update^)

    assert_equal(default_handler.check_update(reaction_value), True)
    assert_equal(default_handler.check_update(count_value), True)
    var reaction_only = MessageReactionHandler(
        message_reaction_types=MessageReactionHandler.MESSAGE_REACTION_UPDATED
    )
    assert_equal(reaction_only.check_update(reaction_value), True)
    assert_equal(reaction_only.check_update(count_value), False)
    var count_only = MessageReactionHandler(
        message_reaction_types=MessageReactionHandler.MESSAGE_REACTION_COUNT_UPDATED
    )
    assert_equal(count_only.check_update(count_value), True)
    assert_equal(count_only.check_update(reaction_value), False)

    var chat_ids = Set[Int]()
    _ = chat_ids.insert(-30)
    var empty_user_ids = Set[Int]()
    var empty_chat_names = Set[String]()
    var empty_user_names = Set[String]()
    var chat_filter = MessageReactionHandler(
        Optional[Set[Int]](chat_ids.copy()),
        Optional[Set[String]](empty_chat_names.copy()),
        Optional[Set[Int]](empty_user_ids.copy()),
        Optional[Set[String]](empty_user_names.copy()),
        MessageReactionHandler.MESSAGE_REACTION,
    )
    assert_equal(chat_filter.check_update(reaction_value), True)
    assert_equal(chat_filter.check_update(count_value), True)

    var usernames = Set[String]()
    _ = usernames.insert("@group")
    var username_filter = MessageReactionHandler(
        Optional[Set[Int]](empty_user_ids.copy()),
        Optional[Set[String]](usernames.copy()),
        Optional[Set[Int]](empty_user_ids.copy()),
        Optional[Set[String]](empty_user_names.copy()),
        MessageReactionHandler.MESSAGE_REACTION,
    )
    assert_equal(username_filter.check_update(reaction_value), True)

    var user_ids = Set[Int]()
    _ = user_ids.insert(7)
    var user_filter = MessageReactionHandler(
        Optional[Set[Int]](empty_user_ids.copy()),
        Optional[Set[String]](empty_chat_names.copy()),
        Optional[Set[Int]](user_ids.copy()),
        Optional[Set[String]](empty_user_names.copy()),
        MessageReactionHandler.MESSAGE_REACTION_UPDATED,
    )
    assert_equal(user_filter.check_update(reaction_value), True)
    assert_equal(user_filter.check_update(count_value), False)

    with assert_raises():
        var invalid = MessageReactionHandler(
            Optional[Set[Int]](empty_user_ids.copy()),
            Optional[Set[String]](empty_chat_names.copy()),
            Optional[Set[Int]](user_ids.copy()),
            Optional[Set[String]](empty_user_names.copy()),
            MessageReactionHandler.MESSAGE_REACTION,
        )

    var nonblocking = MessageReactionHandler(False)
    assert_equal(nonblocking.resolve_block(True), False)
