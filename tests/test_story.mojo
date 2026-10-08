from std.testing import assert_equal, assert_raises

from telegram import Chat, Story
from telegram._utils.json import parse_json


def main() raises:
    var chat = Chat(-100123, "channel", title="Stories")
    var story = Story(chat, 37)
    assert_equal(story == Story(Chat(-100123, "supergroup"), 37), True)
    assert_equal(story == Story(chat, 38), False)
    assert_equal(
        story.to_json(),
        '{"chat": {"id": -100123, "type": "channel", "title": "Stories"}, "id": 37}',
    )

    var parsed = Story.de_json(
        parse_json(
            '{"chat":{"id":42,"type":"private","first_name":"Ada"},"id":9,"future":{"ok":true}}'
        )
    )
    assert_equal(parsed.chat.id, 42)
    assert_equal(parsed.id, 9)
    assert_equal(
        parsed.to_json(),
        '{"chat": {"id": 42, "type": "private", "first_name": "Ada"}, "id": 9, "future": {"ok": true}}',
    )

    var stories = Story.de_list(parse_json('[{"chat":{"id":1,"type":"group"},"id":2}]'), 0)
    assert_equal(len(stories), 1)
    assert_equal(stories[0].id, 2)
    with assert_raises():
        _ = Story.de_json(parse_json('{"id":4}'))
