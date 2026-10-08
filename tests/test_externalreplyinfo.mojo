from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import ExternalReplyInfo, MessageOrigin
from telegram._utils.datetime import TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var data = parse_json(
        '{"origin":{"type":"user","date":1767312000,"sender_user":{"id":7,"first_name":"Ada","is_bot":false}},"chat":{"id":-42,"type":"supergroup","title":"Old"},"message_id":99,"photo":[{"file_id":"photo","file_unique_id":"photo-unique","width":32,"height":24}],"has_media_spoiler":true,"future":{"v":1}}'
    )
    var info = ExternalReplyInfo.de_json(data)
    assert_equal(info.origin.type, MessageOrigin.USER)
    assert_equal(info.chat.value().id, -42)
    assert_equal(info.message_id.value(), 99)
    assert_equal(info.photo[0].file_id, "photo")
    assert_equal(info.has_media_spoiler.value(), True)
    assert_equal(info.api_kwargs.object_get(info.api_kwargs.root, "future") != -1, True)
    var encoded = info.to_json()
    var decoded = ExternalReplyInfo.de_json(parse_json(encoded))
    assert_equal(decoded == info, True)
    assert_equal(len(ExternalReplyInfo.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var same_origin = MessageOrigin.user(
        TimestampDateTime(2026, 1, 2),
        info.origin.sender_user.value(),
    )
    assert_equal(info == ExternalReplyInfo(same_origin), True)
    with assert_raises():
        _ = ExternalReplyInfo.de_json(parse_json('{"message_id":1}'))
