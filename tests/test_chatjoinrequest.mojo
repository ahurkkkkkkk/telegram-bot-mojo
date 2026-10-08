from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Chat, ChatJoinRequest, ChatInviteLink, User
from telegram._utils.datetime import TimestampDateTime, from_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var decoded = ChatJoinRequest.de_json(
        parse_json(
            '{"chat":{"id":-100,"type":"supergroup","title":"Group"},"from":{"id":7,"first_name":"Requester","is_bot":false},"date":1700000000,"user_chat_id":4503599627370495,"bio":"Hello","invite_link":{"invite_link":"join","creator":{"id":8,"first_name":"Admin","is_bot":true},"creates_join_request":true,"is_primary":false,"is_revoked":false},"future":"kept"}'
        )
    )
    assert_equal(decoded.chat.id, -100)
    assert_equal(decoded.from_user.id, 7)
    assert_equal(decoded.date.year, 2023)
    assert_equal(decoded.user_chat_id, 4503599627370495)
    assert_equal(decoded.invite_link.value().invite_link, "join")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(
        decoded.to_json(),
        '{"bio": "Hello", "chat": {"id": -100, "type": "supergroup", "title": "Group"}, "date": 1700000000, "from": {"id": 7, "first_name": "Requester", "is_bot": false}, "invite_link": {"creates_join_request": true, "creator": {"id": 8, "first_name": "Admin", "is_bot": true}, "invite_link": "join", "is_primary": false, "is_revoked": false}, "user_chat_id": 4503599627370495, "future": "kept"}',
    )

    var same_instant = TimestampDateTime(2023, 11, 14, 22, 13, 20, utc_offset_seconds=0)
    var offset_instant = TimestampDateTime(2023, 11, 15, 3, 43, 20, utc_offset_seconds=19800)
    var first = ChatJoinRequest(Chat(-100, "group"), User(7, "A", False), same_instant, 1)
    var second = ChatJoinRequest(Chat(-100, "channel"), User(7, "B", True), offset_instant, 2)
    assert_equal(first == second, True)
    assert_equal(hash(first), hash(second))
    assert_equal(len(ChatJoinRequest.de_list(parse_json(
        '[{"chat":{"id":1,"type":"group"},"from":{"id":2,"first_name":"u","is_bot":false},"date":0,"user_chat_id":3}]'
    ), 0)), 1)
    with assert_raises():
        _ = ChatJoinRequest.de_json(parse_json('{"date":0}'))
