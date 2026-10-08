from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import BusinessConnectionHandler, BusinessMessagesDeletedHandler


def main() raises:
    var update = Update.de_json(parse_json(
        '{"update_id":1,'
        '"business_connection":{"id":"bc","user":{"id":8,"first_name":"Ada",'
        '"is_bot":false,"username":"ada"},"user_chat_id":8,"date":1,'
        '"is_enabled":true},'
        '"deleted_business_messages":{"business_connection_id":"bc",'
        '"chat":{"id":-30,"type":"supergroup","username":"group"},'
        '"message_ids":[2]}}'
    ))
    var some_update = Optional[Update](update^)
    var no_update: Optional[Update] = None

    var business_handler = BusinessConnectionHandler()
    assert_equal(business_handler.check_update(no_update), False)
    assert_equal(business_handler.check_update(some_update), True)
    var wrong_user_ids = Set[Int]()
    _ = wrong_user_ids.insert(9)
    var wrong_usernames = Set[String]()
    _ = wrong_usernames.insert("nobody")
    var no_business_match = BusinessConnectionHandler(wrong_user_ids, wrong_usernames)
    assert_equal(no_business_match.check_update(some_update), False)
    var user_ids = Set[Int]()
    _ = user_ids.insert(8)
    var user_names = Set[String]()
    _ = user_names.insert("@ada")
    var business_match = BusinessConnectionHandler(user_ids, user_names)
    assert_equal(business_match.check_update(some_update), True)
    assert_equal(BusinessConnectionHandler(False).resolve_block(True), False)
    var username_only_match = BusinessConnectionHandler(
        wrong_user_ids, user_names, False
    )
    assert_equal(username_only_match.check_update(some_update), True)
    assert_equal(username_only_match.resolve_block(True), False)

    var deleted_handler = BusinessMessagesDeletedHandler()
    assert_equal(deleted_handler.check_update(no_update), False)
    assert_equal(deleted_handler.check_update(some_update), True)
    var chat_ids = Set[Int]()
    _ = chat_ids.insert(-30)
    var chat_names = Set[String]()
    _ = chat_names.insert("@group")
    var deleted_match = BusinessMessagesDeletedHandler(chat_ids, chat_names)
    assert_equal(deleted_match.check_update(some_update), True)
    var unmatched_ids = Set[Int]()
    _ = unmatched_ids.insert(99)
    var unmatched_names = Set[String]()
    _ = unmatched_names.insert("other")
    var deleted_no_match = BusinessMessagesDeletedHandler(unmatched_ids, unmatched_names)
    assert_equal(deleted_no_match.check_update(some_update), False)
    var chat_name_only_match = BusinessMessagesDeletedHandler(
        unmatched_ids, chat_names, False
    )
    assert_equal(chat_name_only_match.check_update(some_update), True)
    assert_equal(chat_name_only_match.resolve_block(True), False)
