from std.collections import List
from std.testing import assert_equal, assert_raises

from telegram import LabeledPrice, ShippingOption
from telegram._utils.json import parse_json


def main() raises:
    var prices = List[LabeledPrice]()
    prices.append(LabeledPrice("Shipping", 250))
    prices.append(LabeledPrice("Handling", 50))
    var option = ShippingOption("express", "Express", prices)
    assert_equal(
        option.to_json(),
        "{\"id\": \"express\", \"prices\": [{\"amount\": 250, \"label\": \"Shipping\"}, {\"amount\": 50, \"label\": \"Handling\"}], \"title\": \"Express\"}",
    )

    var decoded = ShippingOption.de_json(
        parse_json(
            "{\"id\":\"express\",\"title\":\"Express\",\"prices\":[{\"label\":\"Shipping\",\"amount\":250},{\"label\":\"Handling\",\"amount\":50}],\"future\":true}"
        )
    )
    assert_equal(decoded.id, "express")
    assert_equal(decoded.title, "Express")
    assert_equal(len(decoded.prices), 2)
    assert_equal(decoded.prices[0].amount, 250)
    assert_equal(
        decoded.to_json(),
        "{\"id\": \"express\", \"prices\": [{\"amount\": 250, \"label\": \"Shipping\"}, {\"amount\": 50, \"label\": \"Handling\"}], \"title\": \"Express\", \"future\": true}",
    )
    assert_equal(decoded == ShippingOption("express", "Other", List[LabeledPrice]()), True)
    assert_equal(hash(decoded), hash(ShippingOption("express", "Other", List[LabeledPrice]())))

    var empty_prices = ShippingOption.de_json(
        parse_json("{\"id\":\"x\",\"title\":\"Empty\",\"prices\":[]}")
    )
    assert_equal(empty_prices.to_json(), "{\"id\": \"x\", \"title\": \"Empty\"}")

    var listed = ShippingOption.de_list(
        parse_json("[{\"id\":\"x\",\"title\":\"X\",\"prices\":[]}]"), 0
    )
    assert_equal(len(listed), 1)
    with assert_raises():
        _ = ShippingOption.de_json(parse_json("{\"id\":\"x\",\"title\":\"X\",\"prices\":{}}"))
