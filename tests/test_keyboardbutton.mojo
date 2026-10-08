from std.testing import assert_equal, assert_raises

from telegram import KeyboardButton
from telegram._utils.json import parse_json


def main() raises:
    var source = (
        '{"text":"Select","request_contact":false,"request_location":true,'
        '"request_poll":{"type":"quiz"},"web_app":{"url":"https://example.org/app"},'
        '"request_chat":{"request_id":12,"chat_is_channel":true,"chat_is_forum":false},'
        '"request_users":{"request_id":13,"max_quantity":3},"style":"success",'
        '"icon_custom_emoji_id":"emoji-1","request_managed_bot":{"request_id":14},'
        '"request_user":{"request_id":7},"future_flag":true}'
    )
    var decoded = KeyboardButton.de_json(parse_json(source))
    assert_equal(decoded.text, "Select")
    assert_equal(decoded.request_contact.value(), False)
    assert_equal(decoded.request_location.value(), True)
    assert_equal(decoded.request_poll.value().type.value(), "quiz")
    assert_equal(decoded.web_app.value().url, "https://example.org/app")
    assert_equal(decoded.request_chat.value().request_id, 12)
    assert_equal(decoded.request_users.value().max_quantity.value(), 3)
    assert_equal(decoded.style.value(), "success")
    assert_equal(decoded.icon_custom_emoji_id.value(), "emoji-1")
    assert_equal(decoded.request_managed_bot.value().request_id, 14)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "request_user") != -1, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_flag") != -1, True)

    var output = decoded.to_dict()
    assert_equal(output.object_get(output.root, "request_managed_bot") != -1, True)
    assert_equal(output.object_get(output.root, "request_chat") != -1, True)
    var round_trip = KeyboardButton.de_json(parse_json(decoded.to_json()))
    assert_equal(round_trip == decoded, True)
    assert_equal(hash(round_trip), hash(decoded))

    # Upstream identity deliberately ignores request_managed_bot and api_kwargs.
    var same_identity = KeyboardButton.de_json(parse_json(
        '{"text":"Select","request_contact":false,"request_location":true,'
        '"request_poll":{"type":"quiz"},"web_app":{"url":"https://example.org/app"},'
        '"request_chat":{"request_id":12,"chat_is_channel":true,"chat_is_forum":false},'
        '"request_users":{"request_id":13,"max_quantity":3},"style":"success",'
        '"icon_custom_emoji_id":"emoji-1","future_flag":false}'
    ))
    assert_equal(same_identity == decoded, True)
    assert_equal(hash(same_identity), hash(decoded))
    assert_equal(len(KeyboardButton.de_list(parse_json('[{"text":"A"}]'), 0)), 1)
    with assert_raises():
        _ = KeyboardButton.de_json(parse_json("{}"))
