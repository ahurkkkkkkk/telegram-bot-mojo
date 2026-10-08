from std.testing import assert_equal, assert_raises

from telegram import (
    ChatBoostSourceGiftCode,
    ChatBoostSourceGiveaway,
    ChatBoostSourcePremium,
    Update,
)
from telegram._utils.json import parse_json


def main() raises:
    var source = parse_json(
        '{"update_id":9001,"message":{"message_id":42,"date":1700000000,'
        '"chat":{"id":-1001,"type":"supergroup"},'
        '"from":{"id":7,"first_name":"Ada","is_bot":false},"text":"hello"},'
        '"future_update":{"kept":true}}'
    )
    var update = Update.de_json(source)
    assert_equal(update.update_id, 9001)
    assert_equal(update.message.value().text.value(), "hello")
    assert_equal(update.effective_message().value().message_id, 42)
    assert_equal(update.effective_user().value().id, 7)
    assert_equal(update.effective_chat().value().id, -1001)
    var sender = update.effective_sender()
    assert_equal(sender.user.value().id, 7)
    assert_equal(sender.chat is None, True)
    assert_equal(update.api_kwargs.object_get(update.api_kwargs.root, "future_update") != -1, True)

    var decoded = Update.de_json(parse_json(update.to_json()))
    assert_equal(decoded == update, True)
    assert_equal(decoded.effective_user().value().first_name, "Ada")
    assert_equal(decoded.effective_chat().value().id, -1001)
    assert_equal(len(Update.all_types()), 25)
    assert_equal(Update.all_types()[0], "message")
    assert_equal(Update.all_types()[24], "guest_message")
    assert_equal(len(Update.de_list(parse_json('[{"update_id":1}]'), 0)), 1)
    var business_update = Update.de_json(parse_json(
        '{"update_id":9002,"business_connection":{"id":"biz-1",'
        '"user":{"id":8,"first_name":"Bo","is_bot":false},'
        '"user_chat_id":8,"date":10,"is_enabled":true},'
        '"deleted_business_messages":{"business_connection_id":"biz-1",'
        '"chat":{"id":-30,"type":"supergroup"},"message_ids":[2,4]}}'
    ))
    assert_equal(business_update.business_connection.value().user.id, 8)
    assert_equal(business_update.effective_user().value().id, 8)
    assert_equal(business_update.deleted_business_messages.value().message_ids[1], 4)
    assert_equal(business_update.effective_chat().value().id, -30)
    var business_round_trip = Update.de_json(parse_json(business_update.to_json()))
    assert_equal(business_round_trip.business_connection.value().id, "biz-1")
    assert_equal(business_round_trip.deleted_business_messages.value().message_ids[0], 2)
    var boost_update = Update.de_json(parse_json(
        '{"update_id":9003,"chat_boost":{"chat":{"id":-40,"type":"supergroup"},'
        '"boost":{"boost_id":"boost-1","add_date":20,"expiration_date":40,'
        '"source":{"source":"premium","user":{"id":9,"first_name":"Cy",'
        '"is_bot":false}}}}}'
    ))
    assert_equal(boost_update.chat_boost.value().boost.source.source, "premium")
    assert_equal(boost_update.chat_boost.value().boost.source.user.value().id, 9)
    assert_equal(boost_update.effective_chat().value().id, -40)
    var boost_round_trip = Update.de_json(parse_json(boost_update.to_json()))
    assert_equal(boost_round_trip.chat_boost.value().boost.boost_id, "boost-1")
    var removed_boost_update = Update.de_json(parse_json(
        '{"update_id":9004,"removed_chat_boost":{"chat":{"id":-41,"type":"supergroup"},'
        '"boost_id":"boost-2","remove_date":30,'
        '"source":{"source":"giveaway","giveaway_message_id":77,"prize_star_count":3}}}'
    ))
    assert_equal(removed_boost_update.removed_chat_boost.value().source.giveaway_message_id.value(), 77)
    assert_equal(removed_boost_update.effective_chat().value().id, -41)
    var premium_source = ChatBoostSourcePremium.de_json(parse_json(
        '{"source":"premium","user":{"id":9,"first_name":"Cy","is_bot":false}}'
    ))
    assert_equal(premium_source.user.id, 9)
    assert_equal(
        ChatBoostSourcePremium.de_json(parse_json(premium_source.to_json())) == premium_source,
        True,
    )
    var gift_source = ChatBoostSourceGiftCode.de_json(parse_json(
        '{"source":"gift_code","user":{"id":10,"first_name":"Di","is_bot":false}}'
    ))
    assert_equal(gift_source.to_source().source, "gift_code")
    var giveaway_source = ChatBoostSourceGiveaway.de_json(parse_json(
        '{"source":"giveaway","giveaway_message_id":77,"prize_star_count":3,'
        '"is_unclaimed":true}'
    ))
    assert_equal(giveaway_source.giveaway_message_id, 77)
    assert_equal(giveaway_source.prize_star_count.value(), 3)
    assert_equal(giveaway_source.to_source().is_unclaimed.value(), True)
    with assert_raises():
        _ = Update.de_json(parse_json(
            '{"update_id":9005,"chat_boost":{"chat":{"id":-42,"type":"supergroup"},'
            '"boost":{"boost_id":"bad","add_date":20,"expiration_date":40,'
            '"source":{"source":"premium"}}}}'
        ))
    with assert_raises():
        _ = Update.de_json(parse_json(
            '{"update_id":9006,"removed_chat_boost":{"chat":{"id":-43,"type":"supergroup"},'
            '"boost_id":"bad","remove_date":30,"source":{"source":"giveaway"}}}'
        ))
    with assert_raises():
        _ = Update.de_json(parse_json("{}"))
