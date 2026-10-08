from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import ChatJoinRequestHandler


def main() raises:
    var update = Update.de_json(parse_json(
        '{"update_id":8,"chat_join_request":{"chat":{"id":-30,'
        '"type":"supergroup"},"from":{"id":9,"first_name":"Ada",'
        '"is_bot":false,"username":"ada"},"date":1700000000,'
        '"user_chat_id":9}}'
    ))
    var some_update = Optional[Update](update^)
    var no_update: Optional[Update] = None

    var handler = ChatJoinRequestHandler()
    assert_equal(handler.check_update(no_update), False)
    assert_equal(handler.check_update(some_update), True)

    var chat_ids = Set[Int]()
    _ = chat_ids.insert(-30)
    var wrong_usernames = Set[String]()
    _ = wrong_usernames.insert("nobody")
    var chat_match = ChatJoinRequestHandler(chat_ids, wrong_usernames)
    assert_equal(chat_match.check_update(some_update), True)

    var wrong_chat_ids = Set[Int]()
    _ = wrong_chat_ids.insert(99)
    var usernames = Set[String]()
    _ = usernames.insert("@ada")
    var username_match = ChatJoinRequestHandler(wrong_chat_ids, usernames, False)
    assert_equal(username_match.check_update(some_update), True)
    assert_equal(username_match.resolve_block(True), False)

    var no_match = ChatJoinRequestHandler(wrong_chat_ids, wrong_usernames)
    assert_equal(no_match.check_update(some_update), False)
