from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InlineQuery, Location, User
from telegram._utils.json import parse_json


def main() raises:
    var sender = User(77, "Ada", False, username=Optional[String]("ada"))
    var query = InlineQuery(
        "qid", sender, "search text", "offset-1",
        Optional[Location](Location(-122.4, 37.8)), Optional[String]("private"),
    )
    assert_equal(query.id, "qid")
    assert_equal(query.from_user.username.value(), "ada")
    assert_equal(query.query, "search text")
    assert_equal(query.location.value().latitude, 37.8)
    assert_equal(query.chat_type.value(), "private")

    var decoded = InlineQuery.de_json(
        parse_json(
            '{"id":"qid","from":{"id":77,"first_name":"Ada","is_bot":false,"username":"ada"},"query":"search text","offset":"offset-1","location":{"longitude":-122.4,"latitude":37.8},"chat_type":"private","future":9}'
        )
    )
    assert_equal(decoded == query, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "from") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "future") != -1, True)
    assert_equal(InlineQuery.MAX_RESULTS, 50)
    assert_equal(InlineQuery.MAX_OFFSET_LENGTH, 64)
    assert_equal(InlineQuery.MAX_QUERY_LENGTH, 256)
    assert_equal(len(InlineQuery.de_list(parse_json('[{"id":"x","from":{"id":1,"first_name":"x","is_bot":false},"query":"","offset":""}]'), 0)), 1)
    with assert_raises():
        _ = InlineQuery.de_json(parse_json('{"id":"missing"}'))
