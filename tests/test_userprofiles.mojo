from std.collections import List
from std.testing import assert_equal, assert_raises

from telegram import Audio, PhotoSize, UserProfileAudios, UserProfilePhotos
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var audios = List[Audio]()
    audios.append(Audio("a", "au", TimeDelta(4)))
    var audio_page = UserProfileAudios(3, audios^)
    assert_equal(
        audio_page.to_json(),
        "{\"total_count\": 3, \"audios\": [{\"file_id\": \"a\", \"file_unique_id\": \"au\", \"duration\": 4}]}",
    )
    var decoded_audios = UserProfileAudios.de_json(
        parse_json("{\"total_count\":3,\"audios\":[{\"file_id\":\"a\",\"file_unique_id\":\"au\",\"duration\":4}],\"future\":true}")
    )
    assert_equal(decoded_audios.audios[0].file_unique_id, "au")
    assert_equal(
        decoded_audios.to_json(),
        "{\"total_count\": 3, \"audios\": [{\"file_id\": \"a\", \"file_unique_id\": \"au\", \"duration\": 4}], \"future\": true}",
    )
    var equal_audios = List[Audio]()
    equal_audios.append(Audio("different", "au", TimeDelta(100)))
    assert_equal(decoded_audios == UserProfileAudios(3, equal_audios^), True)
    assert_equal(len(UserProfileAudios.de_list(parse_json("[{\"total_count\":0}]"), 0)), 1)

    var first_row = List[PhotoSize]()
    first_row.append(PhotoSize("small", "small-u", 64, 64))
    first_row.append(PhotoSize("large", "large-u", 640, 640))
    var second_row = List[PhotoSize]()
    second_row.append(PhotoSize("other", "other-u", 128, 128))
    var photo_rows = List[List[PhotoSize]]()
    photo_rows.append(first_row^)
    photo_rows.append(second_row^)
    var photo_page = UserProfilePhotos(2, photo_rows^)
    assert_equal(
        photo_page.to_json(),
        "{\"total_count\": 2, \"photos\": [[{\"file_id\": \"small\", \"file_unique_id\": \"small-u\", \"height\": 64, \"width\": 64}, {\"file_id\": \"large\", \"file_unique_id\": \"large-u\", \"height\": 640, \"width\": 640}], [{\"file_id\": \"other\", \"file_unique_id\": \"other-u\", \"height\": 128, \"width\": 128}]]}",
    )
    var decoded_photos = UserProfilePhotos.de_json(
        parse_json("{\"total_count\":2,\"photos\":[[{\"file_id\":\"s\",\"file_unique_id\":\"su\",\"width\":1,\"height\":1}],[{\"file_id\":\"b\",\"file_unique_id\":\"bu\",\"width\":2,\"height\":2}]],\"future\":0}")
    )
    assert_equal(len(decoded_photos.photos), 2)
    assert_equal(decoded_photos.photos[1][0].file_unique_id, "bu")
    assert_equal(decoded_photos == UserProfilePhotos(2, decoded_photos.photos.copy()), True)
    assert_equal(len(UserProfilePhotos.de_list(parse_json("[{\"total_count\":0,\"photos\":[]}]"), 0)), 1)
    with assert_raises():
        _ = UserProfilePhotos.de_json(parse_json("{}"))
