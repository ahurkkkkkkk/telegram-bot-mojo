from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import PaidMediaPurchasedHandler


def main() raises:
    var update = Update.de_json(parse_json(
        '{"update_id":4,"purchased_paid_media":{"from":{"id":8,'
        '"first_name":"Ada","is_bot":false,"username":"ada"},'
        '"paid_media_payload":"receipt-1"}}'
    ))
    var some_update = Optional[Update](update^)
    var no_update: Optional[Update] = None

    var handler = PaidMediaPurchasedHandler()
    assert_equal(handler.check_update(no_update), False)
    assert_equal(handler.check_update(some_update), True)

    var wrong_ids = Set[Int]()
    _ = wrong_ids.insert(9)
    var no_usernames = Set[String]()
    var no_match = PaidMediaPurchasedHandler(wrong_ids, no_usernames)
    assert_equal(no_match.check_update(some_update), False)

    var wrong_ids_but_matching_username = Set[Int]()
    _ = wrong_ids_but_matching_username.insert(9)
    var usernames = Set[String]()
    _ = usernames.insert("@ada")
    var username_match = PaidMediaPurchasedHandler(
        wrong_ids_but_matching_username, usernames, False
    )
    assert_equal(username_match.check_update(some_update), True)
    assert_equal(username_match.resolve_block(True), False)
