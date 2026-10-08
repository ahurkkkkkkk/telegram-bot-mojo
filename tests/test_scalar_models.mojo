from std.testing import assert_equal

from telegram import (
    AcceptedGiftTypes,
    ChatBoostAdded,
    GiftBackground,
    PaidMessagePriceChanged,
    SuggestedPostPrice,
    UniqueGiftBackdropColors,
    WebAppData,
)
from telegram._utils.json import parse_json


def main() raises:
    var boost = ChatBoostAdded.de_json(
        parse_json("{\"boost_count\":2,\"future\":\"kept\"}")
    )
    assert_equal(boost.boost_count, 2)
    assert_equal(boost == ChatBoostAdded(2), True)
    assert_equal(hash(boost), hash(ChatBoostAdded(2)))
    assert_equal(
        boost.to_json(),
        "{\"boost_count\": 2, \"future\": \"kept\"}",
    )

    var background = GiftBackground.de_json(
        parse_json("{\"center_color\":1,\"edge_color\":2,\"text_color\":3}")
    )
    assert_equal(background == GiftBackground(1, 2, 3), True)
    assert_equal(hash(background), hash(GiftBackground(1, 2, 3)))
    assert_equal(
        background.to_json(),
        "{\"center_color\": 1, \"edge_color\": 2, \"text_color\": 3}",
    )

    var accepted = AcceptedGiftTypes.de_json(
        parse_json("{\"unlimited_gifts\":true,\"limited_gifts\":false,\"unique_gifts\":true,\"premium_subscription\":false,\"gifts_from_channels\":true}")
    )
    assert_equal(
        accepted == AcceptedGiftTypes(True, False, True, False, True), True
    )
    assert_equal(
        hash(accepted), hash(AcceptedGiftTypes(True, False, True, False, True))
    )
    assert_equal(
        accepted.to_json(),
        "{\"gifts_from_channels\": true, \"limited_gifts\": false, \"premium_subscription\": false, \"unique_gifts\": true, \"unlimited_gifts\": true}",
    )

    var price = SuggestedPostPrice.de_json(
        parse_json("{\"currency\":\"XTR\",\"amount\":50}")
    )
    assert_equal(price == SuggestedPostPrice("XTR", 50), True)
    assert_equal(hash(price), hash(SuggestedPostPrice("XTR", 50)))
    assert_equal(price.to_json(), "{\"amount\": 50, \"currency\": \"XTR\"}")

    var backdrop = UniqueGiftBackdropColors.de_json(
        parse_json("{\"center_color\":1,\"edge_color\":2,\"symbol_color\":3,\"text_color\":4}")
    )
    assert_equal(backdrop == UniqueGiftBackdropColors(1, 2, 3, 4), True)
    assert_equal(hash(backdrop), hash(UniqueGiftBackdropColors(1, 2, 3, 4)))

    var web_app_data = WebAppData.de_json(
        parse_json("{\"data\":\"payload\",\"button_text\":\"Open\"}")
    )
    assert_equal(web_app_data == WebAppData("payload", "Open"), True)
    assert_equal(hash(web_app_data), hash(WebAppData("payload", "Open")))
    assert_equal(
        web_app_data.to_json(),
        "{\"button_text\": \"Open\", \"data\": \"payload\"}",
    )

    var price_change = PaidMessagePriceChanged.de_json(
        parse_json("{\"paid_message_star_count\":7}")
    )
    assert_equal(price_change == PaidMessagePriceChanged(7), True)
    assert_equal(hash(price_change), hash(PaidMessagePriceChanged(7)))
