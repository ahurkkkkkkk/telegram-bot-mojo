from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    OrderInfo,
    PreCheckoutQuery,
    ShippingAddress,
    ShippingQuery,
    User,
)
from telegram._utils.json import JSON_OBJECT, JSON_STRING, parse_json


def main() raises:
    var user = User(42, "Ada", False, username=Optional[String]("ada"))
    var address = ShippingAddress("US", "CA", "Oakland", "1 Main", "Apt 2", "94612")
    var shipping = ShippingQuery("shipping-1", user, "payload", address)
    assert_equal(shipping == ShippingQuery("shipping-1", User(5, "Other", True), "x", address), True)
    assert_equal(
        hash(shipping),
        hash(ShippingQuery("shipping-1", User(5, "Other", True), "x", address)),
    )
    var shipping_json = shipping.to_dict()
    assert_equal(shipping_json.nodes[shipping_json.root].kind, JSON_OBJECT)
    assert_equal(shipping_json.object_get(shipping_json.root, "from_user"), -1)
    var from_index = shipping_json.object_get(shipping_json.root, "from")
    assert_equal(shipping_json.integer_value(shipping_json.object_get(from_index, "id")), 42)
    var decoded_shipping = ShippingQuery.de_json(
        parse_json(
            "{\"id\":\"shipping-1\",\"from\":{\"id\":42,\"first_name\":\"Ada\",\"is_bot\":false},\"invoice_payload\":\"payload\",\"shipping_address\":{\"country_code\":\"US\",\"state\":\"CA\",\"city\":\"Oakland\",\"street_line1\":\"1 Main\",\"street_line2\":\"Apt 2\",\"post_code\":\"94612\"},\"future\":true}"
        )
    )
    assert_equal(decoded_shipping.id, "shipping-1")
    assert_equal(decoded_shipping.from_user.first_name, "Ada")
    assert_equal(decoded_shipping.shipping_address.city, "Oakland")
    assert_equal(
        decoded_shipping.to_dict().boolean_value(
            decoded_shipping.to_dict().object_get(decoded_shipping.to_dict().root, "future")
        ),
        True,
    )

    var order_info = OrderInfo(name=Optional[String]("Ada"), email=Optional[String]("a@b.test"))
    var checkout = PreCheckoutQuery(
        "checkout-1",
        user,
        "XTR",
        125,
        "invoice-payload",
        Optional[String]("express"),
        Optional[OrderInfo](order_info.copy()),
    )
    var checkout_json = checkout.to_dict()
    assert_equal(checkout_json.string_value(checkout_json.object_get(checkout_json.root, "currency")), "XTR")
    assert_equal(checkout_json.integer_value(checkout_json.object_get(checkout_json.root, "total_amount")), 125)
    assert_equal(checkout_json.object_get(checkout_json.root, "from_user"), -1)
    assert_equal(checkout_json.object_get(checkout_json.root, "order_info") != -1, True)
    var decoded_checkout = PreCheckoutQuery.de_json(
        parse_json(
            "{\"id\":\"checkout-1\",\"from\":{\"id\":42,\"first_name\":\"Ada\",\"is_bot\":false},\"currency\":\"XTR\",\"total_amount\":125,\"invoice_payload\":\"invoice-payload\",\"shipping_option_id\":\"express\",\"order_info\":{\"name\":\"Ada\",\"email\":\"a@b.test\"},\"future\":\"retained\"}"
        )
    )
    assert_equal(decoded_checkout.id, "checkout-1")
    assert_equal(decoded_checkout.from_user.id, 42)
    assert_equal(decoded_checkout.total_amount, 125)
    assert_equal(decoded_checkout.order_info.value().name.value(), "Ada")
    var future_index = decoded_checkout.to_dict().object_get(
        decoded_checkout.to_dict().root, "future"
    )
    assert_equal(future_index != -1, True)
    assert_equal(decoded_checkout == PreCheckoutQuery("checkout-1", User(5, "Other", True), "USD", 0, "x"), True)

    assert_equal(
        ShippingQuery.de_list(
            parse_json(
                "[{\"id\":\"s\",\"from\":{\"id\":1,\"first_name\":\"x\",\"is_bot\":false},\"invoice_payload\":\"p\",\"shipping_address\":{\"country_code\":\"US\",\"state\":\"\",\"city\":\"\",\"street_line1\":\"\",\"street_line2\":\"\",\"post_code\":\"\"}}]"
            ),
            0,
        ).__len__(),
        1,
    )
    with assert_raises():
        _ = PreCheckoutQuery.de_json(parse_json("{}"))

