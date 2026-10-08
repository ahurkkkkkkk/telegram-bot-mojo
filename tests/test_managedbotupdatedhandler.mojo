from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import ManagedBotUpdatedHandler


def main() raises:
    var update = Update.de_json(parse_json(
        '{"update_id":7,"managed_bot":{"user":{"id":8,"first_name":"Ada",'
        '"is_bot":false,"username":"ada"},"bot":{"id":10,"first_name":"Helper",'
        '"is_bot":true,"username":"helper"}}}'
    ))
    var some_update = Optional[Update](update^)
    var no_update: Optional[Update] = None

    var handler = ManagedBotUpdatedHandler()
    assert_equal(handler.check_update(no_update), False)
    assert_equal(handler.check_update(some_update), True)

    var creator_or_bot_id = Set[Int]()
    _ = creator_or_bot_id.insert(10)
    var no_usernames = Set[String]()
    var id_match = ManagedBotUpdatedHandler(creator_or_bot_id, no_usernames)
    assert_equal(id_match.check_update(some_update), True)

    var no_ids = Set[Int]()
    var usernames = Set[String]()
    _ = usernames.insert("@helper")
    var username_match = ManagedBotUpdatedHandler(no_ids, usernames, False)
    assert_equal(username_match.check_update(some_update), True)
    assert_equal(username_match.resolve_block(True), False)

    var wrong_ids = Set[Int]()
    _ = wrong_ids.insert(99)
    var wrong_usernames = Set[String]()
    _ = wrong_usernames.insert("nobody")
    var no_match = ManagedBotUpdatedHandler(wrong_ids, wrong_usernames)
    assert_equal(no_match.check_update(some_update), False)
