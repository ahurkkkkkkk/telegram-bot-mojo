from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import MessageEntity, PollOptionAdded, PollOptionDeleted
from telegram._utils.json import JsonDocument, parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity("bold", 3, 6))
    var message = parse_json('{"message_id":7,"chat":{"id":-7,"type":"group"}}')
    var added = PollOptionAdded(
        "stable-option",
        "A🚀Answer",
        Optional[JsonDocument](message.copy()),
        entities,
    )
    assert_equal(added.parse_option_text_entity(entities[0]), "Answer")
    assert_equal(len(added.parse_option_text_entities()), 1)
    var added_json = added.to_json()
    var added_roundtrip = PollOptionAdded.de_json(parse_json(added_json))
    assert_equal(added_roundtrip == added, True)
    assert_equal(added_roundtrip.poll_message.value().object_get(added_roundtrip.poll_message.value().root, "message_id") != -1, True)
    assert_equal(added_roundtrip.to_json(), added_json)
    assert_equal(len(PollOptionAdded.de_list(parse_json("[" + added_json + "]"), 0)), 1)

    var deleted = PollOptionDeleted(
        "stable-option",
        "A🚀Answer",
        Optional[JsonDocument](message.copy()),
        entities,
    )
    assert_equal(deleted == PollOptionDeleted("stable-option", "A🚀Answer"), True)
    var deleted_json = deleted.to_json()
    var deleted_roundtrip = PollOptionDeleted.de_json(parse_json(deleted_json))
    assert_equal(deleted_roundtrip == deleted, True)
    assert_equal(deleted_roundtrip.parse_option_text_entity(entities[0]), "Answer")
    assert_equal(deleted_roundtrip.to_json(), deleted_json)
    assert_equal(len(PollOptionDeleted.de_list(parse_json("[" + deleted_json + "]"), 0)), 1)
    with assert_raises():
        _ = PollOptionAdded.de_json(parse_json("{}"))
