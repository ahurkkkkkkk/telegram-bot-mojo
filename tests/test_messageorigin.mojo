from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Chat, MessageOrigin, User
from telegram._utils.datetime import TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var date = TimestampDateTime(2026, 10, 1, 12, 30, 0)
    var user = User(7, "Ada", False)
    var user_origin = MessageOrigin.user(date, user)
    var user_json = user_origin.to_json()
    var decoded_user = MessageOrigin.de_json(parse_json(user_json))
    assert_equal(decoded_user.type, "user")
    assert_equal(decoded_user.date.year, date.year)
    assert_equal(decoded_user.date.month, date.month)
    assert_equal(decoded_user.sender_user.value().id, user.id)
    assert_equal(decoded_user == MessageOrigin.user(date, User(8, "Grace", False)), True)

    var hidden = MessageOrigin.hidden_user(date, "Anonymous")
    assert_equal(MessageOrigin.de_json(parse_json(hidden.to_json())) == hidden, True)

    var sender_chat = Chat(-100123, "channel", title="Original")
    var chat_origin = MessageOrigin.chat_origin(
        date,
        sender_chat,
        Optional[String]("Admin"),
    )
    assert_equal(MessageOrigin.de_json(parse_json(chat_origin.to_json())) == chat_origin, True)

    var channel_origin = MessageOrigin.channel(date, sender_chat, 44)
    assert_equal(MessageOrigin.de_json(parse_json(channel_origin.to_json())) == channel_origin, True)
    assert_equal(channel_origin.message_id.value(), 44)
    assert_equal(len(MessageOrigin.de_list(parse_json("[" + user_json + "]"), 0)), 1)

    var future = MessageOrigin.de_json(
        parse_json('{"type":"future","date":1790857800,"sender_user_name":"future"}')
    )
    assert_equal(future.to_json(), '{"type": "future", "date": 1790857800, "sender_user_name": "future"}')
    with assert_raises():
        _ = MessageOrigin.de_json(parse_json('{"type":"channel","date":1,"chat":{}}'))
