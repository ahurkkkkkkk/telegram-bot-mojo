#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ext/_utils/_update_parsing.py.
# LGPL-3.0-or-later; see LICENSE.

"""Normalize scalar or list-based update filters into native sets."""

from std.collections import List
from std.collections.optional import Optional
from std.collections.set import Set


def parse_chat_id(chat_id: Int) -> Set[Int]:
    """Normalize a single chat identifier to a set."""
    var result = Set[Int]()
    _ = result.insert(chat_id)
    return result^


def parse_chat_id(chat_ids: List[Int]) -> Set[Int]:
    """Normalize a native list of chat identifiers to a de-duplicated set."""
    var result = Set[Int]()
    for chat_id in chat_ids:
        _ = result.insert(chat_id)
    return result^


def parse_chat_id(chat_ids: Set[Int]) -> Set[Int]:
    """Normalize a native set of chat identifiers into a fresh set."""
    var result = Set[Int]()
    for chat_id in chat_ids:
        _ = result.insert(chat_id)
    return result^


def parse_chat_id(chat_id: Optional[Int]) -> Set[Int]:
    """Normalize an optional chat identifier; unset maps to an empty set."""
    var result = Set[Int]()
    if chat_id is not None:
        _ = result.insert(chat_id.value())
    return result^


def parse_chat_id(chat_ids: Optional[List[Int]]) -> Set[Int]:
    """Normalize optional list input; unset maps to an empty set."""
    var result = Set[Int]()
    if chat_ids is not None:
        for chat_id in chat_ids.value():
            _ = result.insert(chat_id)
    return result^


def _remove_leading_at(username: String) -> String:
    var result = String()
    var is_first = True
    for character in username.codepoint_slices():
        if is_first and character == "@":
            is_first = False
            continue
        is_first = False
        result.write_string(character)
    return result


def parse_username(username: String) -> Set[String]:
    """Normalize a username, stripping one leading at-sign."""
    var result = Set[String]()
    _ = result.insert(_remove_leading_at(username))
    return result^


def parse_username(usernames: List[String]) -> Set[String]:
    """Normalize native list input and remove one leading at-sign per name."""
    var result = Set[String]()
    for username in usernames:
        _ = result.insert(_remove_leading_at(username))
    return result^


def parse_username(usernames: Set[String]) -> Set[String]:
    """Normalize native set input and strip one leading at-sign per name."""
    var result = Set[String]()
    for username in usernames:
        _ = result.insert(_remove_leading_at(username))
    return result^


def parse_username(username: Optional[String]) -> Set[String]:
    """Normalize an optional username; unset maps to an empty set."""
    var result = Set[String]()
    if username is not None:
        _ = result.insert(_remove_leading_at(username.value()))
    return result^


def parse_username(usernames: Optional[List[String]]) -> Set[String]:
    """Normalize optional native list input."""
    var result = Set[String]()
    if usernames is not None:
        for username in usernames.value():
            _ = result.insert(_remove_leading_at(username))
    return result^
