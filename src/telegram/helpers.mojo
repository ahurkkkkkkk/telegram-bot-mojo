#!/usr/bin/env mojo
#
# Native helper functions translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Convenience functions for Telegram links, mentions, and markup."""

from std.collections.optional import Optional

from telegram import constants


def _codepoint_length(value: String) -> Int:
    var result = 0
    for _ in value.codepoint_slices():
        result += 1
    return result


def escape_markdown(
    text: String,
    version: Int = 1,
    entity_type: Optional[String] = None,
) raises -> String:
    """Escape markup characters in Telegram Markdown version 1 or 2."""
    var escape_chars = String("_*`[")
    if version == 2:
        if entity_type is not None and (
            entity_type.value() == "pre" or entity_type.value() == "code"
        ):
            escape_chars = String("\\`")
        elif entity_type is not None and (
            entity_type.value() == "text_link" or entity_type.value() == "custom_emoji"
        ):
            escape_chars = String("\\)")
        else:
            escape_chars = String("\\_*[]()~`>#+-=|{}.! ")
    elif version != 1:
        raise Error("Markdown version must be either 1 or 2!")

    var result = String()
    for character in text.codepoint_slices():
        var should_escape = False
        for candidate in escape_chars.codepoint_slices():
            if character == candidate:
                should_escape = True
        if character == " ":
            should_escape = False
        if should_escape:
            result.write_string("\\")
        result.write_string(character)
    return result


def _escape_html(text: String) -> String:
    var result = String()
    for character in text.codepoint_slices():
        if character == "&":
            result.write_string("&amp;")
        elif character == "<":
            result.write_string("&lt;")
        elif character == ">":
            result.write_string("&gt;")
        elif character == "\"":
            result.write_string("&quot;")
        elif character == "'":
            result.write_string("&#x27;")
        else:
            result.write_string(character)
    return result


def mention_html(user_id: Int, name: String) -> String:
    return String('<a href="tg://user?id=', user_id, '">', _escape_html(name), "</a>")


def mention_html(user_id: String, name: String) -> String:
    return String('<a href="tg://user?id=', user_id, '">', _escape_html(name), "</a>")


def mention_markdown(user_id: Int, name: String, version: Int = 1) raises -> String:
    var link = String("tg://user?id=", user_id)
    if version == 1:
        return String("[", name, "](", link, ")")
    return String("[", escape_markdown(name, version), "](", link, ")")


def mention_markdown(user_id: String, name: String, version: Int = 1) raises -> String:
    var link = String("tg://user?id=", user_id)
    if version == 1:
        return String("[", name, "](", link, ")")
    return String("[", escape_markdown(name, version), "](", link, ")")


def create_deep_linked_url(
    bot_username: String,
    payload: Optional[String] = None,
    group: Bool = False,
) raises -> String:
    """Create a Telegram deep link after validating its username and payload."""
    if _codepoint_length(bot_username) <= 3:
        raise Error("You must provide a valid bot_username.")
    var base_url = String("https://t.me/", bot_username)
    if payload is None or _codepoint_length(payload.value()) == 0:
        return base_url
    var value = payload.value()
    if _codepoint_length(value) > constants.MessageLimit.DEEP_LINK_LENGTH.value:
        raise Error(
            String(
                "The deep-linking payload must not exceed ",
                constants.MessageLimit.DEEP_LINK_LENGTH.value,
                " characters.",
            )
        )
    for character in value.codepoint_slices():
        var valid =
            (character >= "A" and character <= "Z") or
            (character >= "a" and character <= "z") or
            (character >= "0" and character <= "9") or
            character == "_" or character == "-"
        if not valid:
            raise Error(
                "Only the following characters are allowed for deep-linked URLs: " +
                "A-Z, a-z, 0-9, _ and -"
            )
    var key = String("start")
    if group:
        key = String("startgroup")
    return String(base_url, "?", key, "=", value)
