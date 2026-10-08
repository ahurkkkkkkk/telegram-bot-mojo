from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    Gift,
    MessageEntity,
    OwnedGift,
    OwnedGifts,
    Sticker,
    UniqueGift,
    UniqueGiftBackdrop,
    UniqueGiftBackdropColors,
    UniqueGiftModel,
    UniqueGiftSymbol,
)
from telegram._utils.datetime import from_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var gift_data = parse_json(
        "{\"id\":\"regular-id\",\"sticker\":{\"file_id\":\"f\",\"file_unique_id\":\"sticker-id\",\"width\":100,\"height\":100,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"},\"star_count\":10}"
    )
    var gift = Gift.de_json(gift_data)
    var regular = OwnedGift.regular(
        gift,
        from_timestamp(1_700_000_000),
        owned_gift_id=Optional[String]("owned-regular"),
        text=Optional[String]("A🧡B"),
        entities=Optional[List[MessageEntity]](
            [MessageEntity("bold", 1, 2)]
        ),
        is_saved=Optional[Bool](True),
    )
    assert_equal(regular.type, OwnedGift.REGULAR)
    assert_equal(regular.parse_entity(MessageEntity("bold", 1, 2)), "🧡")
    assert_equal(len(regular.parse_entities()), 1)
    var regular_roundtrip = OwnedGift.de_json(regular.to_dict())
    assert_equal(regular == regular_roundtrip, True)
    assert_equal(hash(regular), hash(regular_roundtrip))
    assert_equal(regular_roundtrip.field("owned_gift_id").value().string_value(regular_roundtrip.field("owned_gift_id").value().root), "owned-regular")

    var sticker = Sticker("file", "sticker-unique", 100, 100, False, False, "regular")
    var model = UniqueGiftModel("model", sticker, 10)
    var symbol = UniqueGiftSymbol("symbol", sticker, 20)
    var backdrop = UniqueGiftBackdrop(
        "backdrop", UniqueGiftBackdropColors(1, 2, 3, 4), 30
    )
    var unique_gift = UniqueGift(
        "regular-id", "Moon", "Moon-1", 1, model, symbol, backdrop
    )
    var unique_owned = OwnedGift.unique(
        unique_gift,
        from_timestamp(1_700_000_001),
        owned_gift_id=Optional[String]("owned-unique"),
        can_be_transferred=Optional[Bool](True),
        transfer_star_count=Optional[Int](5),
        next_transfer_date=Optional(from_timestamp(1_700_000_100)),
    )
    assert_equal(unique_owned.type, OwnedGift.UNIQUE)
    var unique_roundtrip = OwnedGift.de_json(unique_owned.to_dict())
    assert_equal(unique_owned == unique_roundtrip, True)
    assert_equal(hash(unique_owned), hash(unique_roundtrip))
    assert_equal(OwnedGift.unique(unique_gift, from_timestamp(1_700_000_002)) == unique_owned, False)

    var items = List[OwnedGift]()
    items.append(regular.copy())
    items.append(unique_owned.copy())
    var owned_gifts = OwnedGifts(2, items, Optional[String]("next"))
    var owned_gifts_roundtrip = OwnedGifts.de_json(owned_gifts.to_dict())
    assert_equal(owned_gifts == owned_gifts_roundtrip, True)
    assert_equal(owned_gifts_roundtrip.gifts[0].type, OwnedGift.REGULAR)
    assert_equal(owned_gifts_roundtrip.gifts[1].type, OwnedGift.UNIQUE)
    assert_equal(owned_gifts_roundtrip.next_offset.value(), "next")

    var unknown = OwnedGift.de_json(parse_json("{\"type\":\"future_owned_type\",\"x\":1}"))
    assert_equal(unknown.type, "future_owned_type")
    assert_equal(unknown.to_json(), "{\"type\": \"future_owned_type\", \"x\": 1}")
    with assert_raises():
        _ = OwnedGift.de_json(parse_json("{\"type\":\"regular\"}"))
