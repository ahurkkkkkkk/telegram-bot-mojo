from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import ChatMemberHandler


def main() raises:
    var no_update: Optional[Update] = None
    var default_handler = ChatMemberHandler()
    assert_equal(default_handler.check_update(no_update), False)

    var update = Update.de_json(
        parse_json(
            '{"update_id":1,"my_chat_member":{"chat":{"id":-100123,'
            '"type":"supergroup"},"from":{"id":9,"first_name":"Admin",'
            '"is_bot":false},"date":1790951700,"old_chat_member":{"status":'
            '"member","user":{"id":3,"first_name":"Member","is_bot":false}},'
            '"new_chat_member":{"status":"member","user":{"id":3,'
            '"first_name":"Member","is_bot":false}}}}'
        )
    )
    var update_value = Optional[Update](update^)

    assert_equal(default_handler.check_update(update_value), True)
    var chat_member_only = ChatMemberHandler(ChatMemberHandler.CHAT_MEMBER)
    assert_equal(chat_member_only.check_update(update_value), False)
    var any_member = ChatMemberHandler(ChatMemberHandler.ANY_CHAT_MEMBER)
    assert_equal(any_member.check_update(update_value), True)

    var allowed_ids = Set[Int]()
    _ = allowed_ids.insert(-100123)
    var allowed = ChatMemberHandler(ChatMemberHandler.MY_CHAT_MEMBER, allowed_ids)
    assert_equal(allowed.check_update(update_value), True)
    var other_ids = Set[Int]()
    _ = other_ids.insert(-100999)
    var excluded = ChatMemberHandler(ChatMemberHandler.MY_CHAT_MEMBER, other_ids)
    assert_equal(excluded.check_update(update_value), False)

    var nonblocking = ChatMemberHandler(ChatMemberHandler.ANY_CHAT_MEMBER, False)
    assert_equal(nonblocking.resolve_block(True), False)
