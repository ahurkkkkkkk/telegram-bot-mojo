from std.collections import List
from std.collections.optional import Optional
from std.collections.set import Set
from std.testing import assert_equal

from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


def main() raises:
    var singleton = parse_chat_id(123)
    var found_123 = False
    for item in singleton:
        if item == 123:
            found_123 = True
    assert_equal(found_123, True)
    assert_equal(len(parse_chat_id(None)), 0)
    var chat_ids = List[Int]()
    chat_ids.append(2)
    chat_ids.append(2)
    chat_ids.append(-4)
    var parsed_ids = parse_chat_id(chat_ids)
    assert_equal(len(parsed_ids), 2)
    var found_negative = False
    for item in parsed_ids:
        if item == -4:
            found_negative = True
    assert_equal(found_negative, True)

    var chat_id_set = Set[Int]()
    _ = chat_id_set.insert(2)
    _ = chat_id_set.insert(-4)
    var parsed_chat_set = parse_chat_id(chat_id_set)
    assert_equal(len(parsed_chat_set), 2)

    var parsed_single = parse_username("@alice")
    var found_alice = False
    for item in parsed_single:
        if item == "alice":
            found_alice = True
    assert_equal(found_alice, True)
    var parsed_double = parse_username("@@alice")
    var found_at_alice = False
    for item in parsed_double:
        if item == "@alice":
            found_at_alice = True
    assert_equal(found_at_alice, True)
    var no_username: Optional[String] = None
    assert_equal(len(parse_username(no_username)), 0)
    var usernames = List[String]()
    usernames.append("@alice")
    usernames.append("alice")
    usernames.append("@bob")
    var parsed_usernames = parse_username(usernames)
    assert_equal(len(parsed_usernames), 2)
    var has_alice = False
    var has_bob = False
    for item in parsed_usernames:
        if item == "alice":
            has_alice = True
        elif item == "bob":
            has_bob = True
    assert_equal(has_alice, True)
    assert_equal(has_bob, True)

    var username_set = Set[String]()
    _ = username_set.insert("@alice")
    _ = username_set.insert("bob")
    var parsed_username_set = parse_username(username_set)
    var normalized_alice = False
    var normalized_bob = False
    for item in parsed_username_set:
        if item == "alice":
            normalized_alice = True
        elif item == "bob":
            normalized_bob = True
    assert_equal(normalized_alice, True)
    assert_equal(normalized_bob, True)
