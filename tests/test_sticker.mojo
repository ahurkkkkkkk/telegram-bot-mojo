from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import File, MaskPosition, PhotoSize, Sticker, StickerSet
from telegram._utils.json import parse_json


def main() raises:
    var mask = MaskPosition(MaskPosition.EYES, 0.0, -0.25, 1.5)
    var thumb = PhotoSize("thumb", "thumb-u", 100, 80)
    var premium = File("premium", "premium-u", Optional[Int](256), Optional[String]("premium.tgs"))
    var sticker = Sticker(
        "sticker", "sticker-u", 512, 512, False, False, Sticker.MASK,
        Optional[String]("🙂"), Optional[Int](2048), Optional[String]("set_name"),
        Optional[MaskPosition](mask.copy()), Optional[File](premium.copy()),
        Optional[String]("custom-id"), Optional[PhotoSize](thumb.copy()), Optional[Bool](True)
    )
    assert_equal(
        sticker.to_json(),
        "{\"file_id\": \"sticker\", \"file_unique_id\": \"sticker-u\", \"width\": 512, \"height\": 512, \"is_animated\": false, \"is_video\": false, \"type\": \"mask\", \"emoji\": \"\\ud83d\\ude42\", \"file_size\": 2048, \"set_name\": \"set_name\", \"mask_position\": {\"point\": \"eyes\", \"x_shift\": 0.0, \"y_shift\": -0.25, \"scale\": 1.5}, \"premium_animation\": {\"file_id\": \"premium\", \"file_unique_id\": \"premium-u\", \"file_size\": 256, \"file_path\": \"premium.tgs\"}, \"custom_emoji_id\": \"custom-id\", \"thumbnail\": {\"file_id\": \"thumb\", \"file_unique_id\": \"thumb-u\", \"height\": 80, \"width\": 100}, \"needs_repainting\": true}",
    )
    var decoded = Sticker.de_json(
        parse_json("{\"file_id\":\"s\",\"file_unique_id\":\"su\",\"width\":64,\"height\":64,\"is_animated\":false,\"is_video\":true,\"type\":\"regular\",\"thumbnail\":{\"file_id\":\"t\",\"file_unique_id\":\"tu\",\"width\":4,\"height\":3},\"thumb\":{\"old\":true},\"future\":1}")
    )
    assert_equal(decoded.type, Sticker.REGULAR)
    assert_equal(decoded.is_video, True)
    assert_equal(decoded.thumbnail.value().file_unique_id, "tu")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "thumb") != -1, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded == Sticker("x", "su", 1, 1, False, False, "regular"), True)
    assert_equal(hash(decoded), hash(Sticker("x", "su", 9, 9, True, True, "mask")))
    assert_equal(len(Sticker.de_list(parse_json("[{\"file_id\":\"a\",\"file_unique_id\":\"b\",\"width\":1,\"height\":1,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"}]"), 0)), 1)

    var stickers = List[Sticker]()
    stickers.append(sticker.copy())
    var set_value = StickerSet("set_name", "Set", stickers^, Sticker.MASK, Optional[PhotoSize](thumb.copy()))
    assert_equal(set_value.stickers[0].file_unique_id, "sticker-u")
    var decoded_set = StickerSet.de_json(
        parse_json("{\"name\":\"set_name\",\"title\":\"Set\",\"sticker_type\":\"regular\",\"stickers\":[{\"file_id\":\"s\",\"file_unique_id\":\"su\",\"width\":64,\"height\":64,\"is_animated\":false,\"is_video\":false,\"type\":\"regular\"}],\"contains_masks\":true}")
    )
    assert_equal(decoded_set.stickers[0].file_unique_id, "su")
    assert_equal(
        decoded_set.api_kwargs.object_get(decoded_set.api_kwargs.root, "contains_masks") != -1,
        True,
    )
    assert_equal(decoded_set == StickerSet("set_name", "different", List[Sticker](), "mask"), True)
    assert_equal(len(StickerSet.de_list(parse_json("[{\"name\":\"n\",\"title\":\"t\",\"sticker_type\":\"regular\",\"stickers\":[]}]"), 0)), 1)
    with assert_raises():
        _ = Sticker.de_json(parse_json("{}"))
