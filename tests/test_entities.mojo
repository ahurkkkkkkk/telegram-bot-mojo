from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import MessageEntity
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import parse_json


def main() raises:
    var text = "A😀Bold"
    var bold = MessageEntity("bold", 3, 4)
    var future = MessageEntity("future_entity", 3, 4)
    var entities = List[MessageEntity]()
    entities.append(bold.copy())
    entities.append(future.copy())

    assert_equal(parse_message_entity(text, bold), "Bold")
    var all_known = parse_message_entities(text, entities)
    assert_equal(len(all_known), 1)
    assert_equal(all_known[bold], "Bold")

    var requested_type = List[String]()
    requested_type.append("future_entity")
    var selected_future = parse_message_entities(
        text, entities, Optional[List[String]](requested_type.copy())
    )
    assert_equal(len(selected_future), 1)
    assert_equal(selected_future[future], "Bold")

    var empty_filter = parse_message_entities(text, entities, Optional[List[String]](List[String]()))
    assert_equal(len(empty_filter), 0)
    assert_equal(len(MessageEntity.ALL_TYPES), 20)

    var decoded = MessageEntity.de_json(
        parse_json("{\"type\":\"url\",\"offset\":3,\"length\":4}")
    )
    assert_equal(parse_message_entity(text, decoded), "Bold")
