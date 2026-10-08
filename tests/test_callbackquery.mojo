from std.testing import assert_equal, assert_raises

from telegram import CallbackQuery
from telegram._utils.json import parse_json


def main() raises:
    var decoded = CallbackQuery.de_json(parse_json(
        '{"id":"query-1","from":{"id":21,"first_name":"Ada","is_bot":false},'
        '"chat_instance":"chat-token","message":{"message_id":8,"date":1700000000,'
        '"chat":{"id":3,"type":"private"},"future":"kept"},'
        '"data":"action","inline_message_id":"inline-2","game_short_name":"chess",'
        '"future_flag":[1,2]}'
    ))
    assert_equal(decoded.id, "query-1")
    assert_equal(decoded.from_user.id, 21)
    assert_equal(decoded.chat_instance, "chat-token")
    assert_equal(decoded.data.value(), "action")
    assert_equal(decoded.inline_message_id.value(), "inline-2")
    assert_equal(decoded.game_short_name.value(), "chess")
    assert_equal(decoded.message.value().message_id, 8)
    assert_equal(decoded.message.value().is_accessible(), True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future_flag") != -1, True)
    assert_equal(CallbackQuery.MAX_ANSWER_TEXT_LENGTH, 200)

    var encoded = decoded.to_dict()
    assert_equal(encoded.object_get(encoded.root, "from") != -1, True)
    assert_equal(encoded.object_get(encoded.root, "from_user"), -1)
    assert_equal(encoded.object_get(encoded.root, "message") != -1, True)
    var round_trip = CallbackQuery.de_json(parse_json(decoded.to_json()))
    assert_equal(round_trip == decoded, True)
    assert_equal(hash(round_trip), hash(decoded))

    var same_id = CallbackQuery.de_json(parse_json(
        '{"id":"query-1","from":{"id":22,"first_name":"Lin","is_bot":true},'
        '"chat_instance":"different","data":"different"}'
    ))
    assert_equal(same_id == decoded, True)
    assert_equal(hash(same_id), hash(decoded))
    var inaccessible = CallbackQuery.de_json(parse_json(
        '{"id":"inaccessible","from":{"id":1,"first_name":"u","is_bot":false},'
        '"chat_instance":"c","message":{"message_id":9,"date":0,'
        '"chat":{"id":-100,"type":"supergroup"}}}'
    ))
    assert_equal(inaccessible.message.value().message_id, 9)
    assert_equal(inaccessible.message.value().is_accessible(), False)
    assert_equal(inaccessible.message.value().date().timestamp(), 0.0)
    var inaccessible_round_trip = CallbackQuery.de_json(parse_json(inaccessible.to_json()))
    assert_equal(inaccessible_round_trip.message.value().is_accessible(), False)
    assert_equal(len(CallbackQuery.de_list(parse_json(
        '[{"id":"q","from":{"id":1,"first_name":"u","is_bot":false},"chat_instance":"c"}]'
    ), 0)), 1)
    with assert_raises():
        _ = CallbackQuery.de_json(parse_json('{"id":"missing-user"}'))
