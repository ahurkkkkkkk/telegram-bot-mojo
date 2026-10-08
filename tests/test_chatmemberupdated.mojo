from std.testing import assert_equal, assert_raises

from telegram import ChatMemberUpdated
from telegram._utils.json import parse_json


def main() raises:
    var event = ChatMemberUpdated.de_json(
        parse_json(
            '{"chat":{"id":-100123,"type":"supergroup"},'
            '"from":{"id":9,"first_name":"Admin","is_bot":false},'
            '"date":1790951700,'
            '"old_chat_member":{"status":"member","user":{"id":3,'
            '"first_name":"Member","is_bot":false},"tag":"newcomer"},'
            '"new_chat_member":{"status":"member","user":{"id":3,'
            '"first_name":"Member","is_bot":false},"tag":"helper"},'
            '"via_join_request":true,"future_event":17}'
        )
    )
    assert_equal(event.chat.id, -100123)
    assert_equal(event.from_user.id, 9)
    assert_equal(event.date.year, 2026)
    assert_equal(event.via_join_request.value(), True)
    assert_equal(event.api_kwargs.object_get(event.api_kwargs.root, "future_event") != -1, True)
    var changes = event.difference()
    var tag_change = changes.object_get(changes.root, "tag")
    assert_equal(tag_change != -1, True)
    assert_equal(changes.string_value(changes.array_get(tag_change, 0)), "newcomer")
    assert_equal(changes.string_value(changes.array_get(tag_change, 1)), "helper")
    var encoded = event.to_json()
    var decoded = ChatMemberUpdated.de_json(parse_json(encoded))
    assert_equal(decoded == event, True)
    assert_equal(hash(decoded), hash(event))
    assert_equal(len(ChatMemberUpdated.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var same = ChatMemberUpdated(
        event.chat.copy(),
        event.from_user.copy(),
        event.date.copy(),
        event.old_chat_member.copy(),
        event.new_chat_member.copy(),
    )
    assert_equal(same == event, True)
    with assert_raises():
        _ = ChatMemberUpdated.de_json(parse_json("{}"))
