from std.collections import List
from std.testing import assert_equal, assert_raises

from telegram import Gift, GiftInfo, Gifts, MessageEntity
from telegram._utils.json import JSON_ARRAY, parse_json


def main() raises:
    var gift_data = parse_json(
        "{\"id\":\"gift-1\",\"sticker\":{\"file_id\":\"f\",\"file_unique_id\":\"u\",\"width\":512,\"height\":512,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"},\"star_count\":25,\"total_count\":100,\"remaining_count\":80,\"upgrade_star_count\":5,\"publisher_chat\":{\"id\":-100,\"type\":\"channel\"},\"personal_total_count\":20,\"personal_remaining_count\":15,\"background\":{\"center_color\":1,\"edge_color\":2,\"text_color\":3},\"is_premium\":true,\"has_colors\":false,\"unique_gift_variant_count\":4,\"future\":{\"x\":true}}"
    )
    var gift = Gift.de_json(gift_data)
    assert_equal(gift.id, "gift-1")
    assert_equal(gift.sticker.file_unique_id, "u")
    assert_equal(gift.star_count, 25)
    assert_equal(gift.total_count.value(), 100)
    assert_equal(gift.publisher_chat.value().id, -100)
    assert_equal(gift.background.value().edge_color, 2)
    assert_equal(gift.is_premium.value(), True)
    assert_equal(gift.unique_gift_variant_count.value(), 4)
    var round_trip = gift.to_dict()
    var future_index = round_trip.object_get(round_trip.root, "future")
    assert_equal(
        round_trip.boolean_value(round_trip.object_get(future_index, "x")), True
    )
    var same_id = Gift.de_json(
        parse_json(
            "{\"id\":\"gift-1\",\"sticker\":{\"file_id\":\"other\",\"file_unique_id\":\"other\",\"width\":1,\"height\":1,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"},\"star_count\":1}"
        )
    )
    assert_equal(gift == same_id, True)
    assert_equal(hash(gift), hash(same_id))

    var gift_rows = List[Gift]()
    gift_rows.append(gift.copy())
    var gifts = Gifts(gift_rows)
    var gifts_json = gifts.to_dict()
    assert_equal(gifts_json.nodes[gifts_json.object_get(gifts_json.root, "gifts")].kind, JSON_ARRAY)
    var decoded_gifts = Gifts.de_json(
        parse_json("{\"gifts\":[" + gift.to_json() + "],\"future\":7}")
    )
    assert_equal(len(decoded_gifts.gifts), 1)
    assert_equal(decoded_gifts.gifts[0] == gift, True)
    assert_equal(
        decoded_gifts.to_dict().integer_value(
            decoded_gifts.to_dict().object_get(decoded_gifts.to_dict().root, "future")
        ),
        7,
    )

    var gift_info_data = parse_json(
        "{\"gift\":" + gift.to_json() + ",\"owned_gift_id\":\"owned-1\",\"convert_star_count\":3,\"prepaid_upgrade_star_count\":4,\"can_be_upgraded\":true,\"text\":\"A🧡B\",\"entities\":[{\"type\":\"bold\",\"offset\":1,\"length\":2},{\"type\":\"future_entity\",\"offset\":0,\"length\":1}],\"is_private\":false,\"unique_gift_number\":8,\"is_upgrade_separate\":true,\"future\":9}"
    )
    var gift_info = GiftInfo.de_json(gift_info_data)
    assert_equal(gift_info.owned_gift_id.value(), "owned-1")
    assert_equal(gift_info.entities[0].type, "bold")
    assert_equal(
        gift_info.parse_entity(gift_info.entities[0]), "🧡"
    )
    var parsed_entities = gift_info.parse_entities()
    assert_equal(len(parsed_entities), 1)
    assert_equal(parsed_entities[gift_info.entities[0]], "🧡")
    var explicit_types = List[String]()
    explicit_types.append("future_entity")
    var explicitly_parsed = gift_info.parse_entities(Optional[List[String]](explicit_types.copy()))
    assert_equal(len(explicitly_parsed), 1)
    assert_equal(explicitly_parsed[gift_info.entities[1]], "A")
    var gift_info_roundtrip = GiftInfo.de_json(gift_info.to_dict())
    assert_equal(gift_info == gift_info_roundtrip, True)
    with assert_raises():
        _ = Gift.de_json(parse_json("{\"id\":\"missing fields\"}"))
    with assert_raises():
        _ = GiftInfo.de_json(parse_json("{}"))
