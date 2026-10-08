from std.collections import List
from std.testing import assert_equal, assert_raises

from telegram import (
    User,
    VideoChatEnded,
    VideoChatParticipantsInvited,
    VideoChatScheduled,
    VideoChatStarted,
)
from telegram._utils.datetime import TimeDelta, TimestampDateTime, to_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var started = VideoChatStarted()
    assert_equal(started.to_json(), "{}")
    var decoded_started = VideoChatStarted.de_json(parse_json("{}"))
    assert_equal(decoded_started == started, True)
    assert_equal(hash(decoded_started), hash(started))
    assert_equal(len(VideoChatStarted.de_list(parse_json("[{},{}]"), 0)), 2)

    var started_future = VideoChatStarted.de_json(parse_json('{"future":true}'))
    assert_equal(started_future.api_kwargs.object_get(started_future.api_kwargs.root, "future") != -1, True)

    var ended = VideoChatEnded(TimeDelta(12, 500000))
    assert_equal(ended.to_json(), '{"duration": 12.5}')
    var decoded_ended = VideoChatEnded.de_json(parse_json(ended.to_json()))
    assert_equal(decoded_ended == ended, True)
    assert_equal(hash(decoded_ended), hash(ended))
    assert_equal(VideoChatEnded.de_json(parse_json('{"duration":100}')).duration, TimeDelta(100))
    assert_equal(len(VideoChatEnded.de_list(parse_json("[{\"duration\":1}]"), 0)), 1)

    var users = List[User]()
    users.append(User(123, "Ada", False))
    users.append(User(124, "Grace", False))
    var invited = VideoChatParticipantsInvited(users)
    var invited_copy = VideoChatParticipantsInvited.de_json(parse_json(invited.to_json()))
    assert_equal(invited_copy == invited, True)
    assert_equal(hash(invited_copy), hash(invited))
    assert_equal(invited_copy.users[1].id, 124)
    assert_equal(VideoChatParticipantsInvited(List[User]()).to_json(), "{}")
    assert_equal(len(VideoChatParticipantsInvited.de_list(parse_json("[{}]"), 0)), 1)

    var start_date = TimestampDateTime(2026, 10, 2, 9, 15, 0)
    var scheduled = VideoChatScheduled(start_date)
    var decoded_scheduled = VideoChatScheduled.de_json(parse_json(scheduled.to_json()))
    assert_equal(decoded_scheduled == scheduled, True)
    assert_equal(hash(decoded_scheduled), hash(scheduled))
    assert_equal(to_timestamp(decoded_scheduled.start_date), to_timestamp(start_date))
    assert_equal(len(VideoChatScheduled.de_list(parse_json("[" + scheduled.to_json() + "]"), 0)), 1)

    with assert_raises():
        _ = VideoChatEnded.de_json(parse_json("{}"))
    with assert_raises():
        _ = VideoChatScheduled.de_json(parse_json("{}"))
