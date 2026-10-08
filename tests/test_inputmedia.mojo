from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import (
    Audio,
    InputFile,
    InputMediaAudio,
    InputMediaLivePhoto,
    InputMediaLocation,
    InputMediaPhoto,
    InputMediaVenue,
    InputPaidMediaLivePhoto,
    InputPaidMediaPhoto,
)
from telegram._utils.json import parse_json


def _bytes() -> List[UInt8]:
    var result = List[UInt8]()
    result.append(65)
    result.append(66)
    return result^


def main() raises:
    var file_id = InputMediaPhoto("photo-file-id")
    var file_id_json = file_id.to_dict()
    assert_equal(file_id_json.string_value(file_id_json.object_get(file_id_json.root, "type")), "photo")
    assert_equal(file_id_json.string_value(file_id_json.object_get(file_id_json.root, "media")), "photo-file-id")

    var photo = InputMediaPhoto(InputFile(_bytes(), Optional[String]("photo.png"), False))
    assert_equal(len(photo.upload_files()), 1)
    var media_index = photo.data.object_get(photo.data.root, "media")
    assert_equal(photo.data.string_value(media_index).byte_length() > 9, True)

    var live_photo = InputMediaLivePhoto(
        InputFile(_bytes(), Optional[String]("video.mp4"), False),
        InputFile(_bytes(), Optional[String]("photo.jpg"), False),
    )
    assert_equal(len(live_photo.upload_files()), 2)
    assert_equal(live_photo.data.object_get(live_photo.data.root, "photo") != -1, True)

    var paid_photo = InputPaidMediaPhoto("paid-photo-id")
    assert_equal(paid_photo.data.string_value(paid_photo.data.object_get(paid_photo.data.root, "type")), "photo")
    var paid_live = InputPaidMediaLivePhoto("video-id", "photo-id")
    assert_equal(paid_live.data.object_get(paid_live.data.root, "photo") != -1, True)

    var audio_model = Audio.de_json(
        parse_json('{"file_id":"audio-id","file_unique_id":"audio-unique","duration":3,"performer":"Singer","title":"Song"}')
    )
    var audio_input = InputMediaAudio(audio_model)
    assert_equal(audio_input.data.string_value(audio_input.data.object_get(audio_input.data.root, "media")), "audio-id")
    assert_equal(audio_input.data.number_text(audio_input.data.object_get(audio_input.data.root, "duration")), "3")
    assert_equal(audio_input.data.string_value(audio_input.data.object_get(audio_input.data.root, "performer")), "Singer")

    var location = InputMediaLocation(47.0, 8.0, Optional[Float64](2.5))
    assert_equal(location.data.object_get(location.data.root, "media"), -1)
    var latitude_index = location.data.object_get(location.data.root, "latitude")
    assert_equal(location.data.number_text(latitude_index), "47.0")
    assert_equal(location.data.object_get(location.data.root, "horizontal_accuracy") != -1, True)
    var venue = InputMediaVenue(47.0, 8.0, "Place", "Street")
    assert_equal(venue.data.object_get(venue.data.root, "title") != -1, True)
