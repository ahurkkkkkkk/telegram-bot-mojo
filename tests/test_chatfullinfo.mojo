from std.testing import assert_equal, assert_raises

from telegram import ChatFullInfo
from telegram._utils.json import parse_json


def main() raises:
    var info = ChatFullInfo.de_json(
        parse_json(
            '{"id":-100,"type":"supergroup","title":"Full group","accent_color_id":2,"max_reaction_count":5,"accepted_gift_types":{"unlimited_gifts":true,"limited_gifts":true,"unique_gifts":false,"premium_subscription":true,"gifts_from_channels":false},"active_usernames":["first","second"],"bio":"A bio","permissions":{"can_send_messages":true},"future_field":{"version":9}}'
        )
    )
    assert_equal(info.chat.id, -100)
    assert_equal(info.chat.effective_name().value(), "Full group")
    assert_equal(info.accent_color_id, 2)
    assert_equal(info.max_reaction_count, 5)
    assert_equal(info.accepted_gift_types.unlimited_gifts, True)
    assert_equal(info.optional_string_field("bio").value(), "A bio")
    assert_equal(info.optional_string_field("missing") is None, True)
    assert_equal(info.optional_boolean_field("not_a_bool") is None, True)
    assert_equal(info.array_field("active_usernames")[0].string_value(0), "first")
    assert_equal(info.field_json("permissions").to_json(), '{"can_send_messages": true}')
    assert_equal(info.api_kwargs.object_get(info.api_kwargs.root, "future_field") != -1, True)
    assert_equal(
        info.to_json(),
        '{"id": -100, "type": "supergroup", "title": "Full group", "accent_color_id": 2, "max_reaction_count": 5, "accepted_gift_types": {"unlimited_gifts": true, "limited_gifts": true, "unique_gifts": false, "premium_subscription": true, "gifts_from_channels": false}, "active_usernames": ["first", "second"], "bio": "A bio", "permissions": {"can_send_messages": true}, "future_field": {"version": 9}}',
    )
    assert_equal(len(ChatFullInfo.de_list(parse_json(
        '[{"id":1,"type":"group","accent_color_id":0,"max_reaction_count":1,"accepted_gift_types":{"unlimited_gifts":false,"limited_gifts":false,"unique_gifts":false,"premium_subscription":false,"gifts_from_channels":false}}]'
    ), 0)), 1)
    with assert_raises():
        _ = ChatFullInfo.de_json(parse_json('{"id":1,"type":"group"}'))
