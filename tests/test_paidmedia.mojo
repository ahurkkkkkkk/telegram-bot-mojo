from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    PaidMedia,
    PaidMediaInfo,
    PaidMediaPurchased,
    PhotoSize,
    User,
)
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import JSON_ARRAY, parse_json


def main() raises:
    var preview = PaidMedia.preview(
        Optional[Int](320), Optional[Int](240), Optional[TimeDelta](TimeDelta(8))
    )
    assert_equal(preview.type, PaidMedia.PREVIEW)
    var preview_json = preview.to_dict()
    assert_equal(preview_json.integer_value(preview_json.object_get(preview_json.root, "width")), 320)
    var preview_parsed = PaidMedia.de_json(
        parse_json("{\"type\":\"preview\",\"width\":320,\"height\":240,\"duration\":8.0}")
    )
    assert_equal(preview == preview_parsed, True)
    assert_equal(PaidMedia.de_json(parse_json("{\"type\":\"preview\"}")) == PaidMedia.preview(), True)

    var photos = List[PhotoSize]()
    photos.append(PhotoSize("file-a", "unique-a", 100, 80))
    var photo = PaidMedia.photo(photos)
    var photo_parsed = PaidMedia.de_json(
        parse_json(
            "{\"type\":\"photo\",\"photo\":[{\"file_id\":\"changed\",\"file_unique_id\":\"unique-a\",\"width\":100,\"height\":80}]}"
        )
    )
    assert_equal(photo == photo_parsed, True)
    var photo_value = photo.to_dict()
    assert_equal(photo_value.nodes[photo_value.object_get(photo_value.root, "photo")].kind, JSON_ARRAY)

    var video = PaidMedia.de_json(
        parse_json(
            "{\"type\":\"video\",\"video\":{\"file_id\":\"f\",\"file_unique_id\":\"video-u\",\"width\":320,\"height\":240,\"duration\":8}}"
        )
    )
    assert_equal(video.type, PaidMedia.VIDEO)
    var live = PaidMedia.de_json(
        parse_json(
            "{\"type\":\"live_photo\",\"live_photo\":{\"file_id\":\"f\",\"file_unique_id\":\"live-u\",\"width\":320,\"height\":240,\"duration\":8}}"
        )
    )
    assert_equal(live.type, PaidMedia.LIVE_PHOTO)
    with assert_raises():
        _ = PaidMedia.de_json(parse_json("{\"type\":\"video\"}"))

    var media_values = List[PaidMedia]()
    media_values.append(preview.copy())
    media_values.append(photo.copy())
    var info = PaidMediaInfo(15, media_values)
    var info_roundtrip = PaidMediaInfo.de_json(info.to_dict())
    assert_equal(info == info_roundtrip, True)
    assert_equal(len(info_roundtrip.paid_media), 2)

    var purchase = PaidMediaPurchased(User(123, "Buyer", False), "payload")
    var purchase_roundtrip = PaidMediaPurchased.de_json(
        parse_json("{\"from\":{\"id\":123,\"first_name\":\"Buyer\",\"is_bot\":false},\"paid_media_payload\":\"payload\",\"future\":true}")
    )
    assert_equal(purchase == purchase_roundtrip, True)
    assert_equal(purchase_roundtrip.from_user.id, 123)
    assert_equal(
        purchase_roundtrip.to_dict().boolean_value(
            purchase_roundtrip.to_dict().object_get(purchase_roundtrip.to_dict().root, "future")
        ),
        True,
    )
