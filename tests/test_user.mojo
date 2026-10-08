from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import User
from telegram._utils.json import parse_json


def main() raises:
    var user = User(
        42,
        "Ada",
        False,
        Optional[String]("Lovelace"),
        Optional[String]("ada"),
        Optional[String]("en"),
        is_premium=Optional[Bool](True),
        can_manage_bots=Optional[Bool](False),
    )
    assert_equal(user.name(), "@ada")
    assert_equal(user.full_name(), "Ada Lovelace")
    assert_equal(user.link().value(), "https://t.me/ada")
    assert_equal(user.mention_html(), "<a href=\"tg://user?id=42\">Ada Lovelace</a>")
    assert_equal(user.mention_markdown(), "[Ada Lovelace](tg://user?id=42)")
    assert_equal(user.mention_markdown_v2(), "[Ada Lovelace](tg://user?id=42)")
    assert_equal(
        user.to_json(),
        "{\"id\": 42, \"first_name\": \"Ada\", \"is_bot\": false, \"last_name\": \"Lovelace\", \"username\": \"ada\", \"language_code\": \"en\", \"is_premium\": true, \"can_manage_bots\": false}",
    )
    var decoded = User.de_json(
        parse_json("{\"id\":42,\"first_name\":\"Ada\",\"is_bot\":false,\"username\":null,\"can_join_groups\":false,\"future\":{\"x\":1}}")
    )
    assert_equal(decoded.id, 42)
    assert_equal(decoded.username is None, True)
    assert_equal(decoded.can_join_groups.value(), False)
    assert_equal(decoded.name(), "Ada")
    assert_equal(
        decoded.to_json(),
        "{\"id\": 42, \"first_name\": \"Ada\", \"is_bot\": false, \"can_join_groups\": false, \"future\": {\"x\": 1}}",
    )
    assert_equal(decoded == User(42, "Different", True), True)
    assert_equal(hash(decoded), hash(User(42, "Different", True)))
    assert_equal(len(User.de_list(parse_json("[{\"id\":1,\"first_name\":\"x\",\"is_bot\":true}]"), 0)), 1)
    with assert_raises():
        _ = User.de_json(parse_json("{}"))
