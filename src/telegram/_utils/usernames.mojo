#!/usr/bin/env mojo
#
# Native helper translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Helpers for Telegram first names, last names, and usernames."""

from std.collections.optional import Optional


def get_full_name(
    first_name: Optional[String], last_name: Optional[String]
) -> Optional[String]:
    """Return the non-empty first name, optionally followed by a last name."""
    if first_name is None or first_name.value().byte_length() == 0:
        return None
    if last_name is not None and last_name.value().byte_length() != 0:
        return Optional[String](String(first_name.value(), " ", last_name.value()))
    return first_name


def get_name(
    username: Optional[String],
    first_name: Optional[String],
    last_name: Optional[String],
) -> Optional[String]:
    """Return an @username when available, otherwise the person's full name."""
    if username is not None and username.value().byte_length() != 0:
        return Optional[String](String("@", username.value()))
    return get_full_name(first_name, last_name)


def get_link(username: Optional[String]) -> Optional[String]:
    """Return the public t.me URL for a non-empty username."""
    if username is not None and username.value().byte_length() != 0:
        return Optional[String](String("https://t.me/", username.value()))
    return None
