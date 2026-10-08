from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    Chat,
    Gift,
    PaidMedia,
    Sticker,
    TransactionPartner,
    User,
)
from telegram._payment.stars.affiliateinfo import AffiliateInfo
from telegram._payment.stars.revenuewithdrawalstate import RevenueWithdrawalState
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var raw_affiliate = TransactionPartner.de_json(
        parse_json(
            "{\"type\":\"affiliate_program\",\"commission_per_mille\":25,\"future\":{\"x\":1}}"
        )
    )
    assert_equal(raw_affiliate.type, TransactionPartner.AFFILIATE_PROGRAM)
    assert_equal(raw_affiliate == TransactionPartner.affiliate_program(25), True)
    assert_equal(
        raw_affiliate.to_json(),
        "{\"type\": \"affiliate_program\", \"commission_per_mille\": 25, \"future\": {\"x\": 1}}",
    )
    var future = raw_affiliate.field("future")
    assert_equal(future is not None, True)
    assert_equal(future.value().integer_value(future.value().object_get(future.value().root, "x")), 1)

    var sticker = Sticker("file", "unique-sticker", 100, 100, False, False, "regular")
    var gift = Gift("gift-42", sticker, 10)
    var chat_a = TransactionPartner.chat(
        Chat(42, "private"), Optional[Gift](gift.copy())
    )
    var chat_b = TransactionPartner.de_json(
        parse_json(
            "{\"type\":\"chat\",\"chat\":{\"id\":42,\"type\":\"channel\",\"title\":\"renamed\"},\"gift\":{\"id\":\"gift-42\",\"sticker\":{\"file_id\":\"file\",\"file_unique_id\":\"unique-sticker\",\"width\":100,\"height\":100,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"},\"star_count\":10}}"
        )
    )
    assert_equal(chat_a == chat_b, True)

    var fragment_pending = TransactionPartner.fragment(
        Optional[RevenueWithdrawalState](RevenueWithdrawalState.pending())
    )
    var fragment_failed = TransactionPartner.de_json(
        parse_json(
            "{\"type\":\"fragment\",\"withdrawal_state\":{\"type\":\"failed\"}}"
        )
    )
    assert_equal(fragment_pending == fragment_failed, True)

    var user = User(7, "Ada", False)
    var user_a = TransactionPartner.user("invoice_payment", user, invoice_payload=Optional[String]("a"))
    var user_b = TransactionPartner.de_json(
        parse_json(
            "{\"type\":\"user\",\"transaction_type\":\"invoice_payment\",\"user\":{\"id\":7,\"first_name\":\"Different name\",\"is_bot\":false},\"invoice_payload\":\"b\"}"
        )
    )
    assert_equal(user_a == user_b, True)
    var user_other_transaction = TransactionPartner.de_json(
        parse_json(
            "{\"type\":\"user\",\"transaction_type\":\"gift_purchase\",\"user\":{\"id\":7,\"first_name\":\"Ada\",\"is_bot\":false}}"
        )
    )
    assert_equal(user_a == user_other_transaction, False)

    var media = List[PaidMedia]()
    media.append(PaidMedia.preview())
    var rich_user = TransactionPartner.user(
        "paid_media_payment",
        user,
        paid_media=Optional[List[PaidMedia]](media.copy()),
        subscription_period=Optional[TimeDelta](TimeDelta(60, 500000)),
        gift=Optional[Gift](gift.copy()),
        affiliate=Optional[AffiliateInfo](AffiliateInfo(10, 3)),
        premium_subscription_duration=Optional[Int](3),
    )
    var rich_roundtrip = TransactionPartner.de_json(rich_user.to_dict())
    assert_equal(rich_user == rich_roundtrip, True)
    assert_equal(rich_roundtrip.type, TransactionPartner.USER)

    assert_equal(TransactionPartner.other() == TransactionPartner.other(), True)
    assert_equal(TransactionPartner.other() == TransactionPartner.telegram_ads(), False)
    assert_equal(TransactionPartner.telegram_api(3) == TransactionPartner.telegram_api(4), False)

    var unknown_a = TransactionPartner.de_json(parse_json("{\"type\":\"future_type\",\"x\":1}"))
    var unknown_b = TransactionPartner.de_json(parse_json("{\"type\":\"future_type\",\"x\":2}"))
    assert_equal(unknown_a == unknown_b, True)
    assert_equal(unknown_a.to_dict().integer_value(unknown_a.to_dict().object_get(unknown_a.to_dict().root, "x")), 1)

    var list_data = parse_json(
        "[{\"type\":\"other\"},{\"type\":\"telegram_ads\"}]"
    )
    var list_values = TransactionPartner.de_list(list_data, list_data.root)
    assert_equal(len(list_values), 2)
    assert_equal(list_values[0].type, TransactionPartner.OTHER)
    assert_equal(list_values[1].type, TransactionPartner.TELEGRAM_ADS)

    with assert_raises():
        _ = TransactionPartner.de_json(parse_json("{}"))
    with assert_raises():
        _ = TransactionPartner.de_json(
            parse_json("{\"type\":\"user\",\"user\":{\"id\":7}}")
        )
