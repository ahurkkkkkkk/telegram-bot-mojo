from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Chat, MessageEntity, PhotoSize, PollMedia, PollOption, User
from telegram._utils.datetime import TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity("bold", 3, 6))
    var photos = List[PhotoSize]()
    photos.append(PhotoSize("photo-id", "photo-unique", 64, 48))
    var media = PollMedia(photo=photos)
    var option = PollOption(
        "A🚀Answer",
        4,
        entities,
        Optional[User](User(21, "Nia", False)),
        Optional[Chat](Chat(-21, "group")),
        Optional[TimestampDateTime](TimestampDateTime(2026, 10, 1, 12, 30)),
        Optional[PollMedia](media.copy()),
        Optional[String]("persistent-1"),
    )
    assert_equal(option.parse_entity(entities[0]), "Answer")
    assert_equal(len(option.parse_entities()), 1)
    var encoded = option.to_json()
    var decoded = PollOption.de_json(parse_json(encoded))
    assert_equal(decoded == option, True)
    assert_equal(decoded.added_by_user.value().id, 21)
    assert_equal(decoded.added_by_chat.value().id, -21)
    assert_equal(decoded.addition_date.value().year, 2026)
    assert_equal(decoded.media.value().photo[0].file_id, "photo-id")
    assert_equal(len(PollOption.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var future = PollOption.de_json(
        parse_json('{"text":"yes","voter_count":2,"persistent_id":"next","future":true}')
    )
    assert_equal(future.to_json(), '{"text": "yes", "voter_count": 2, "persistent_id": "next", "future": true}')
    assert_equal(option == PollOption("A🚀Answer", 4, persistent_id=Optional[String]("persistent-1")), True)
    with assert_raises():
        _ = PollOption("Missing id", 0)
    with assert_raises():
        _ = PollOption.de_json(parse_json('{"text":"yes","voter_count":2}'))
