from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import MessageEntity, User
from telegram._utils.datetime import TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var entity = MessageEntity(
        MessageEntity.TEXT_LINK, 2, 4, url=Optional[String]("https://example.com"),
        user=Optional[User](User(7, "Ada", False)),
        date_time_format=Optional[String]("yyyy-mm-dd"),
        unix_time=Optional[TimestampDateTime](TimestampDateTime(2026, 1, 2)),
    )
    assert_equal(entity.type, "text_link")
    assert_equal(entity.extract_text("xxboldyy"), "bold")
    assert_equal(entity == MessageEntity(MessageEntity.TEXT_LINK, 2, 4), True)

    var decoded = MessageEntity.de_json(
        parse_json(
            '{"type":"text_link","offset":2,"length":4,"url":"https://example.com","user":{"id":7,"first_name":"Ada","is_bot":false},"date_time_format":"yyyy-mm-dd","unix_time":1767312000,"future":true}'
        )
    )
    assert_equal(decoded == entity, True)
    assert_equal(decoded.user.value().first_name, "Ada")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "unix_time") != -1, True)
    assert_equal(len(MessageEntity.de_list(parse_json('[{"type":"bold","offset":0,"length":2}]'), 0)), 1)

    var unicode_entities = List[MessageEntity]()
    unicode_entities.append(MessageEntity(MessageEntity.BOLD, 2, 4))
    var adjusted = MessageEntity.adjust_message_entities_to_utf_16("𠌕 bold", unicode_entities)
    assert_equal(adjusted[0].offset, 3)
    assert_equal(adjusted[0].length, 4)
    var shifted = MessageEntity.shift_entities("𝄢", unicode_entities)
    assert_equal(shifted[0].offset, 4)
    with assert_raises():
        _ = MessageEntity.de_json(parse_json('{"type":"bold"}'))
