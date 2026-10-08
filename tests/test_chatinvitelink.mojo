from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import ChatInviteLink, User
from telegram._utils.datetime import TimeDelta, from_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var link = ChatInviteLink(
        "https://t.me/+invite",
        User(5, "Creator", False),
        False,
        True,
        False,
        expire_date=Optional(from_timestamp(1700000000)),
        member_limit=Optional[Int](42),
        name=Optional[String]("Launch"),
        pending_join_request_count=Optional[Int](3),
        subscription_period=Optional[TimeDelta](TimeDelta(43)),
        subscription_price=Optional[Int](9),
    )
    assert_equal(
        link.to_json(),
        '{"creates_join_request": false, "creator": {"id": 5, "first_name": "Creator", "is_bot": false}, "expire_date": 1700000000, "invite_link": "https://t.me/+invite", "is_primary": true, "is_revoked": false, "member_limit": 42, "name": "Launch", "pending_join_request_count": 3, "subscription_price": 9, "subscription_period": 43}',
    )
    var decoded = ChatInviteLink.de_json(
        parse_json(
            '{"invite_link":"abc","creator":{"id":5,"first_name":"Different","is_bot":true},"creates_join_request":false,"is_primary":true,"is_revoked":false,"expire_date":1700000000,"pending_join_request_count":"3","subscription_period":43.5,"future":true}'
        )
    )
    assert_equal(decoded.creator.id, 5)
    assert_equal(decoded.expire_date.value().year, 2023)
    assert_equal(decoded.pending_join_request_count.value(), 3)
    assert_equal(decoded.subscription_period.value().total_seconds(), 43.5)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    var same_identity = ChatInviteLink(
        "abc", User(5, "Other", True), False, True, False,
        name=Optional[String]("Changed"),
    )
    assert_equal(decoded == same_identity, True)
    assert_equal(hash(decoded), hash(same_identity))
    assert_equal(
        len(ChatInviteLink.de_list(parse_json(
            '[{"invite_link":"x","creator":{"id":1,"first_name":"u","is_bot":false},"creates_join_request":true,"is_primary":false,"is_revoked":false}]'
        ), 0)),
        1,
    )
    with assert_raises():
        _ = ChatInviteLink.de_json(parse_json('{"invite_link":"missing"}'))
