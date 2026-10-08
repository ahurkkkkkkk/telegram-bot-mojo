from std.testing import assert_equal, assert_raises

from telegram import ManagedBotCreated, ManagedBotUpdated
from telegram._utils.json import parse_json


def main() raises:
    var created = ManagedBotCreated.de_json(
        parse_json('{"bot":{"id":7,"first_name":"Helper","is_bot":true},"future":9}')
    )
    assert_equal(created.bot.id, 7)
    assert_equal(
        created.to_json(),
        '{"bot": {"id": 7, "first_name": "Helper", "is_bot": true}, "future": 9}',
    )
    assert_equal(created == ManagedBotCreated.de_json(
        parse_json('{"bot":{"id":7,"first_name":"Changed","is_bot":false}}')
    ), True)
    assert_equal(len(ManagedBotCreated.de_list(
        parse_json('[{"bot":{"id":8,"first_name":"Bot","is_bot":true}}]'), 0
    )), 1)

    var updated = ManagedBotUpdated.de_json(
        parse_json(
            '{"user":{"id":1,"first_name":"Owner","is_bot":false},"bot":{"id":2,"first_name":"Managed","is_bot":true},"future":{"enabled":true}}'
        )
    )
    assert_equal(updated.user.id, 1)
    assert_equal(updated.bot.id, 2)
    assert_equal(
        updated.to_json(),
        '{"bot": {"id": 2, "first_name": "Managed", "is_bot": true}, "user": {"id": 1, "first_name": "Owner", "is_bot": false}, "future": {"enabled": true}}',
    )
    assert_equal(updated == ManagedBotUpdated.de_json(
        parse_json(
            '{"user":{"id":1,"first_name":"Other","is_bot":true},"bot":{"id":2,"first_name":"Other","is_bot":false}}'
        )
    ), True)
    with assert_raises():
        _ = ManagedBotUpdated.de_json(parse_json('{"bot": {"id": 2}}'))
