from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._chat import Chat
from telegram._poll import PollAnswer
from telegram._user import User
from telegram._utils.json import parse_json


def main() raises:
    var option_ids = List[Int]()
    option_ids.append(0)
    option_ids.append(2)
    var persistent_ids = List[String]()
    persistent_ids.append("opt-a")
    persistent_ids.append("opt-c")
    var user = User(7, "Ada", False)
    var voter_chat = Chat(-100123, "channel")
    var answer = PollAnswer(
        "poll-1",
        option_ids,
        persistent_ids,
        Optional[User](user.copy()),
        Optional[Chat](voter_chat.copy()),
    )
    var encoded = answer.to_json()
    var decoded = PollAnswer.de_json(parse_json(encoded))
    assert_equal(decoded == answer, True)
    assert_equal(decoded.option_persistent_ids[1], "opt-c")
    assert_equal(decoded.user.value().id, 7)
    assert_equal(decoded.voter_chat.value().id, -100123)
    assert_equal(len(PollAnswer.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var same_identity_ids = List[String]()
    same_identity_ids.append("different-0")
    same_identity_ids.append("different-2")
    var same_identity = PollAnswer(
        "poll-1",
        option_ids.copy(),
        same_identity_ids,
        Optional[User](user.copy()),
        Optional[Chat](voter_chat.copy()),
    )
    assert_equal(answer == same_identity, True)
    assert_equal(hash(answer), hash(same_identity))

    var future = PollAnswer.de_json(
        parse_json('{"poll_id":"poll-2","option_ids":[],"option_persistent_ids":[],"future":{"x":1}}')
    )
    assert_equal(future.to_json(), '{"poll_id": "poll-2", "option_ids": [], "option_persistent_ids": [], "future": {"x": 1}}')
    with assert_raises():
        _ = PollAnswer.de_json(parse_json('{"poll_id":"missing-ids"}'))
