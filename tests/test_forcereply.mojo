from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import ForceReply
from telegram._utils.json import parse_json


def main() raises:
    var reply = ForceReply(Optional[Bool](True), Optional[String]("Answer here"))
    assert_equal(
        reply.to_json(),
        "{\"force_reply\": true, \"input_field_placeholder\": \"Answer here\", \"selective\": true}",
    )
    assert_equal(ForceReply.MIN_INPUT_FIELD_PLACEHOLDER, 1)
    assert_equal(ForceReply.MAX_INPUT_FIELD_PLACEHOLDER, 64)
    var decoded = ForceReply.de_json(
        parse_json("{\"force_reply\":false,\"selective\":null,\"future\":1}")
    )
    assert_equal(decoded.force_reply, True)
    assert_equal(decoded.selective is None, True)
    assert_equal(
        decoded.to_json(),
        "{\"force_reply\": true, \"future\": 1}",
    )
    assert_equal(decoded == ForceReply(), True)
    assert_equal(hash(decoded), hash(ForceReply()))
    assert_equal(len(ForceReply.de_list(parse_json("[{}]"), 0)), 1)
    with assert_raises():
        _ = ForceReply.de_json(parse_json("[]"))
