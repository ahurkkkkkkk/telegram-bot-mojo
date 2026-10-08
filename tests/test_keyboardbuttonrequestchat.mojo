from std.testing import assert_equal, assert_raises

from telegram import KeyboardButtonRequestChat
from telegram._utils.json import parse_json


def main() raises:
    var decoded = KeyboardButtonRequestChat.de_json(
        parse_json(
            '{"request_id":0,"chat_is_channel":true,"chat_is_forum":false,"request_title":true,'
            '"user_administrator_rights":{"is_anonymous":false,"can_manage_chat":true,'
            '"can_delete_messages":false,"can_manage_video_chats":false,'
            '"can_restrict_members":false,"can_promote_members":false,"can_change_info":false,'
            '"can_invite_users":false,"can_post_stories":false,"can_edit_stories":false,'
            '"can_delete_stories":false},"future_field":{"level":2}}'
        )
    )
    assert_equal(decoded.request_id, 0)
    assert_equal(decoded.chat_is_channel, True)
    assert_equal(decoded.chat_is_forum.value(), False)
    assert_equal(decoded.request_title.value(), True)
    assert_equal(decoded.user_administrator_rights.value().can_manage_chat, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_field") != -1, True)

    var encoded = decoded.to_dict()
    assert_equal(encoded.integer_value(encoded.object_get(encoded.root, "request_id")), 0)
    assert_equal(encoded.boolean_value(encoded.object_get(encoded.root, "chat_is_forum")), False)
    assert_equal(
        encoded.object_get(encoded.root, "user_administrator_rights") != -1,
        True,
    )
    var round_trip = KeyboardButtonRequestChat.de_json(parse_json(decoded.to_json()))
    assert_equal(round_trip == decoded, True)
    assert_equal(hash(round_trip), hash(decoded))

    var another_with_same_id = KeyboardButtonRequestChat(0, False)
    assert_equal(another_with_same_id == decoded, True)
    assert_equal(hash(another_with_same_id), hash(decoded))
    assert_equal(
        len(KeyboardButtonRequestChat.de_list(parse_json(
            '[{"request_id":4,"chat_is_channel":false}]'
        ), 0)),
        1,
    )
    with assert_raises():
        _ = KeyboardButtonRequestChat.de_json(parse_json('{"request_id":1}'))
