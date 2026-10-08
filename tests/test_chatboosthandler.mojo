from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import ChatBoostHandler


def main() raises:
    var no_update: Optional[Update] = None
    var default_handler = ChatBoostHandler()
    assert_equal(default_handler.check_update(no_update), False)

    var boost_update = Update.de_json(
        parse_json(
            '{"update_id":2,"chat_boost":{"chat":{"id":-40,'
            '"type":"supergroup","username":"boostchat"},"boost":'
            '{"boost_id":"boost-1","add_date":20,"expiration_date":40,'
            '"source":{"source":"premium","user":{"id":9,'
            '"first_name":"Cy","is_bot":false}}}}}'
        )
    )
    var update_value = Optional[Update](boost_update^)

    assert_equal(default_handler.check_update(update_value), True)
    var removed_only = ChatBoostHandler(ChatBoostHandler.REMOVED_CHAT_BOOST)
    assert_equal(removed_only.check_update(update_value), False)
    var any_boost = ChatBoostHandler(ChatBoostHandler.ANY_CHAT_BOOST)
    assert_equal(any_boost.check_update(update_value), True)

    var matching_ids = Set[Int]()
    _ = matching_ids.insert(-40)
    var matching_names = Set[String]()
    _ = matching_names.insert("@boostchat")
    var identity_match = ChatBoostHandler(
        ChatBoostHandler.CHAT_BOOST, matching_ids, matching_names
    )
    assert_equal(identity_match.check_update(update_value), True)

    var other_ids = Set[Int]()
    _ = other_ids.insert(99)
    var other_names = Set[String]()
    _ = other_names.insert("other")
    var identity_miss = ChatBoostHandler(
        ChatBoostHandler.CHAT_BOOST, other_ids, other_names
    )
    assert_equal(identity_miss.check_update(update_value), False)
    var nonblocking = ChatBoostHandler(ChatBoostHandler.ANY_CHAT_BOOST, False)
    assert_equal(nonblocking.resolve_block(True), False)
