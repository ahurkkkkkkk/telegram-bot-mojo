from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import AffiliateInfo, Chat, User
from telegram._utils.json import parse_json


def main() raises:
    var info = AffiliateInfo(
        25,
        -8,
        affiliate_user=Optional[User](User(17, "Affiliate", False)),
        affiliate_chat=Optional[Chat](Chat(-100, "channel", title=Optional[String]("Channel"))),
        nanostar_amount=Optional[Int](300),
    )
    assert_equal(
        info.to_json(),
        '{"affiliate_chat": {"id": -100, "type": "channel", "title": "Channel"}, "affiliate_user": {"id": 17, "first_name": "Affiliate", "is_bot": false}, "amount": -8, "commission_per_mille": 25, "nanostar_amount": 300}',
    )
    var decoded = AffiliateInfo.de_json(
        parse_json(
            '{"commission_per_mille":25,"amount":-8,"affiliate_user":{"id":17,"first_name":"Other","is_bot":true},"affiliate_chat":{"id":-100,"type":"group"},"future":"x"}'
        )
    )
    assert_equal(decoded.affiliate_user.value().id, 17)
    assert_equal(decoded.affiliate_chat.value().id, -100)
    assert_equal(decoded.nanostar_amount is None, True)
    assert_equal(
        decoded.to_json(),
        '{"affiliate_chat": {"id": -100, "type": "group"}, "affiliate_user": {"id": 17, "first_name": "Other", "is_bot": true}, "amount": -8, "commission_per_mille": 25, "future": "x"}',
    )
    var same = AffiliateInfo(
        25,
        -8,
        affiliate_user=Optional[User](User(17, "Same ID", False)),
        affiliate_chat=Optional[Chat](Chat(-100, "channel")),
    )
    assert_equal(decoded == same, True)
    assert_equal(hash(decoded), hash(same))
    assert_equal(decoded == AffiliateInfo(25, -8), False)
    assert_equal(
        len(AffiliateInfo.de_list(parse_json('[{"commission_per_mille":1,"amount":2}]'), 0)),
        1,
    )
    with assert_raises():
        _ = AffiliateInfo.de_json(parse_json('{"commission_per_mille":1}'))
