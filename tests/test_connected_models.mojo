from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    ChosenInlineResult,
    GameHighScore,
    Location,
    OrderInfo,
    ShippingAddress,
    User,
)
from telegram._utils.json import parse_json


def main() raises:
    var score = GameHighScore(1, User(42, "Ada", False), 99)
    assert_equal(
        score.to_json(),
        "{\"position\": 1, \"user\": {\"id\": 42, \"first_name\": \"Ada\", \"is_bot\": false}, \"score\": 99}",
    )
    var decoded_score = GameHighScore.de_json(
        parse_json("{\"position\":2,\"user\":{\"id\":7,\"first_name\":\"Lin\",\"is_bot\":false},\"score\":50}")
    )
    assert_equal(decoded_score.user.id, 7)
    assert_equal(decoded_score == GameHighScore(2, User(7, "different", True), 50), True)
    assert_equal(len(GameHighScore.de_list(parse_json("[{\"position\":1,\"user\":{\"id\":1,\"first_name\":\"x\",\"is_bot\":false},\"score\":0}]"), 0)), 1)

    var address = ShippingAddress("US", "CA", "Oakland", "1 Main", "", "94612")
    var order = OrderInfo(
        Optional[String]("Ada"),
        Optional[String]("+15551234"),
        Optional[String]("ada@example.test"),
        Optional[ShippingAddress](address.copy()),
    )
    assert_equal(order.shipping_address.value().city, "Oakland")
    var decoded_order = OrderInfo.de_json(
        parse_json("{\"name\":\"Ada\",\"phone_number\":null,\"shipping_address\":{\"country_code\":\"US\",\"state\":\"CA\",\"city\":\"Oakland\",\"street_line1\":\"1 Main\",\"street_line2\":\"\",\"post_code\":\"94612\"},\"future\":true}")
    )
    assert_equal(decoded_order.phone_number is None, True)
    assert_equal(decoded_order.shipping_address.value().city, "Oakland")
    assert_equal(
        decoded_order.to_json(),
        "{\"name\": \"Ada\", \"shipping_address\": {\"city\": \"Oakland\", \"country_code\": \"US\", \"post_code\": \"94612\", \"state\": \"CA\", \"street_line1\": \"1 Main\", \"street_line2\": \"\"}, \"future\": true}",
    )
    assert_equal(len(OrderInfo.de_list(parse_json("[{}]"), 0)), 1)

    var chosen = ChosenInlineResult(
        "result", User(5, "A", False), "query",
        Optional[Location](Location(-45.25, 12.5).copy()),
        Optional[String]("inline-id")
    )
    assert_equal(
        chosen.to_json(),
        "{\"result_id\": \"result\", \"from\": {\"id\": 5, \"first_name\": \"A\", \"is_bot\": false}, \"location\": {\"latitude\": 12.5, \"longitude\": -45.25}, \"inline_message_id\": \"inline-id\", \"query\": \"query\"}",
    )
    var decoded_chosen = ChosenInlineResult.de_json(
        parse_json("{\"result_id\":\"r\",\"from\":{\"id\":5,\"first_name\":\"A\",\"is_bot\":false},\"query\":\"q\",\"location\":null,\"future\":1}")
    )
    assert_equal(decoded_chosen.from_user.id, 5)
    assert_equal(decoded_chosen.location is None, True)
    assert_equal(decoded_chosen == ChosenInlineResult("r", User(9, "x", True), "other"), True)
    assert_equal(len(ChosenInlineResult.de_list(parse_json("[{\"result_id\":\"r\",\"from\":{\"id\":5,\"first_name\":\"A\",\"is_bot\":false},\"query\":\"q\"}]"), 0)), 1)
    with assert_raises():
        _ = ChosenInlineResult.de_json(parse_json("{}"))
