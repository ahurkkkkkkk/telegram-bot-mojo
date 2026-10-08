from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import BotAccessSettings, User
from telegram._utils.json import parse_json


def main() raises:
    var users = List[User]()
    users.append(User(42, "Ada", False))
    var settings = BotAccessSettings(True, Optional[List[User]](users^))
    assert_equal(
        settings.to_json(),
        "{\"is_access_restricted\": true, \"added_users\": [{\"id\": 42, \"first_name\": \"Ada\", \"is_bot\": false}]}",
    )
    var decoded = BotAccessSettings.de_json(
        parse_json("{\"is_access_restricted\":false,\"added_users\":[{\"id\":7,\"first_name\":\"Lin\",\"is_bot\":false}],\"future\":1}")
    )
    assert_equal(decoded.is_access_restricted, False)
    assert_equal(len(decoded.added_users), 1)
    assert_equal(decoded.added_users[0].first_name, "Lin")
    assert_equal(
        decoded.to_json(),
        "{\"is_access_restricted\": false, \"added_users\": [{\"id\": 7, \"first_name\": \"Lin\", \"is_bot\": false}], \"future\": 1}",
    )
    assert_equal(decoded == BotAccessSettings(False), False)
    assert_equal(len(BotAccessSettings.de_list(parse_json("[{\"is_access_restricted\":true}]"), 0)), 1)
    with assert_raises():
        _ = BotAccessSettings.de_json(parse_json("{}"))
