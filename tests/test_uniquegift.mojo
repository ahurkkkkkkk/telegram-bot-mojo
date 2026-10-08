from std.testing import assert_equal

from telegram import (
    UniqueGift,
    UniqueGiftColors,
    UniqueGiftInfo,
)
from telegram._utils.json import parse_json


def main() raises:
    var colors = UniqueGiftColors.de_json(
        parse_json(
            "{\"model_custom_emoji_id\":\"model-emoji\",\"symbol_custom_emoji_id\":\"symbol-emoji\",\"light_theme_main_color\":1,\"light_theme_other_colors\":[2,3],\"dark_theme_main_color\":4,\"dark_theme_other_colors\":[5,6],\"future\":true}"
        )
    )
    assert_equal(colors.model_custom_emoji_id, "model-emoji")
    assert_equal(colors.dark_theme_other_colors[1], 6)
    var colors_roundtrip = UniqueGiftColors.de_json(colors.to_dict())
    assert_equal(colors == colors_roundtrip, True)
    assert_equal(hash(colors), hash(colors_roundtrip))
    assert_equal(
        colors_roundtrip.to_dict().boolean_value(
            colors_roundtrip.to_dict().object_get(colors_roundtrip.to_dict().root, "future")
        ),
        True,
    )

    var sticker_json = "{\"file_id\":\"file\",\"file_unique_id\":\"sticker-unique\",\"width\":512,\"height\":512,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"}"
    var gift = UniqueGift.de_json(
        parse_json(
            "{\"gift_id\":\"regular-id\",\"base_name\":\"Moon\",\"name\":\"Moon-1\",\"number\":1,\"model\":{\"name\":\"model\",\"sticker\":" + sticker_json + ",\"rarity_per_mille\":10,\"rarity\":\"rare\"},\"symbol\":{\"name\":\"symbol\",\"sticker\":" + sticker_json + ",\"rarity_per_mille\":20},\"backdrop\":{\"name\":\"backdrop\",\"colors\":{\"center_color\":1,\"edge_color\":2,\"symbol_color\":3,\"text_color\":4},\"rarity_per_mille\":30},\"publisher_chat\":{\"id\":-100,\"type\":\"channel\"},\"is_from_blockchain\":false,\"is_premium\":true,\"colors\":" + colors.to_json() + ",\"is_burned\":false,\"future\":\"kept\"}"
        )
    )
    assert_equal(gift.base_name, "Moon")
    assert_equal(gift.model.rarity.value(), "rare")
    assert_equal(gift.symbol.rarity_per_mille, 20)
    assert_equal(gift.backdrop.colors.text_color, 4)
    assert_equal(gift.publisher_chat.value().id, -100)
    assert_equal(gift.colors.value().model_custom_emoji_id, "model-emoji")
    var gift_roundtrip = UniqueGift.de_json(gift.to_dict())
    assert_equal(gift == gift_roundtrip, True)
    assert_equal(hash(gift), hash(gift_roundtrip))
    var distinct_gift_id = UniqueGift(
        "different-regular-id",
        gift.base_name,
        gift.name,
        gift.number,
        gift.model.copy(),
        gift.symbol.copy(),
        gift.backdrop.copy(),
    )
    assert_equal(gift == distinct_gift_id, True)

    var info = UniqueGiftInfo.de_json(
        parse_json(
            "{\"gift\":" + gift.to_json() + ",\"origin\":\"offer\",\"owned_gift_id\":\"owned\",\"transfer_star_count\":12,\"next_transfer_date\":1700000000,\"last_resale_currency\":\"XTR\",\"last_resale_amount\":8,\"future\":true}"
        )
    )
    assert_equal(info.origin, UniqueGiftInfo.OFFER)
    assert_equal(info.next_transfer_date.value().year, 2023)
    assert_equal(info.last_resale_amount.value(), 8)
    var info_roundtrip = UniqueGiftInfo.de_json(info.to_dict())
    assert_equal(info == info_roundtrip, True)
    assert_equal(hash(info), hash(info_roundtrip))
    var info_list = parse_json("[" + info.to_json() + "]")
    assert_equal(len(UniqueGiftInfo.de_list(info_list, info_list.root)), 1)
