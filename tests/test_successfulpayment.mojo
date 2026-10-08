from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import OrderInfo, SuccessfulPayment
from telegram._utils.datetime import from_timestamp
from telegram._utils.json import JSON_BOOL, JSON_NUMBER, parse_json


def main() raises:
    var expiration = from_timestamp(1_700_000_000)
    var payment = SuccessfulPayment(
        "XTR",
        250,
        "invoice",
        "telegram-charge",
        "provider-charge",
        Optional[String]("express"),
        Optional[OrderInfo](OrderInfo(name=Optional[String]("Ada"))),
        Optional(expiration.copy()),
        Optional[Bool](False),
        Optional[Bool](True),
    )
    assert_equal(payment == SuccessfulPayment("USD", 1, "x", "telegram-charge", "provider-charge"), True)
    assert_equal(
        hash(payment),
        hash(SuccessfulPayment("USD", 2, "y", "telegram-charge", "provider-charge")),
    )

    var json = payment.to_dict()
    assert_equal(json.string_value(json.object_get(json.root, "currency")), "XTR")
    assert_equal(json.integer_value(json.object_get(json.root, "total_amount")), 250)
    assert_equal(json.nodes[json.object_get(json.root, "is_recurring")].kind, JSON_BOOL)
    assert_equal(json.boolean_value(json.object_get(json.root, "is_recurring")), False)
    assert_equal(
        json.integer_value(json.object_get(json.root, "subscription_expiration_date")),
        1_700_000_000,
    )
    assert_equal(json.object_get(json.root, "order_info") != -1, True)

    var decoded = SuccessfulPayment.de_json(
        parse_json(
            "{\"currency\":\"XTR\",\"total_amount\":250,\"invoice_payload\":\"invoice\",\"telegram_payment_charge_id\":\"telegram-charge\",\"provider_payment_charge_id\":\"provider-charge\",\"shipping_option_id\":\"express\",\"order_info\":{\"name\":\"Ada\"},\"subscription_expiration_date\":1700000000,\"is_recurring\":false,\"is_first_recurring\":true,\"future\":123}"
        )
    )
    assert_equal(decoded.telegram_payment_charge_id, "telegram-charge")
    assert_equal(decoded.provider_payment_charge_id, "provider-charge")
    assert_equal(decoded.order_info.value().name.value(), "Ada")
    assert_equal(decoded.subscription_expiration_date.value().year, 2023)
    assert_equal(decoded.is_recurring.value(), False)
    var decoded_json = decoded.to_dict()
    assert_equal(decoded_json.integer_value(decoded_json.object_get(decoded_json.root, "future")), 123)
    assert_equal(
        len(
            SuccessfulPayment.de_list(
                parse_json(
                    "[{\"currency\":\"XTR\",\"total_amount\":1,\"invoice_payload\":\"x\",\"telegram_payment_charge_id\":\"t\",\"provider_payment_charge_id\":\"p\"}]"
                ),
                0,
            )
        ),
        1,
    )
    with assert_raises():
        _ = SuccessfulPayment.de_json(parse_json("{}"))
