from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Chat
from telegram._utils.json import parse_json


def main() raises:
    var chat = Chat(
        -100123,
        "supergroup",
        title=Optional[String]("Native Mojo"),
        username=Optional[String]("native_mojo"),
        is_forum=Optional[Bool](True),
    )
    assert_equal(chat.type(), "supergroup")
    assert_equal(chat.effective_name().value(), "Native Mojo")
    assert_equal(chat.link().value(), "https://t.me/native_mojo")
    assert_equal(chat.mention_markdown(), "[Native Mojo](https://t.me/native_mojo)")
    assert_equal(chat.mention_markdown_v2(), "[Native Mojo](https://t.me/native_mojo)")
    assert_equal(
        chat.mention_markdown_v2(Optional[String]("News_Updates")),
        "[News\\_Updates](https://t.me/native_mojo)",
    )
    assert_equal(
        chat.mention_html(Optional[String]("<News & Updates>")),
        "<a href=\"https://t.me/native_mojo\">&lt;News &amp; Updates&gt;</a>",
    )
    assert_equal(
        chat.to_json(),
        '{"id": -100123, "type": "supergroup", "title": "Native Mojo", "username": "native_mojo", "is_forum": true}',
    )

    var decoded = Chat.de_json(
        parse_json(
            '{"id":42,"type":"private","first_name":"Ada","last_name":"Lovelace","is_direct_messages":false,"future":{"ok":true}}'
        )
    )
    assert_equal(decoded.id, 42)
    assert_equal(decoded.full_name().value(), "Ada Lovelace")
    assert_equal(decoded.effective_name().value(), "Ada Lovelace")
    assert_equal(decoded.mention_html(), "<a href=\"tg://user?id=42\">Ada Lovelace</a>")
    assert_equal(
        decoded.to_json(),
        '{"id": 42, "type": "private", "first_name": "Ada", "last_name": "Lovelace", "is_direct_messages": false, "future": {"ok": true}}',
    )
    assert_equal(decoded == Chat(42, "channel"), True)
    assert_equal(hash(decoded), hash(Chat(42, "channel")))
    assert_equal(len(Chat.de_list(parse_json('[{"id":1,"type":"group"}]'), 0)), 1)
    with assert_raises():
        _ = Chat.de_json(parse_json("{}"))
    with assert_raises():
        _ = Chat(-2, "group").mention_markdown()
    var unnamed = Chat(43, "private", first_name=Optional[String](""))
    assert_equal(unnamed.full_name() is None, True)
    assert_equal(unnamed.effective_name() is None, True)
