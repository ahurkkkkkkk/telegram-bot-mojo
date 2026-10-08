#!/usr/bin/env mojo
#
# Native Mojo translation foundation for python-telegram-bot v22.8 ext/filters.py.
# LGPL-3.0-or-later; see LICENSE.

"""Composable native predicates for Telegram updates.

Mojo structs are statically dispatched, so the Python class hierarchy is expressed
as postfix filter programs. Native values cover core message, media, service,
chat-type, update-type, status-update, sticker, dice, document, mention, and
configured identity predicates without a Python runtime.
"""

from std.collections import List
from std.collections.optional import Optional

from telegram._dice import Dice as TelegramDice
from telegram._message import Message
from telegram._messageentity import MessageEntity
from telegram._update import Update
from telegram._user import User as TelegramUser
from telegram._utils.regex import regex_search
from telegram._utils.json import JSON_ARRAY, JSON_BOOL, JSON_NULL, JSON_NUMBER, JSON_OBJECT, JSON_STRING


def _api_value_truthy(message: Message, key: String) -> Bool:
    """Apply Python truthiness to a value retained in Message.api_kwargs."""
    var child = message.api_kwargs.nodes[message.api_kwargs.root].first_child
    while child != -1:
        if message.api_kwargs.nodes[child].name == key:
            var node = message.api_kwargs.nodes[child]
            if node.kind == JSON_NULL:
                return False
            if node.kind == JSON_BOOL:
                return node.boolean
            if node.kind == JSON_STRING:
                return node.text != ""
            if node.kind == JSON_ARRAY or node.kind == JSON_OBJECT:
                return node.first_child != -1
            if node.kind == JSON_NUMBER:
                # JSON numbers have already been syntax checked. A number is zero
                # exactly when every significand digit before the exponent is 0.
                var bytes = node.text.as_bytes()
                var position = 0
                while position < len(bytes):
                    var byte = bytes[position]
                    if byte == 0x65 or byte == 0x45:
                        break
                    if byte >= 0x31 and byte <= 0x39:
                        return True
                    position += 1
                return False
            return True
        child = message.api_kwargs.nodes[child].next_sibling
    return False


def _optional_bool(value: Optional[Bool]) -> Bool:
    return value is not None and value.value()


def _evaluate_update_leaf(token: String, update: Update) -> Bool:
    if token == "0":
        return update.channel_post is not None
    if token == "6":
        return update.channel_post is not None or update.edited_channel_post is not None
    if token == "7":
        return (
            update.edited_message is not None
            or update.edited_channel_post is not None
            or update.edited_business_message is not None
        )
    if token == "8":
        return update.edited_channel_post is not None
    if token == "9":
        return update.edited_message is not None
    if token == "a":
        return update.message is not None
    if token == "b":
        return update.message is not None or update.edited_message is not None
    if token == "c":
        return update.business_message is not None
    if token == "d":
        return update.edited_business_message is not None
    if token == "e":
        return update.business_message is not None or update.edited_business_message is not None
    if token == "f":
        return update.guest_message is not None
    if token == "s" or token == "u":
        try:
            var chat = update.effective_chat()
            if chat is None:
                return False
            if token == "s":
                return chat.value().is_direct_messages is not None and chat.value().is_direct_messages.value()
            return chat.value().is_forum is not None and chat.value().is_forum.value()
        except:
            return False
    if token == "[" or token == "]":
        try:
            var user = update.effective_user()
            if user is None:
                return False
            if token == "[":
                return _optional_bool(user.value().added_to_attachment_menu)
            return _optional_bool(user.value().is_premium)
        except:
            return False
    return False


def _evaluate_parameter_leaf(token: String, message: Message, expected: String) raises -> Bool:
    if token == "R":
        return (
            message.text is not None
            and message.text.value() != ""
            and regex_search(expected, message.text.value())
        )
    if token == "Q":
        return (
            message.caption is not None
            and message.caption.value() != ""
            and regex_search(expected, message.caption.value())
        )
    if token == "T":
        return message.text is not None and message.text.value() != "" and message.text.value() == expected
    if token == "C":
        return message.caption is not None and message.caption.value() != "" and message.caption.value() == expected
    if token == "P":
        return (
            message.successful_payment is not None
            and message.successful_payment.value().invoice_payload == expected
        )
    if token == "D":
        return (
            message.document is not None
            and message.document.value().mime_type is not None
            and _string_starts_with(message.document.value().mime_type.value(), expected)
        )
    if token == "M":
        return (
            message.document is not None
            and message.document.value().mime_type is not None
            and message.document.value().mime_type.value() == expected
        )
    if token == "x":
        return (
            message.document is not None
            and message.document.value().file_name is not None
            and _string_ends_with(message.document.value().file_name.value(), expected)
        )
    if token == "X":
        return (
            message.document is not None
            and message.document.value().file_name is not None
            and _string_ends_with(
                _ascii_lowercase(message.document.value().file_name.value()), expected
            )
        )
    if token == "n":
        if message.document is None or message.document.value().file_name is None:
            return False
        for byte in message.document.value().file_name.value().as_bytes():
            if byte == 0x2e:
                return False
        return True
    if token == "E":
        for entity in message.entities:
            if entity.type == expected:
                return True
        return False
    if token == "e":
        for entity in message.caption_entities:
            if entity.type == expected:
                return True
        return False
    if token == "L":
        if (
            message.from_user is None
            or message.from_user.value().language_code is None
            or message.from_user.value().language_code.value() == ""
        ):
            return False
        return _string_starts_with(message.from_user.value().language_code.value(), expected)
    if token == "d":
        return message.dice is not None and String(message.dice.value().value) == expected
    if token == "o":
        return message.dice is not None and message.dice.value().emoji == expected
    if token == "c":
        return String(message.chat.id) == expected
    if token == "h":
        return (
            message.chat.username is not None
            and message.chat.username.value() != ""
            and _normalized_username(message.chat.username.value()) == expected
        )
    if token == "i":
        return message.from_user is not None and String(message.from_user.value().id) == expected
    if token == "j":
        return (
            message.from_user is not None
            and message.from_user.value().username is not None
            and message.from_user.value().username.value() != ""
            and _normalized_username(message.from_user.value().username.value()) == expected
        )
    if token == "b":
        return message.via_bot is not None and String(message.via_bot.value().id) == expected
    if token == "B":
        return (
            message.via_bot is not None
            and message.via_bot.value().username is not None
            and message.via_bot.value().username.value() != ""
            and _normalized_username(message.via_bot.value().username.value()) == expected
        )
    if token == "s":
        return message.sender_chat is not None and String(message.sender_chat.value().id) == expected
    if token == "S":
        return (
            message.sender_chat is not None
            and message.sender_chat.value().username is not None
            and message.sender_chat.value().username.value() != ""
            and _normalized_username(message.sender_chat.value().username.value()) == expected
        )
    if token == "f":
        return _forwarded_identity_matches(message, expected, False)
    if token == "F":
        return _forwarded_identity_matches(message, expected, True)
    if token == "k":
        return expected == "1"
    if token == "q":
        return expected == "1" and message.from_user is not None
    if token == "t":
        return expected == "1" and message.via_bot is not None
    if token == "y":
        return expected == "1" and message.sender_chat is not None
    if token == "z":
        return expected == "1" and _forwarded_identity_present(message)
    if token == "m":
        for entity in message.entities:
            if entity.type != MessageEntity.MENTION and entity.type != MessageEntity.TEXT_MENTION:
                continue
            if message.text is None:
                continue
            var extracted = _mention_entity_text(message.text.value(), entity)
            if extracted[1] and _normalize_mention_text(extracted[0]) == expected:
                return True
        return False
    if token == "u":
        for entity in message.entities:
            if entity.type == MessageEntity.TEXT_MENTION and entity.user is not None:
                if String(entity.user.value().id) == expected:
                    return True
        return False
    if token == "v":
        for entity in message.entities:
            if entity.type == MessageEntity.TEXT_MENTION and entity.user is not None:
                if (
                    entity.user.value().username is not None
                    and _normalized_username(entity.user.value().username.value()) == expected
                ):
                    return True
        return False
    return False


def _normalized_username(value: String) -> String:
    if value.byte_length() > 0 and value.as_bytes()[0] == 0x40:
        var bytes = List[UInt8]()
        for index in range(1, value.byte_length()):
            bytes.append(value.as_bytes()[index])
        return String(from_utf8_lossy=Span(bytes))
    return value


def _normalize_mention_text(value: String) -> String:
    var bytes = List[UInt8]()
    var position = 0
    while position < value.byte_length() and value.as_bytes()[position] == 0x40:
        position += 1
    while position < value.byte_length():
        bytes.append(value.as_bytes()[position])
        position += 1
    return String(from_utf8_lossy=Span(bytes))


def _mention_entity_text(text: String, entity: MessageEntity) -> Tuple[String, Bool]:
    var total_units = 0
    for character in text.codepoint_slices():
        if ord(character) > 0xFFFF:
            total_units += 2
        else:
            total_units += 1
    var start = entity.offset
    var end = entity.offset + entity.length
    if start < 0:
        start += total_units
    if end < 0:
        end += total_units
    if start < 0:
        start = 0
    elif start > total_units:
        start = total_units
    if end < 0:
        end = 0
    elif end > total_units:
        end = total_units
    if end <= start:
        return (String(), True)
    var result = String()
    var current_unit = 0
    for character in text.codepoint_slices():
        var width = 1
        if ord(character) > 0xFFFF:
            width = 2
        var next_unit = current_unit + width
        if current_unit < end and next_unit > start:
            if current_unit < start or next_unit > end:
                return (String(), False)
            result.write_string(character)
        current_unit = next_unit
    return (result, True)


def _forwarded_identity_matches(message: Message, expected: String, username: Bool) -> Bool:
    if message.forward_origin is None:
        return False
    var origin = message.forward_origin.value().copy()
    if origin.type == "user" and origin.sender_user is not None:
        var user = origin.sender_user.value().copy()
        if username:
            return (
                user.username is not None
                and user.username.value() != ""
                and _normalized_username(user.username.value()) == expected
            )
        return String(user.id) == expected
    if origin.type == "chat" and origin.sender_chat is not None:
        var chat = origin.sender_chat.value().copy()
        if username:
            return (
                chat.username is not None
                and chat.username.value() != ""
                and _normalized_username(chat.username.value()) == expected
            )
        return String(chat.id) == expected
    if origin.type == "channel" and origin.chat is not None:
        var chat = origin.chat.value().copy()
        if username:
            return (
                chat.username is not None
                and chat.username.value() != ""
                and _normalized_username(chat.username.value()) == expected
            )
        return String(chat.id) == expected
    return False


def _forwarded_identity_present(message: Message) -> Bool:
    if message.forward_origin is None:
        return False
    var origin = message.forward_origin.value().copy()
    return (
        (origin.type == "user" and origin.sender_user is not None)
        or (origin.type == "chat" and origin.sender_chat is not None)
        or (origin.type == "channel" and origin.chat is not None)
    )


def _string_starts_with(value: String, prefix: String) -> Bool:
    if prefix.byte_length() > value.byte_length():
        return False
    for index in range(prefix.byte_length()):
        if value.as_bytes()[index] != prefix.as_bytes()[index]:
            return False
    return True


def _string_ends_with(value: String, suffix: String) -> Bool:
    if suffix.byte_length() > value.byte_length():
        return False
    var start = value.byte_length() - suffix.byte_length()
    for index in range(suffix.byte_length()):
        if value.as_bytes()[start + index] != suffix.as_bytes()[index]:
            return False
    return True


def _ascii_lowercase(value: String) -> String:
    var bytes = List[UInt8]()
    for byte in value.as_bytes():
        if byte >= 0x41 and byte <= 0x5a:
            bytes.append(byte + 0x20)
        else:
            bytes.append(byte)
    return String(from_utf8_lossy=Span(bytes))


def _status_leaf(token: String, message: Message) -> Bool:
    """Evaluate one StatusUpdate predicate by its compact program opcode."""
    if token == "*":
        return (
            _status_leaf("A", message) or _status_leaf("B", message)
            or _status_leaf("C", message) or _status_leaf("D", message)
            or _status_leaf("E", message) or _status_leaf("F", message)
            or _status_leaf("G", message) or _status_leaf("H", message)
            or _status_leaf("I", message) or _status_leaf("J", message)
            or _status_leaf("K", message) or _status_leaf("L", message)
            or _status_leaf("M", message) or _status_leaf("N", message)
            or _status_leaf("O", message) or _status_leaf("P", message)
            or _status_leaf("Q", message) or _status_leaf("R", message)
            or _status_leaf("S", message) or _status_leaf("T", message)
            or _status_leaf("U", message) or _status_leaf("V", message)
            or _status_leaf("W", message) or _status_leaf("X", message)
            or _status_leaf("Y", message) or _status_leaf("Z", message)
            or _status_leaf("a", message) or _status_leaf("b", message)
            or _status_leaf("c", message) or _status_leaf("d", message)
            or _status_leaf("e", message) or _status_leaf("f", message)
            or _status_leaf("g", message) or _status_leaf("h", message)
            or _status_leaf("i", message) or _status_leaf("j", message)
            or _status_leaf("k", message) or _status_leaf("l", message)
            or _status_leaf("m", message) or _status_leaf("n", message)
            or _status_leaf("o", message) or _status_leaf("p", message)
            or _status_leaf("q", message) or _status_leaf("r", message)
            or _status_leaf("s", message) or _status_leaf("t", message)
        )
    if token == "A":
        return _api_value_truthy(message, "chat_background_set")
    if token == "B":
        return (
            _optional_bool(message.group_chat_created)
            or _optional_bool(message.supergroup_chat_created)
            or _optional_bool(message.channel_chat_created)
        )
    if token == "C":
        return message.chat_owner_changed is not None
    if token == "D":
        return message.chat_owner_left is not None
    if token == "E":
        return message.chat_shared is not None
    if token == "F":
        return _api_value_truthy(message, "checklist_tasks_added")
    if token == "G":
        return _api_value_truthy(message, "checklist_tasks_done")
    if token == "H":
        return message.connected_website is not None and message.connected_website.value() != ""
    if token == "I":
        return message.direct_message_price_changed is not None
    if token == "J":
        return _optional_bool(message.delete_chat_photo)
    if token == "K":
        return _api_value_truthy(message, "forum_topic_closed")
    if token == "L":
        return message.forum_topic_created is not None
    if token == "M":
        return message.forum_topic_edited is not None
    if token == "N":
        return _api_value_truthy(message, "forum_topic_reopened")
    if token == "O":
        return _api_value_truthy(message, "general_forum_topic_hidden")
    if token == "P":
        return _api_value_truthy(message, "general_forum_topic_unhidden")
    if token == "Q":
        return message.gift is not None
    if token == "R":
        return message.gift_upgrade_sent is not None
    if token == "S":
        return message.giveaway_completed is not None
    if token == "T":
        return message.giveaway_created is not None
    if token == "U":
        return message.left_chat_member is not None
    if token == "V":
        return message.managed_bot_created is not None
    if token == "W":
        return message.message_auto_delete_timer_changed is not None
    if token == "X":
        return (
            (message.migrate_from_chat_id is not None and message.migrate_from_chat_id.value() != 0)
            or (message.migrate_to_chat_id is not None and message.migrate_to_chat_id.value() != 0)
        )
    if token == "Y":
        return len(message.new_chat_members) > 0
    if token == "Z":
        return len(message.new_chat_photo) > 0
    if token == "a":
        return message.new_chat_title is not None and message.new_chat_title.value() != ""
    if token == "b":
        return message.paid_message_price_changed is not None
    if token == "c":
        return message.pinned_message is not None
    if token == "d":
        return message.poll_option_added is not None
    if token == "e":
        return message.poll_option_deleted is not None
    if token == "f":
        return message.proximity_alert_triggered is not None
    if token == "g":
        return message.refunded_payment is not None
    if token == "h":
        return _api_value_truthy(message, "suggested_post_approval_failed")
    if token == "i":
        return _api_value_truthy(message, "suggested_post_approved")
    if token == "j":
        return _api_value_truthy(message, "suggested_post_declined")
    if token == "k":
        return _api_value_truthy(message, "suggested_post_paid")
    if token == "l":
        return _api_value_truthy(message, "suggested_post_refunded")
    if token == "m":
        return message.unique_gift is not None
    if token == "n":
        return message.users_shared is not None
    if token == "o":
        return message.video_chat_ended is not None
    if token == "p":
        return message.video_chat_participants_invited is not None
    if token == "q":
        return message.video_chat_scheduled is not None
    if token == "r":
        return message.video_chat_started is not None
    if token == "s":
        return message.web_app_data is not None
    if token == "t":
        return message.write_access_allowed is not None
    return False


def _evaluate_leaf(token: String, message: Message, update: Update) -> Bool:
    # Common media and service-message predicates.
    if token == "A":
        return True
    if token == "B":
        return message.animation is not None
    if token == "C":
        return (
            message.animation is not None
            or message.audio is not None
            or message.contact is not None
            or message.dice is not None
            or message.document is not None
            or message.game is not None
            or message.invoice is not None
            or message.live_photo is not None
            or message.location is not None
            or message.paid_media is not None
            or len(message.photo) > 0
            or message.poll is not None
            or message.sticker is not None
            or message.story is not None
            or message.successful_payment is not None
            or message.video is not None
            or message.video_note is not None
            or message.voice is not None
            or message.venue is not None
            or _api_value_truthy(message, "passport_data")
        )
    if token == "D":
        return message.audio is not None
    if token == "E":
        return message.caption is not None and message.caption.value() != ""
    if token == "F":
        return message.checklist is not None
    if token == "G":
        if len(message.entities) == 0:
            return False
        return (
            message.entities[0].type == MessageEntity.BOT_COMMAND
            and message.entities[0].offset == 0
        )
    if token == "H":
        return message.contact is not None
    if token == "I":
        return message.dice is not None
    if token == "J":
        return message.document is not None
    if token == "K":
        return message.game is not None
    if token == "L":
        return message.invoice is not None
    if token == "M":
        return message.live_photo is not None
    if token == "N":
        return message.location is not None
    if token == "O":
        return message.paid_media is not None
    if token == "P":
        return len(message.photo) > 0
    if token == "Q":
        return message.poll is not None
    if token == "R":
        return message.sticker is not None
    if token == "S":
        return message.story is not None
    if token == "U":
        return message.successful_payment is not None
    if token == "T":
        return message.text is not None and message.text.value() != ""
    if token == "V":
        return message.venue is not None
    if token == "W":
        return message.video is not None
    if token == "X":
        return message.video_note is not None
    if token == "Y":
        return message.voice is not None

    # Chat-type predicates.
    if token == "1":
        return message.chat.type() == "channel"
    if token == "2":
        return message.chat.type() == "group"
    if token == "3":
        return message.chat.type() == "group" or message.chat.type() == "supergroup"
    if token == "4":
        return message.chat.type() == "private"
    if token == "5":
        return message.chat.type() == "supergroup"
    if token == "{":
        return message.sender_chat is not None
    if token == "}":
        return message.sender_chat is not None and message.sender_chat.value().type() == "channel"
    if token == "<":
        return message.sender_chat is not None and message.sender_chat.value().type() == "supergroup"

    # Update-type predicates. BaseFilter semantics still require an effective message.
    if token == "0":
        return update.channel_post is not None
    if token == "6":
        return update.channel_post is not None or update.edited_channel_post is not None
    if token == "7":
        return (
            update.edited_message is not None
            or update.edited_channel_post is not None
            or update.edited_business_message is not None
        )
    if token == "8":
        return update.edited_channel_post is not None
    if token == "9":
        return update.edited_message is not None
    if token == "a":
        return update.message is not None
    if token == "b":
        return update.message is not None or update.edited_message is not None
    if token == "c":
        return update.business_message is not None
    if token == "d":
        return update.edited_business_message is not None
    if token == "e":
        return update.business_message is not None or update.edited_business_message is not None
    if token == "f":
        return update.guest_message is not None
    # Sticker subtype and dice emoji filters.
    if token == "g":
        return message.sticker is not None
    if token == "h":
        return message.sticker is not None and message.sticker.value().is_animated
    if token == "i":
        return (
            message.sticker is not None
            and not message.sticker.value().is_animated
            and not message.sticker.value().is_video
        )
    if token == "j":
        return message.sticker is not None and message.sticker.value().is_video
    if token == "k":
        return message.sticker is not None and message.sticker.value().premium_animation is not None
    if token == "l":
        return message.dice is not None
    if token == "m":
        return message.dice is not None and message.dice.value().emoji == TelegramDice.BASKETBALL
    if token == "n":
        return message.dice is not None and message.dice.value().emoji == TelegramDice.BOWLING
    if token == "o":
        return message.dice is not None and message.dice.value().emoji == TelegramDice.DARTS
    if token == "p":
        return message.dice is not None and message.dice.value().emoji == TelegramDice.DICE
    if token == "q":
        return message.dice is not None and message.dice.value().emoji == TelegramDice.FOOTBALL
    if token == "r":
        return message.dice is not None and message.dice.value().emoji == TelegramDice.SLOT_MACHINE
    # Unparameterized top-level service and metadata filters.
    if token == "s":
        return message.chat.is_direct_messages is not None and message.chat.is_direct_messages.value()
    if token == "t":
        return message.effect_id is not None and message.effect_id.value() != ""
    if token == "u":
        return message.chat.is_forum is not None and message.chat.is_forum.value()
    if token == "v":
        return message.forward_origin is not None
    if token == "w":
        return message.giveaway is not None
    if token == "x":
        return message.giveaway_winners is not None
    if token == "y":
        return _optional_bool(message.has_media_spoiler)
    if token == "z":
        return _optional_bool(message.has_protected_content)
    if token == "#":
        return _optional_bool(message.is_automatic_forward)
    if token == "$":
        return _optional_bool(message.is_topic_message)
    if token == "%":
        return _optional_bool(message.is_from_offline)
    if token == "+":
        return _api_value_truthy(message, "passport_data")
    if token == ",":
        return message.reply_to_message is not None
    if token == "-":
        return _api_value_truthy(message, "suggested_post_info")
    if token == ".":
        return message.via_bot is not None
    if token == "/":
        return message.reply_to_story is not None
    if token == ";":
        return message.boost_added is not None
    if token == "<":
        return message.sender_boost_count is not None and message.sender_boost_count.value() != 0
    if token == "=":
        return message.from_user is not None
    if token == "[":
        return (
            message.from_user is not None
            and _optional_bool(message.from_user.value().added_to_attachment_menu)
        )
    if token == "]":
        return message.from_user is not None and _optional_bool(message.from_user.value().is_premium)
    if token == ">":
        for entity in message.entities:
            if entity.type == MessageEntity.BOT_COMMAND:
                return True
    return False




struct BaseFilter(ImplicitlyCopyable):
    """A copyable predicate program evaluated against a Telegram update.

    Filter values compose with ``&``, ``|``, ``^`` and ``~``. Evaluation uses
    postfix instructions, allowing expressions to remain ordinary native Mojo
    values without dynamic dispatch or a Python object hierarchy.
    """

    var program: String
    var name: String
    var data_filter: Bool
    var parameters: String
    var requires_message: Bool
    var identity_kind: String
    var identity_ids: String
    var identity_usernames: String
    var identity_allow_empty: Bool

    def __init__(
        out self,
        program: String,
        name: String,
        data_filter: Bool,
        parameters: String = String(),
        requires_message: Bool = True,
        identity_kind: String = String(),
        identity_ids: String = String(),
        identity_usernames: String = String(),
        identity_allow_empty: Bool = False,
    ):
        self.program = program.copy()
        self.name = name.copy()
        self.data_filter = data_filter
        self.parameters = parameters.copy()
        self.requires_message = requires_message
        self.identity_kind = identity_kind.copy()
        self.identity_ids = identity_ids.copy()
        self.identity_usernames = identity_usernames.copy()
        self.identity_allow_empty = identity_allow_empty

    def __and__(self, other: Self) -> Self:
        return Self(
            self.program + other.program + "&",
            "<" + self.name + " and " + other.name + ">",
            self.data_filter or other.data_filter,
            self.parameters + other.parameters,
            self.requires_message or other.requires_message,
        )

    def __or__(self, other: Self) -> Self:
        return Self(
            self.program + other.program + "|",
            "<" + self.name + " or " + other.name + ">",
            self.data_filter or other.data_filter,
            self.parameters + other.parameters,
            self.requires_message or other.requires_message,
        )

    def __xor__(self, other: Self) -> Self:
        return Self(
            self.program + other.program + "^",
            "<" + self.name + " xor " + other.name + ">",
            self.data_filter or other.data_filter,
            self.parameters + other.parameters,
            self.requires_message or other.requires_message,
        )

    def __invert__(self) -> Self:
        return Self(
            self.program + "!",
            "<inverted " + self.name + ">",
            self.data_filter,
            self.parameters,
            self.requires_message,
        )

    def __repr__(self) -> String:
        return self.name

    def filter(self, message: Message) raises -> Bool:
        """Evaluate a message filter directly against a supplied message."""
        var update = Update(update_id=0)
        return self._evaluate_program(message, update)

    def filter(self, update: Update) raises -> Bool:
        """Evaluate an update filter directly against a supplied update."""
        return self.check_update(update)

    def check_update(self, update: Update) raises -> Bool:
        """Return whether an update passes this expression.

        As in upstream ``BaseFilter``, only updates with an effective message
        are offered to filters. Message predicates inspect that effective
        message; update-type predicates inspect the corresponding update field.
        """
        if not (
            update.channel_post is not None
            or update.message is not None
            or update.edited_channel_post is not None
            or update.edited_message is not None
            or update.business_message is not None
            or update.edited_business_message is not None
            or update.guest_message is not None
        ):
            return False
        if not self.requires_message:
            return self._evaluate_update_program(update)
        if update.message is not None:
            return self._evaluate_program(update.message.value(), update)
        if update.edited_message is not None:
            return self._evaluate_program(update.edited_message.value(), update)
        if update.callback_query is not None:
            if update.callback_query.value().message is not None:
                if update.callback_query.value().message.value().accessible_message is not None:
                    return self._evaluate_program(
                        update.callback_query.value().message.value().accessible_message.value(),
                        update,
                    )
        if update.channel_post is not None:
            return self._evaluate_program(update.channel_post.value(), update)
        if update.edited_channel_post is not None:
            return self._evaluate_program(update.edited_channel_post.value(), update)
        if update.business_message is not None:
            return self._evaluate_program(update.business_message.value(), update)
        if update.edited_business_message is not None:
            return self._evaluate_program(update.edited_business_message.value(), update)
        if update.guest_message is not None:
            return self._evaluate_program(update.guest_message.value(), update)
        return False

    def _evaluate_update_program(self, update: Update) -> Bool:
        var values = List[Bool]()
        for token in self.program.codepoint_slices():
            if token == "&":
                if len(values) < 2:
                    return False
                var right = values.pop()
                var left = values.pop()
                values.append(left and right)
            elif token == "|":
                if len(values) < 2:
                    return False
                var right = values.pop()
                var left = values.pop()
                values.append(left or right)
            elif token == "^":
                if len(values) < 2:
                    return False
                var right = values.pop()
                var left = values.pop()
                values.append((left and not right) or (not left and right))
            elif token == "!":
                if len(values) < 1:
                    return False
                values.append(not values.pop())
            else:
                values.append(_evaluate_update_leaf(String(token), update))
        if len(values) != 1:
            return False
        return values[0]

    def add_chat_ids(mut self, chat_id: Int) raises:
        self._require_chat_id_filter()
        self._change_identity_ids(_encode_parameter(String(chat_id)), False)

    def add_chat_ids(mut self, chat_ids: List[Int]) raises:
        self._require_chat_id_filter()
        self._change_identity_ids(_encode_integer_parameters(chat_ids), False)

    def remove_chat_ids(mut self, chat_id: Int) raises:
        self._require_chat_id_filter()
        self._change_identity_ids(_encode_parameter(String(chat_id)), True)

    def remove_chat_ids(mut self, chat_ids: List[Int]) raises:
        self._require_chat_id_filter()
        self._change_identity_ids(_encode_integer_parameters(chat_ids), True)

    def add_user_ids(mut self, user_id: Int) raises:
        self._require_identity_kind("User")
        self._change_identity_ids(_encode_parameter(String(user_id)), False)

    def add_user_ids(mut self, user_ids: List[Int]) raises:
        self._require_identity_kind("User")
        self._change_identity_ids(_encode_integer_parameters(user_ids), False)

    def remove_user_ids(mut self, user_id: Int) raises:
        self._require_identity_kind("User")
        self._change_identity_ids(_encode_parameter(String(user_id)), True)

    def remove_user_ids(mut self, user_ids: List[Int]) raises:
        self._require_identity_kind("User")
        self._change_identity_ids(_encode_integer_parameters(user_ids), True)

    def add_bot_ids(mut self, bot_id: Int) raises:
        self._require_identity_kind("ViaBot")
        self._change_identity_ids(_encode_parameter(String(bot_id)), False)

    def add_bot_ids(mut self, bot_ids: List[Int]) raises:
        self._require_identity_kind("ViaBot")
        self._change_identity_ids(_encode_integer_parameters(bot_ids), False)

    def remove_bot_ids(mut self, bot_id: Int) raises:
        self._require_identity_kind("ViaBot")
        self._change_identity_ids(_encode_parameter(String(bot_id)), True)

    def remove_bot_ids(mut self, bot_ids: List[Int]) raises:
        self._require_identity_kind("ViaBot")
        self._change_identity_ids(_encode_integer_parameters(bot_ids), True)

    def add_usernames(mut self, username: String) raises:
        self._change_identity_usernames(_encode_parameter(_normalized_username(username)), False)

    def add_usernames(mut self, usernames: List[String]) raises:
        self._change_identity_usernames(_encode_username_parameters(usernames), False)

    def remove_usernames(mut self, username: String) raises:
        self._change_identity_usernames(_encode_parameter(_normalized_username(username)), True)

    def remove_usernames(mut self, usernames: List[String]) raises:
        self._change_identity_usernames(_encode_username_parameters(usernames), True)

    def chat_ids(self) raises -> List[Int]:
        self._require_chat_id_filter()
        return _decode_integer_parameters(self.identity_ids)

    def user_ids(self) raises -> List[Int]:
        self._require_identity_kind("User")
        return _decode_integer_parameters(self.identity_ids)

    def bot_ids(self) raises -> List[Int]:
        self._require_identity_kind("ViaBot")
        return _decode_integer_parameters(self.identity_ids)

    def usernames(self) raises -> List[String]:
        if (
            self.identity_kind != "Chat"
            and self.identity_kind != "User"
            and self.identity_kind != "ViaBot"
            and self.identity_kind != "SenderChat"
            and self.identity_kind != "ForwardedFrom"
        ):
            raise Error("Username access called on a different filter type")
        return _decode_parameter_values(self.identity_usernames)

    def set_chat_ids(mut self, chat_ids: List[Int]) raises:
        self._require_chat_id_filter()
        self._replace_identity_ids(_encode_integer_parameters(chat_ids))

    def set_chat_ids(mut self, chat_id: Int) raises:
        self._require_chat_id_filter()
        self._replace_identity_ids(_encode_parameter(String(chat_id)))

    def set_user_ids(mut self, user_ids: List[Int]) raises:
        self._require_identity_kind("User")
        self._replace_identity_ids(_encode_integer_parameters(user_ids))

    def set_user_ids(mut self, user_id: Int) raises:
        self._require_identity_kind("User")
        self._replace_identity_ids(_encode_parameter(String(user_id)))

    def set_bot_ids(mut self, bot_ids: List[Int]) raises:
        self._require_identity_kind("ViaBot")
        self._replace_identity_ids(_encode_integer_parameters(bot_ids))

    def set_bot_ids(mut self, bot_id: Int) raises:
        self._require_identity_kind("ViaBot")
        self._replace_identity_ids(_encode_parameter(String(bot_id)))

    def set_usernames(mut self, usernames: List[String]) raises:
        if (
            self.identity_kind != "Chat"
            and self.identity_kind != "User"
            and self.identity_kind != "ViaBot"
            and self.identity_kind != "SenderChat"
            and self.identity_kind != "ForwardedFrom"
        ):
            raise Error("Username replacement called on a different filter type")
        var normalized_usernames = _deduplicate_usernames(usernames)
        if len(normalized_usernames) > 0 and self.identity_ids.byte_length() > 0:
            raise Error("Can't set usernames in conjunction with already-set chat IDs")
        self.identity_usernames = _encode_username_parameters(normalized_usernames)
        self._rebuild_identity_filter()

    def set_usernames(mut self, username: String) raises:
        var values = List[String]()
        values.append(username)
        self.set_usernames(values^)

    def set_allow_empty(mut self, allow_empty: Bool) raises:
        if self.identity_kind == "":
            raise Error("allow_empty can only be set on an identity filter")
        self.identity_allow_empty = allow_empty
        self._rebuild_identity_filter()

    def _replace_identity_ids(mut self, incoming: String) raises:
        var values = _deduplicate_values(_decode_parameter_values(incoming))
        if len(values) > 0 and self.identity_usernames.byte_length() > 0:
            raise Error("Can't set IDs in conjunction with already-set usernames")
        self.identity_ids = _encode_string_parameters(values)
        self._rebuild_identity_filter()

    def _change_identity_ids(mut self, incoming: String, remove: Bool) raises:
        if self.identity_usernames.byte_length() > 0:
            raise Error("Can't set chat IDs in conjunction with already-set usernames")
        var existing = _decode_parameter_values(self.identity_ids)
        var changes = _decode_parameter_values(incoming)
        var result = List[String]()
        if remove:
            for value in existing:
                if not _string_list_contains(changes, value):
                    result.append(value)
        else:
            for value in existing:
                result.append(value)
            for value in changes:
                if not _string_list_contains(result, value):
                    result.append(value)
        self.identity_ids = _encode_string_parameters(result)
        self._rebuild_identity_filter()

    def _change_identity_usernames(mut self, incoming: String, remove: Bool) raises:
        if (
            self.identity_kind != "Chat"
            and self.identity_kind != "User"
            and self.identity_kind != "ViaBot"
            and self.identity_kind != "SenderChat"
            and self.identity_kind != "ForwardedFrom"
        ):
            raise Error("Username mutation called on a different filter type")
        if self.identity_ids.byte_length() > 0:
            raise Error("Can't set usernames in conjunction with already-set chat IDs")
        var existing = _decode_parameter_values(self.identity_usernames)
        var changes = _decode_parameter_values(incoming)
        var result = List[String]()
        if remove:
            for value in existing:
                if not _string_list_contains(changes, value):
                    result.append(value)
        else:
            for value in existing:
                result.append(value)
            for value in changes:
                var normalized = _normalized_username(value)
                if not _string_list_contains(result, normalized):
                    result.append(normalized)
        self.identity_usernames = _encode_string_parameters(result)
        self._rebuild_identity_filter()

    def _require_identity_kind(self, expected_kind: String) raises:
        if self.identity_kind != expected_kind:
            raise Error("Identity mutation called on a different filter type")

    def _require_chat_id_filter(self) raises:
        if (
            self.identity_kind != "Chat"
            and self.identity_kind != "SenderChat"
            and self.identity_kind != "ForwardedFrom"
        ):
            raise Error("Chat ID mutation called on a different filter type")

    def _rebuild_identity_filter(mut self) raises:
        var id_opcode: String
        var username_opcode: String
        var empty_opcode: String
        if self.identity_kind == "Chat":
            id_opcode = "c"
            username_opcode = "h"
            empty_opcode = "k"
        elif self.identity_kind == "User":
            id_opcode = "i"
            username_opcode = "j"
            empty_opcode = "q"
        elif self.identity_kind == "ViaBot":
            id_opcode = "b"
            username_opcode = "B"
            empty_opcode = "t"
        elif self.identity_kind == "SenderChat":
            id_opcode = "s"
            username_opcode = "S"
            empty_opcode = "y"
        else:
            id_opcode = "f"
            username_opcode = "F"
            empty_opcode = "z"

        var program = String()
        var parameters = String()
        var filter_name = "filters." + self.identity_kind + "("
        var count = 0
        var offset = 0
        while offset < self.identity_ids.byte_length():
            var decoded = _decode_parameter(self.identity_ids, offset)
            if not decoded[2]:
                raise Error("Invalid stored identity ID parameter")
            if count > 0:
                filter_name += ", "
            filter_name += decoded[0]
            program += "@" + id_opcode
            parameters += _encode_parameter(decoded[0])
            if count > 0:
                program += "|"
            count += 1
            offset = decoded[1]

        if count == 0:
            offset = 0
            while offset < self.identity_usernames.byte_length():
                var decoded = _decode_parameter(self.identity_usernames, offset)
                if not decoded[2]:
                    raise Error("Invalid stored identity username parameter")
                if count > 0:
                    filter_name += ", "
                filter_name += decoded[0]
                program += "@" + username_opcode
                parameters += _encode_parameter(decoded[0])
                if count > 0:
                    program += "|"
                count += 1
                offset = decoded[1]

        if count == 0 and self.identity_allow_empty:
            program = "@" + empty_opcode
            parameters = _encode_parameter("1")
        elif count == 0:
            program = "?"
        filter_name += ")"
        self.program = program^
        self.parameters = parameters^
        self.name = filter_name^

    def _evaluate_program(self, message: Message, update: Update) raises -> Bool:
        var values = List[Bool]()
        var reading_status_opcode = False
        var reading_parameter_opcode = False
        var parameter_offset = 0
        for token in self.program.codepoint_slices():
            if reading_status_opcode:
                values.append(_status_leaf(String(token), message))
                reading_status_opcode = False
            elif reading_parameter_opcode:
                var decoded = _decode_parameter(self.parameters, parameter_offset)
                if not decoded[2]:
                    return False
                values.append(
                    _evaluate_parameter_leaf(
                        String(token), message, decoded[0]
                    )
                )
                parameter_offset = decoded[1]
                reading_parameter_opcode = False
            elif token == ":":
                reading_status_opcode = True
            elif token == "@":
                reading_parameter_opcode = True
            elif token == "&":
                if len(values) < 2:
                    return False
                var right = values.pop()
                var left = values.pop()
                values.append(left and right)
            elif token == "|":
                if len(values) < 2:
                    return False
                var right = values.pop()
                var left = values.pop()
                values.append(left or right)
            elif token == "^":
                if len(values) < 2:
                    return False
                var right = values.pop()
                var left = values.pop()
                values.append((left and not right) or (not left and right))
            elif token == "!":
                if len(values) < 1:
                    return False
                values.append(not values.pop())
            else:
                values.append(_evaluate_leaf(String(token), message, update))

        if reading_status_opcode or reading_parameter_opcode:
            return False
        if parameter_offset != self.parameters.byte_length():
            return False
        if len(values) != 1:
            return False
        return values[0]


def _encode_parameter(value: String) -> String:
    return String(value.byte_length()) + ":" + value


def _decode_parameter_values(encoded: String) raises -> List[String]:
    var result = List[String]()
    var offset = 0
    while offset < encoded.byte_length():
        var decoded = _decode_parameter(encoded, offset)
        if not decoded[2] or decoded[1] <= offset:
            raise Error("Invalid length-prefixed filter parameter")
        result.append(decoded[0])
        offset = decoded[1]
    return result^


def _encode_string_parameters(values: List[String]) -> String:
    var result = String()
    for value in values:
        result += _encode_parameter(value)
    return result^


def _encode_integer_parameters(values: List[Int]) -> String:
    var result = String()
    for value in values:
        result += _encode_parameter(String(value))
    return result^


def _encode_username_parameters(values: List[String]) -> String:
    var result = String()
    for value in values:
        result += _encode_parameter(_normalized_username(value))
    return result^


def _decode_integer_parameters(encoded: String) raises -> List[Int]:
    var result = List[Int]()
    for value in _decode_parameter_values(encoded):
        result.append(_parse_identity_int(value))
    return result^


def _deduplicate_values(values: List[String]) -> List[String]:
    var result = List[String]()
    for value in values:
        if not _string_list_contains(result, value):
            result.append(value)
    return result^


def _deduplicate_usernames(values: List[String]) -> List[String]:
    var result = List[String]()
    for value in values:
        var normalized = _normalized_username(value)
        if not _string_list_contains(result, normalized):
            result.append(normalized)
    return result^


def _string_list_contains(values: List[String], expected: String) -> Bool:
    for value in values:
        if value == expected:
            return True
    return False


def _parse_identity_int(value: String) raises -> Int:
    var bytes = value.as_bytes()
    if len(bytes) == 0:
        raise Error("Empty identity ID")
    var negative = False
    var offset = 0
    if bytes[0] == 0x2d:
        negative = True
        offset = 1
    if offset == len(bytes):
        raise Error("Invalid identity ID")
    var result = 0
    while offset < len(bytes):
        var byte = bytes[offset]
        if byte < 0x30 or byte > 0x39:
            raise Error("Invalid identity ID")
        result = result * 10 + Int(byte - 0x30)
        offset += 1
    if negative:
        return -result
    return result


def _decode_parameter(encoded: String, offset: Int) -> Tuple[String, Int, Bool]:
    if offset < 0 or offset >= encoded.byte_length():
        return (String(), offset, False)
    var bytes = encoded.as_bytes()
    var position = offset
    var byte_length = 0
    var found_separator = False
    while position < encoded.byte_length():
        var byte = bytes[position]
        if byte == 0x3a:
            found_separator = True
            position += 1
            break
        if byte < 0x30 or byte > 0x39:
            return (String(), offset, False)
        byte_length = byte_length * 10 + Int(byte - 0x30)
        position += 1
    if not found_separator or position + byte_length > encoded.byte_length():
        return (String(), offset, False)
    var parameter_bytes = List[UInt8]()
    for index in range(position, position + byte_length):
        parameter_bytes.append(bytes[index])
    return (String(from_utf8_lossy=Span(parameter_bytes)), position + byte_length, True)


def _python_repr_string(value: String) -> String:
    var delimiter = "'"
    var has_single_quote = False
    var has_double_quote = False
    for character in value.codepoint_slices():
        if character == "'":
            has_single_quote = True
        elif character == "\"":
            has_double_quote = True
    if has_single_quote and not has_double_quote:
        delimiter = "\""

    var result = delimiter.copy()
    for character in value.codepoint_slices():
        if character == delimiter or character == "\\":
            result += "\\"
            result += String(character)
        elif character == "\n":
            result += "\\n"
        elif character == "\r":
            result += "\\r"
        elif character == "\t":
            result += "\\t"
        else:
            result += String(character)
    result += delimiter
    return result^


def _python_repr_string_list(values: List[String]) -> String:
    var result = "["
    for index in range(len(values)):
        if index > 0:
            result += ", "
        result += _python_repr_string(values[index])
    result += "]"
    return result^


def _exact_value_filter(
    opcode: String,
    type_name: String,
    empty_name: String,
    values: List[String],
) -> BaseFilter:
    if len(values) == 0:
        return BaseFilter("?", empty_name, False)
    var program = String()
    var parameters = String()
    var parameter_count = 0
    for value in values:
        program += "@" + opcode
        parameters += _encode_parameter(value)
        parameter_count += 1
    var operator_count = 1
    while operator_count < parameter_count:
        program += "|"
        operator_count += 1
    return BaseFilter(
        program,
        type_name + "(" + _python_repr_string_list(values) + ")",
        False,
        parameters^,
    )


def _single_parameter_filter(opcode: String, name: String, value: String) -> BaseFilter:
    return BaseFilter("@" + opcode, name, False, _encode_parameter(value))


def _regex_parameter_filter(opcode: String, name: String, pattern: String) raises -> BaseFilter:
    # Upstream compiles string patterns in the constructor; validate at creation time.
    _ = regex_search(pattern, "")
    return BaseFilter("@" + opcode, name, True, _encode_parameter(pattern))


def Regex(pattern: String) raises -> BaseFilter:
    """Search message text using a PCRE2 Unicode regex predicate."""
    return _regex_parameter_filter(
        "R", "filters.Regex(" + _python_repr_string(pattern) + ")", pattern
    )


def CaptionRegex(pattern: String) raises -> BaseFilter:
    """Search message captions using a PCRE2 Unicode regex predicate."""
    return _regex_parameter_filter(
        "Q", "filters.CaptionRegex(" + _python_repr_string(pattern) + ")", pattern
    )


def _python_repr_int_list(values: List[Int]) -> String:
    var result = "["
    for index in range(len(values)):
        if index > 0:
            result += ", "
        result += String(values[index])
    result += "]"
    return result^


def _dice_config_filter(name: String, emoji: String, values: List[Int]) -> BaseFilter:
    if len(values) == 0:
        if emoji == TelegramDice.BASKETBALL:
            return DICE_BASKETBALL
        if emoji == TelegramDice.BOWLING:
            return DICE_BOWLING
        if emoji == TelegramDice.DARTS:
            return DICE_DARTS
        if emoji == TelegramDice.DICE:
            return DICE_DICE
        if emoji == TelegramDice.FOOTBALL:
            return DICE_FOOTBALL
        if emoji == TelegramDice.SLOT_MACHINE:
            return DICE_SLOT_MACHINE
        return DICE_ALL

    var program = String()
    var parameters = String()
    for index in range(len(values)):
        if emoji != "":
            program += "@o"
            parameters += _encode_parameter(emoji)
        program += "@d"
        parameters += _encode_parameter(String(values[index]))
        if emoji != "":
            program += "&"
        if index > 0:
            program += "|"

    var filter_name = "filters.Dice"
    if name == "Dice.Dice":
        filter_name += ".Dice"
    elif name != "Dice":
        filter_name += "." + name
    filter_name += "(" + _python_repr_int_list(values) + ")"
    return BaseFilter(program, filter_name, False, parameters^)


def _identity_config_filter(
    type_name: String,
    id_values: List[Int],
    usernames: List[String],
    allow_empty: Bool = False,
) raises -> BaseFilter:
    if len(id_values) > 0 and len(usernames) > 0:
        raise Error("Configure either IDs or usernames for filters." + type_name + ", not both")

    var id_opcode: String
    var username_opcode: String
    var empty_opcode: String
    if type_name == "Chat":
        id_opcode = "c"
        username_opcode = "h"
        empty_opcode = "k"
    elif type_name == "User":
        id_opcode = "i"
        username_opcode = "j"
        empty_opcode = "q"
    elif type_name == "ViaBot":
        id_opcode = "b"
        username_opcode = "B"
        empty_opcode = "t"
    elif type_name == "SenderChat":
        id_opcode = "s"
        username_opcode = "S"
        empty_opcode = "y"
    else:
        id_opcode = "f"
        username_opcode = "F"
        empty_opcode = "z"

    var filter_name = "filters." + type_name + "("
    var program = String()
    var parameters = String()
    var stored_ids = String()
    var stored_usernames = String()
    var entry_count = 0
    var seen_values = List[String]()
    if len(id_values) > 0:
        for value in id_values:
            var normalized = String(value)
            if _string_list_contains(seen_values, normalized):
                continue
            seen_values.append(normalized)
            if entry_count > 0:
                filter_name += ", "
            filter_name += normalized
            program += "@" + id_opcode
            parameters += _encode_parameter(normalized)
            stored_ids += _encode_parameter(normalized)
            if entry_count > 0:
                program += "|"
            entry_count += 1
    elif len(usernames) > 0:
        for value in usernames:
            var normalized = _normalized_username(value)
            if _string_list_contains(seen_values, normalized):
                continue
            seen_values.append(normalized)
            if entry_count > 0:
                filter_name += ", "
            filter_name += normalized
            program += "@" + username_opcode
            parameters += _encode_parameter(normalized)
            stored_usernames += _encode_parameter(normalized)
            if entry_count > 0:
                program += "|"
            entry_count += 1
    elif allow_empty:
        program = "@" + empty_opcode
        parameters = _encode_parameter("1")
    else:
        filter_name += ")"
        return BaseFilter(
            "?", filter_name, False, String(), True,
            type_name, stored_ids, stored_usernames, allow_empty,
        )

    filter_name += ")"
    return BaseFilter(
        program, filter_name, False, parameters,
        True, type_name, stored_ids, stored_usernames, allow_empty,
    )


def _identity_id_values(value: Int) -> List[Int]:
    var result = List[Int]()
    result.append(value)
    return result^


def _identity_username_values(value: String) -> List[String]:
    var result = List[String]()
    result.append(value)
    return result^


def _mention_config_filter(
    ids: List[Int],
    usernames: List[String],
    associated_usernames: List[String],
    filter_name: String,
) -> BaseFilter:
    var program = String()
    var parameters = String()
    var leaf_count = 0
    for value in ids:
        program += "@u"
        parameters += _encode_parameter(String(value))
        if leaf_count > 0:
            program += "|"
        leaf_count += 1
    for value in usernames:
        var normalized = _normalize_mention_text(value)
        program += "@m"
        parameters += _encode_parameter(normalized)
        if leaf_count > 0:
            program += "|"
        leaf_count += 1
    for value in associated_usernames:
        var normalized = _normalize_mention_text(value)
        program += "@v"
        parameters += _encode_parameter(normalized)
        if leaf_count > 0:
            program += "|"
        leaf_count += 1
        program += "@m"
        parameters += _encode_parameter(normalized)
        program += "|"
        leaf_count += 1
    if leaf_count == 0:
        return BaseFilter("?", filter_name, False)
    return BaseFilter(program, filter_name, False, parameters^)


def _mention_user_filter(user: TelegramUser) -> BaseFilter:
    var ids = List[Int]()
    var usernames = List[String]()
    ids.append(user.id)
    if user.username is not None:
        usernames.append(user.username.value().copy())
    return _mention_config_filter(
        ids, List[String](), usernames,
        "filters.Mention(" + String(user.id) + ")",
    )


# Mojo does not currently support struct inheritance. These compile-time aliases retain the
# upstream names for the statically represented message and update filter bases.
comptime MessageFilter = BaseFilter
comptime UpdateFilter = BaseFilter


# Public common message filters.
comptime ALL = BaseFilter("A", "filters.ALL", False)
comptime ANIMATION = BaseFilter("B", "filters.ANIMATION", False)
comptime ATTACHMENT = BaseFilter("C", "filters.ATTACHMENT", False)
comptime AUDIO = BaseFilter("D", "filters.AUDIO", False)
comptime CAPTION = BaseFilter("E", "filters.CAPTION", False)
comptime CHECKLIST = BaseFilter("F", "filters.CHECKLIST", False)
comptime COMMAND = BaseFilter("G", "filters.COMMAND", False)
comptime CONTACT = BaseFilter("H", "filters.CONTACT", False)
comptime DICE = BaseFilter("I", "filters.DICE", False)
comptime DOCUMENT = BaseFilter("J", "filters.DOCUMENT", False)
comptime GAME = BaseFilter("K", "filters.GAME", False)
comptime INVOICE = BaseFilter("L", "filters.INVOICE", False)
comptime LIVE_PHOTO = BaseFilter("M", "filters.LIVE_PHOTO", False)
comptime LOCATION = BaseFilter("N", "filters.LOCATION", False)
comptime PAID_MEDIA = BaseFilter("O", "filters.PAID_MEDIA", False)
comptime PHOTO = BaseFilter("P", "filters.PHOTO", False)
comptime POLL = BaseFilter("Q", "filters.POLL", False)
comptime STICKER = BaseFilter("R", "filters.STICKER", False)
comptime STORY = BaseFilter("S", "filters.STORY", False)
comptime SUCCESSFUL_PAYMENT = BaseFilter("U", "filters.SUCCESSFUL_PAYMENT", False)
comptime TEXT = BaseFilter("T", "filters.TEXT", False)
comptime VENUE = BaseFilter("V", "filters.VENUE", False)
comptime VIDEO = BaseFilter("W", "filters.VIDEO", False)
comptime VIDEO_NOTE = BaseFilter("X", "filters.VIDEO_NOTE", False)
comptime VOICE = BaseFilter("Y", "filters.VOICE", False)

# Public chat-type and update-type filters.
comptime CHAT_CHANNEL = BaseFilter("1", "filters.ChatType.CHANNEL", False)
comptime CHAT_GROUP = BaseFilter("2", "filters.ChatType.GROUP", False)
comptime CHAT_GROUPS = BaseFilter("3", "filters.ChatType.GROUPS", False)
comptime CHAT_PRIVATE = BaseFilter("4", "filters.ChatType.PRIVATE", False)
comptime CHAT_SUPERGROUP = BaseFilter("5", "filters.ChatType.SUPERGROUP", False)
comptime UPDATE_CHANNEL_POST = BaseFilter("0", "filters.UpdateType.CHANNEL_POST", False, String(), False)
comptime UPDATE_CHANNEL_POSTS = BaseFilter("6", "filters.UpdateType.CHANNEL_POSTS", False, String(), False)
comptime UPDATE_EDITED = BaseFilter("7", "filters.UpdateType.EDITED", False, String(), False)
comptime UPDATE_EDITED_CHANNEL_POST = BaseFilter("8", "filters.UpdateType.EDITED_CHANNEL_POST", False, String(), False)
comptime UPDATE_EDITED_MESSAGE = BaseFilter("9", "filters.UpdateType.EDITED_MESSAGE", False, String(), False)
comptime UPDATE_MESSAGE = BaseFilter("a", "filters.UpdateType.MESSAGE", False, String(), False)
comptime UPDATE_MESSAGES = BaseFilter("b", "filters.UpdateType.MESSAGES", False, String(), False)
comptime UPDATE_BUSINESS_MESSAGE = BaseFilter("c", "filters.UpdateType.BUSINESS_MESSAGE", False, String(), False)
comptime UPDATE_EDITED_BUSINESS_MESSAGE = BaseFilter("d", "filters.UpdateType.EDITED_BUSINESS_MESSAGE", False, String(), False)
comptime UPDATE_BUSINESS_MESSAGES = BaseFilter("e", "filters.UpdateType.BUSINESS_MESSAGES", False, String(), False)
comptime UPDATE_GUEST_MESSAGE = BaseFilter("f", "filters.UpdateType.GUEST_MESSAGE", False, String(), False)
comptime STICKER_ALL = BaseFilter("g", "filters.Sticker.ALL", False)
comptime STICKER_ANIMATED = BaseFilter("h", "filters.Sticker.ANIMATED", False)
comptime STICKER_STATIC = BaseFilter("i", "filters.Sticker.STATIC", False)
comptime STICKER_VIDEO = BaseFilter("j", "filters.Sticker.VIDEO", False)
comptime STICKER_PREMIUM = BaseFilter("k", "filters.Sticker.PREMIUM", False)
comptime DICE_ALL = BaseFilter("l", "filters.Dice.ALL", False)
comptime DICE_BASKETBALL = BaseFilter("m", "filters.Dice.BASKETBALL", False)
comptime DICE_BOWLING = BaseFilter("n", "filters.Dice.BOWLING", False)
comptime DICE_DARTS = BaseFilter("o", "filters.Dice.DARTS", False)
comptime DICE_DICE = BaseFilter("p", "filters.Dice.DICE", False)
comptime DICE_FOOTBALL = BaseFilter("q", "filters.Dice.FOOTBALL", False)
comptime DICE_SLOT_MACHINE = BaseFilter("r", "filters.Dice.SLOT_MACHINE", False)
comptime SENDER_CHAT_ALL = BaseFilter("{", "filters.SenderChat.ALL", False)
comptime SENDER_CHAT_CHANNEL = BaseFilter("}", "filters.SenderChat.CHANNEL", False)
comptime SENDER_CHAT_SUPER_GROUP = BaseFilter("<", "filters.SenderChat.SUPER_GROUP", False)
comptime DIRECT_MESSAGES = BaseFilter("s", "filters.DIRECT_MESSAGES", False, String(), False)
comptime EFFECT_ID = BaseFilter("t", "filters.EFFECT_ID", False)
comptime FORUM = BaseFilter("u", "filters.FORUM", False, String(), False)
comptime FORWARDED = BaseFilter("v", "filters.FORWARDED", False)
comptime GIVEAWAY = BaseFilter("w", "filters.GIVEAWAY", False)
comptime GIVEAWAY_WINNERS = BaseFilter("x", "filters.GIVEAWAY_WINNERS", False)
comptime HAS_MEDIA_SPOILER = BaseFilter("y", "filters.HAS_MEDIA_SPOILER", False)
comptime HAS_PROTECTED_CONTENT = BaseFilter("z", "filters.HAS_PROTECTED_CONTENT", False)
comptime IS_AUTOMATIC_FORWARD = BaseFilter("#", "filters.IS_AUTOMATIC_FORWARD", False)
comptime IS_TOPIC_MESSAGE = BaseFilter("$", "filters.IS_TOPIC_MESSAGE", False)
comptime IS_FROM_OFFLINE = BaseFilter("%", "filters.IS_FROM_OFFLINE", False)
comptime PASSPORT_DATA = BaseFilter("+", "filters.PASSPORT_DATA", False)
comptime REPLY = BaseFilter(",", "filters.REPLY", False)
comptime SUGGESTED_POST_INFO = BaseFilter("-", "filters.SUGGESTED_POST_INFO", False)
comptime VIA_BOT = BaseFilter(".", "filters.VIA_BOT", False)
comptime REPLY_TO_STORY = BaseFilter("/", "filters.REPLY_TO_STORY", False)
comptime BOOST_ADDED = BaseFilter(";", "filters.BOOST_ADDED", False)
comptime SENDER_BOOST_COUNT = BaseFilter("<", "filters.SENDER_BOOST_COUNT", False)
comptime USER = BaseFilter("=", "filters.USER", False)
comptime USER_ATTACHMENT = BaseFilter("[", "filters.USER_ATTACHMENT", False, String(), False)
comptime PREMIUM_USER = BaseFilter("]", "filters.PREMIUM_USER", False, String(), False)
comptime DOCUMENT_ALL = BaseFilter("J", "filters.Document.ALL", False)
comptime DOCUMENT_APPLICATION = BaseFilter("@D", "filters.Document.APPLICATION", False, "12:application/")
comptime DOCUMENT_AUDIO = BaseFilter("@D", "filters.Document.AUDIO", False, "6:audio/")
comptime DOCUMENT_IMAGE = BaseFilter("@D", "filters.Document.IMAGE", False, "6:image/")
comptime DOCUMENT_VIDEO = BaseFilter("@D", "filters.Document.VIDEO", False, "6:video/")
comptime DOCUMENT_TEXT = BaseFilter("@D", "filters.Document.TEXT", False, "5:text/")
comptime DOCUMENT_APK = _single_parameter_filter("M", "filters.Document.APK", "application/vnd.android.package-archive")
comptime DOCUMENT_DOC = _single_parameter_filter("M", "filters.Document.DOC", "application/msword")
comptime DOCUMENT_DOCX = _single_parameter_filter("M", "filters.Document.DOCX", "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
comptime DOCUMENT_EXE = _single_parameter_filter("M", "filters.Document.EXE", "application/octet-stream")
comptime DOCUMENT_MP4 = _single_parameter_filter("M", "filters.Document.MP4", "video/mp4")
comptime DOCUMENT_GIF = _single_parameter_filter("M", "filters.Document.GIF", "image/gif")
comptime DOCUMENT_JPG = _single_parameter_filter("M", "filters.Document.JPG", "image/jpeg")
comptime DOCUMENT_MP3 = _single_parameter_filter("M", "filters.Document.MP3", "audio/mpeg")
comptime DOCUMENT_PDF = _single_parameter_filter("M", "filters.Document.PDF", "application/pdf")
comptime DOCUMENT_PY = _single_parameter_filter("M", "filters.Document.PY", "text/x-python")
comptime DOCUMENT_SVG = _single_parameter_filter("M", "filters.Document.SVG", "image/svg+xml")
comptime DOCUMENT_TXT = _single_parameter_filter("M", "filters.Document.TXT", "text/plain")
comptime DOCUMENT_TARGZ = _single_parameter_filter("M", "filters.Document.TARGZ", "application/x-compressed-tar")
comptime DOCUMENT_WAV = _single_parameter_filter("M", "filters.Document.WAV", "audio/x-wav")
comptime DOCUMENT_XML = _single_parameter_filter("M", "filters.Document.XML", "text/xml")
comptime DOCUMENT_ZIP = _single_parameter_filter("M", "filters.Document.ZIP", "application/zip")


struct ChatType:
    """Namespace for the upstream chat-type filter constants."""

    comptime CHANNEL = CHAT_CHANNEL
    comptime GROUP = CHAT_GROUP
    comptime GROUPS = CHAT_GROUPS
    comptime PRIVATE = CHAT_PRIVATE
    comptime SUPERGROUP = CHAT_SUPERGROUP


struct UpdateType:
    """Namespace for the implemented upstream update-type filters."""

    comptime CHANNEL_POST = UPDATE_CHANNEL_POST
    comptime CHANNEL_POSTS = UPDATE_CHANNEL_POSTS
    comptime EDITED = UPDATE_EDITED
    comptime EDITED_CHANNEL_POST = UPDATE_EDITED_CHANNEL_POST
    comptime EDITED_MESSAGE = UPDATE_EDITED_MESSAGE
    comptime MESSAGE = UPDATE_MESSAGE
    comptime MESSAGES = UPDATE_MESSAGES
    comptime BUSINESS_MESSAGE = UPDATE_BUSINESS_MESSAGE
    comptime EDITED_BUSINESS_MESSAGE = UPDATE_EDITED_BUSINESS_MESSAGE
    comptime BUSINESS_MESSAGES = UPDATE_BUSINESS_MESSAGES
    comptime GUEST_MESSAGE = UPDATE_GUEST_MESSAGE


# StatusUpdate has more predicates than can be represented by the single-character
# ordinary-filter opcode table. A colon introduces a second, independent opcode.
comptime STATUS_ALL = BaseFilter(":*", "filters.StatusUpdate.ALL", False)
comptime STATUS_CHAT_BACKGROUND_SET = BaseFilter(":A", "filters.StatusUpdate.CHAT_BACKGROUND_SET", False)
comptime STATUS_CHAT_CREATED = BaseFilter(":B", "filters.StatusUpdate.CHAT_CREATED", False)
comptime STATUS_CHAT_OWNER_CHANGED = BaseFilter(":C", "filters.StatusUpdate.CHAT_OWNER_CHANGED", False)
comptime STATUS_CHAT_OWNER_LEFT = BaseFilter(":D", "filters.StatusUpdate.CHAT_OWNER_LEFT", False)
comptime STATUS_CHAT_SHARED = BaseFilter(":E", "filters.StatusUpdate.CHAT_SHARED", False)
comptime STATUS_CHECKLIST_TASKS_ADDED = BaseFilter(":F", "filters.StatusUpdate.CHECKLIST_TASKS_ADDED", False)
comptime STATUS_CHECKLIST_TASKS_DONE = BaseFilter(":G", "filters.StatusUpdate.CHECKLIST_TASKS_DONE", False)
comptime STATUS_CONNECTED_WEBSITE = BaseFilter(":H", "filters.StatusUpdate.CONNECTED_WEBSITE", False)
comptime STATUS_DIRECT_MESSAGE_PRICE_CHANGED = BaseFilter(":I", "filters.StatusUpdate.DIRECT_MESSAGE_PRICE_CHANGED", False)
comptime STATUS_DELETE_CHAT_PHOTO = BaseFilter(":J", "filters.StatusUpdate.DELETE_CHAT_PHOTO", False)
comptime STATUS_FORUM_TOPIC_CLOSED = BaseFilter(":K", "filters.StatusUpdate.FORUM_TOPIC_CLOSED", False)
comptime STATUS_FORUM_TOPIC_CREATED = BaseFilter(":L", "filters.StatusUpdate.FORUM_TOPIC_CREATED", False)
comptime STATUS_FORUM_TOPIC_EDITED = BaseFilter(":M", "filters.StatusUpdate.FORUM_TOPIC_EDITED", False)
comptime STATUS_FORUM_TOPIC_REOPENED = BaseFilter(":N", "filters.StatusUpdate.FORUM_TOPIC_REOPENED", False)
comptime STATUS_GENERAL_FORUM_TOPIC_HIDDEN = BaseFilter(":O", "filters.StatusUpdate.GENERAL_FORUM_TOPIC_HIDDEN", False)
comptime STATUS_GENERAL_FORUM_TOPIC_UNHIDDEN = BaseFilter(":P", "filters.StatusUpdate.GENERAL_FORUM_TOPIC_UNHIDDEN", False)
comptime STATUS_GIFT = BaseFilter(":Q", "filters.StatusUpdate.GIFT", False)
comptime STATUS_GIFT_UPGRADE_SENT = BaseFilter(":R", "filters.StatusUpdate.GIFT_UPGRADE_SENT", False)
comptime STATUS_GIVEAWAY_COMPLETED = BaseFilter(":S", "filters.StatusUpdate.GIVEAWAY_COMPLETED", False)
comptime STATUS_GIVEAWAY_CREATED = BaseFilter(":T", "filters.StatusUpdate.GIVEAWAY_CREATED", False)
comptime STATUS_LEFT_CHAT_MEMBER = BaseFilter(":U", "filters.StatusUpdate.LEFT_CHAT_MEMBER", False)
comptime STATUS_MANAGED_BOT_CREATED = BaseFilter(":V", "filters.StatusUpdate.MANAGED_BOT_CREATED", False)
comptime STATUS_MESSAGE_AUTO_DELETE_TIMER_CHANGED = BaseFilter(":W", "filters.StatusUpdate.MESSAGE_AUTO_DELETE_TIMER_CHANGED", False)
comptime STATUS_MIGRATE = BaseFilter(":X", "filters.StatusUpdate.MIGRATE", False)
comptime STATUS_NEW_CHAT_MEMBERS = BaseFilter(":Y", "filters.StatusUpdate.NEW_CHAT_MEMBERS", False)
comptime STATUS_NEW_CHAT_PHOTO = BaseFilter(":Z", "filters.StatusUpdate.NEW_CHAT_PHOTO", False)
comptime STATUS_NEW_CHAT_TITLE = BaseFilter(":a", "filters.StatusUpdate.NEW_CHAT_TITLE", False)
comptime STATUS_PAID_MESSAGE_PRICE_CHANGED = BaseFilter(":b", "filters.StatusUpdate.PAID_MESSAGE_PRICE_CHANGED", False)
comptime STATUS_PINNED_MESSAGE = BaseFilter(":c", "filters.StatusUpdate.PINNED_MESSAGE", False)
comptime STATUS_POLL_OPTION_ADDED = BaseFilter(":d", "filters.StatusUpdate.POLL_OPTION_ADDED", False)
comptime STATUS_POLL_OPTION_DELETED = BaseFilter(":e", "filters.StatusUpdate.POLL_OPTION_DELETED", False)
comptime STATUS_PROXIMITY_ALERT_TRIGGERED = BaseFilter(":f", "filters.StatusUpdate.PROXIMITY_ALERT_TRIGGERED", False)
comptime STATUS_REFUNDED_PAYMENT = BaseFilter(":g", "filters.StatusUpdate.REFUNDED_PAYMENT", False)
comptime STATUS_SUGGESTED_POST_APPROVAL_FAILED = BaseFilter(":h", "filters.StatusUpdate.SUGGESTED_POST_APPROVAL_FAILED", False)
comptime STATUS_SUGGESTED_POST_APPROVED = BaseFilter(":i", "filters.StatusUpdate.SUGGESTED_POST_APPROVED", False)
comptime STATUS_SUGGESTED_POST_DECLINED = BaseFilter(":j", "filters.StatusUpdate.SUGGESTED_POST_DECLINED", False)
comptime STATUS_SUGGESTED_POST_PAID = BaseFilter(":k", "filters.StatusUpdate.SUGGESTED_POST_PAID", False)
comptime STATUS_SUGGESTED_POST_REFUNDED = BaseFilter(":l", "filters.StatusUpdate.SUGGESTED_POST_REFUNDED", False)
comptime STATUS_UNIQUE_GIFT = BaseFilter(":m", "filters.StatusUpdate.UNIQUE_GIFT", False)
comptime STATUS_USERS_SHARED = BaseFilter(":n", "filters.StatusUpdate.USERS_SHARED", False)
comptime STATUS_VIDEO_CHAT_ENDED = BaseFilter(":o", "filters.StatusUpdate.VIDEO_CHAT_ENDED", False)
comptime STATUS_VIDEO_CHAT_PARTICIPANTS_INVITED = BaseFilter(":p", "filters.StatusUpdate.VIDEO_CHAT_PARTICIPANTS_INVITED", False)
comptime STATUS_VIDEO_CHAT_SCHEDULED = BaseFilter(":q", "filters.StatusUpdate.VIDEO_CHAT_SCHEDULED", False)
comptime STATUS_VIDEO_CHAT_STARTED = BaseFilter(":r", "filters.StatusUpdate.VIDEO_CHAT_STARTED", False)
comptime STATUS_WEB_APP_DATA = BaseFilter(":s", "filters.StatusUpdate.WEB_APP_DATA", False)
comptime STATUS_WRITE_ACCESS_ALLOWED = BaseFilter(":t", "filters.StatusUpdate.WRITE_ACCESS_ALLOWED", False)


struct StatusUpdate:
    """Namespace for native equivalents of upstream StatusUpdate filters."""

    comptime ALL = STATUS_ALL
    comptime CHAT_BACKGROUND_SET = STATUS_CHAT_BACKGROUND_SET
    comptime CHAT_CREATED = STATUS_CHAT_CREATED
    comptime CHAT_OWNER_CHANGED = STATUS_CHAT_OWNER_CHANGED
    comptime CHAT_OWNER_LEFT = STATUS_CHAT_OWNER_LEFT
    comptime CHAT_SHARED = STATUS_CHAT_SHARED
    comptime CHECKLIST_TASKS_ADDED = STATUS_CHECKLIST_TASKS_ADDED
    comptime CHECKLIST_TASKS_DONE = STATUS_CHECKLIST_TASKS_DONE
    comptime CONNECTED_WEBSITE = STATUS_CONNECTED_WEBSITE
    comptime DIRECT_MESSAGE_PRICE_CHANGED = STATUS_DIRECT_MESSAGE_PRICE_CHANGED
    comptime DELETE_CHAT_PHOTO = STATUS_DELETE_CHAT_PHOTO
    comptime FORUM_TOPIC_CLOSED = STATUS_FORUM_TOPIC_CLOSED
    comptime FORUM_TOPIC_CREATED = STATUS_FORUM_TOPIC_CREATED
    comptime FORUM_TOPIC_EDITED = STATUS_FORUM_TOPIC_EDITED
    comptime FORUM_TOPIC_REOPENED = STATUS_FORUM_TOPIC_REOPENED
    comptime GENERAL_FORUM_TOPIC_HIDDEN = STATUS_GENERAL_FORUM_TOPIC_HIDDEN
    comptime GENERAL_FORUM_TOPIC_UNHIDDEN = STATUS_GENERAL_FORUM_TOPIC_UNHIDDEN
    comptime GIFT = STATUS_GIFT
    comptime GIFT_UPGRADE_SENT = STATUS_GIFT_UPGRADE_SENT
    comptime GIVEAWAY_COMPLETED = STATUS_GIVEAWAY_COMPLETED
    comptime GIVEAWAY_CREATED = STATUS_GIVEAWAY_CREATED
    comptime LEFT_CHAT_MEMBER = STATUS_LEFT_CHAT_MEMBER
    comptime MANAGED_BOT_CREATED = STATUS_MANAGED_BOT_CREATED
    comptime MESSAGE_AUTO_DELETE_TIMER_CHANGED = STATUS_MESSAGE_AUTO_DELETE_TIMER_CHANGED
    comptime MIGRATE = STATUS_MIGRATE
    comptime NEW_CHAT_MEMBERS = STATUS_NEW_CHAT_MEMBERS
    comptime NEW_CHAT_PHOTO = STATUS_NEW_CHAT_PHOTO
    comptime NEW_CHAT_TITLE = STATUS_NEW_CHAT_TITLE
    comptime PAID_MESSAGE_PRICE_CHANGED = STATUS_PAID_MESSAGE_PRICE_CHANGED
    comptime PINNED_MESSAGE = STATUS_PINNED_MESSAGE
    comptime POLL_OPTION_ADDED = STATUS_POLL_OPTION_ADDED
    comptime POLL_OPTION_DELETED = STATUS_POLL_OPTION_DELETED
    comptime PROXIMITY_ALERT_TRIGGERED = STATUS_PROXIMITY_ALERT_TRIGGERED
    comptime REFUNDED_PAYMENT = STATUS_REFUNDED_PAYMENT
    comptime SUGGESTED_POST_APPROVAL_FAILED = STATUS_SUGGESTED_POST_APPROVAL_FAILED
    comptime SUGGESTED_POST_APPROVED = STATUS_SUGGESTED_POST_APPROVED
    comptime SUGGESTED_POST_DECLINED = STATUS_SUGGESTED_POST_DECLINED
    comptime SUGGESTED_POST_PAID = STATUS_SUGGESTED_POST_PAID
    comptime SUGGESTED_POST_REFUNDED = STATUS_SUGGESTED_POST_REFUNDED
    comptime UNIQUE_GIFT = STATUS_UNIQUE_GIFT
    comptime USERS_SHARED = STATUS_USERS_SHARED
    comptime VIDEO_CHAT_ENDED = STATUS_VIDEO_CHAT_ENDED
    comptime VIDEO_CHAT_PARTICIPANTS_INVITED = STATUS_VIDEO_CHAT_PARTICIPANTS_INVITED
    comptime VIDEO_CHAT_SCHEDULED = STATUS_VIDEO_CHAT_SCHEDULED
    comptime VIDEO_CHAT_STARTED = STATUS_VIDEO_CHAT_STARTED
    comptime WEB_APP_DATA = STATUS_WEB_APP_DATA
    comptime WRITE_ACCESS_ALLOWED = STATUS_WRITE_ACCESS_ALLOWED


struct Sticker:
    """Namespace for sticker-type filters."""

    comptime ALL = STICKER_ALL
    comptime ANIMATED = STICKER_ANIMATED
    comptime STATIC = STICKER_STATIC
    comptime VIDEO = STICKER_VIDEO
    comptime PREMIUM = STICKER_PREMIUM


struct Dice:
    """Namespace for dice emoji and value filters."""

    comptime ALL = DICE_ALL
    comptime BASKETBALL = DICE_BASKETBALL
    comptime BOWLING = DICE_BOWLING
    comptime DARTS = DICE_DARTS
    comptime DICE = DICE_DICE
    comptime FOOTBALL = DICE_FOOTBALL
    comptime SLOT_MACHINE = DICE_SLOT_MACHINE

    @staticmethod
    def Filter(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("Dice", String(), values)

    @staticmethod
    def Filter(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("Dice", String(), values^)

    @staticmethod
    def Basketball(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("Basketball", TelegramDice.BASKETBALL, values)

    @staticmethod
    def Basketball(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("Basketball", TelegramDice.BASKETBALL, values^)

    @staticmethod
    def Bowling(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("Bowling", TelegramDice.BOWLING, values)

    @staticmethod
    def Bowling(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("Bowling", TelegramDice.BOWLING, values^)

    @staticmethod
    def Darts(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("Darts", TelegramDice.DARTS, values)

    @staticmethod
    def Darts(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("Darts", TelegramDice.DARTS, values^)

    @staticmethod
    def Dice(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("Dice.Dice", TelegramDice.DICE, values)

    @staticmethod
    def Dice(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("Dice.Dice", TelegramDice.DICE, values^)

    @staticmethod
    def Football(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("Football", TelegramDice.FOOTBALL, values)

    @staticmethod
    def Football(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("Football", TelegramDice.FOOTBALL, values^)

    @staticmethod
    def SlotMachine(values: List[Int]) -> BaseFilter:
        return _dice_config_filter("SlotMachine", TelegramDice.SLOT_MACHINE, values)

    @staticmethod
    def SlotMachine(value: Int) -> BaseFilter:
        var values = List[Int]()
        values.append(value)
        return _dice_config_filter("SlotMachine", TelegramDice.SLOT_MACHINE, values^)


struct Document:
    """Namespace for native document MIME, category, and extension filters."""

    comptime ALL = DOCUMENT_ALL
    comptime APPLICATION = DOCUMENT_APPLICATION
    comptime AUDIO = DOCUMENT_AUDIO
    comptime IMAGE = DOCUMENT_IMAGE
    comptime VIDEO = DOCUMENT_VIDEO
    comptime TEXT = DOCUMENT_TEXT
    comptime APK = DOCUMENT_APK
    comptime DOC = DOCUMENT_DOC
    comptime DOCX = DOCUMENT_DOCX
    comptime EXE = DOCUMENT_EXE
    comptime MP4 = DOCUMENT_MP4
    comptime GIF = DOCUMENT_GIF
    comptime JPG = DOCUMENT_JPG
    comptime MP3 = DOCUMENT_MP3
    comptime PDF = DOCUMENT_PDF
    comptime PY = DOCUMENT_PY
    comptime SVG = DOCUMENT_SVG
    comptime TXT = DOCUMENT_TXT
    comptime TARGZ = DOCUMENT_TARGZ
    comptime WAV = DOCUMENT_WAV
    comptime XML = DOCUMENT_XML
    comptime ZIP = DOCUMENT_ZIP

    @staticmethod
    def Category(category: String) -> BaseFilter:
        return _single_parameter_filter(
            "D",
            "filters.Document.Category(" + _python_repr_string(category) + ")",
            category,
        )

    @staticmethod
    def FileExtension(
        file_extension: Optional[String], case_sensitive: Bool = False
    ) -> BaseFilter:
        if file_extension is None:
            return _single_parameter_filter(
                "n", "filters.Document.FileExtension(None)", ""
            )
        var original = file_extension.value()
        var expected = "." + original
        if case_sensitive:
            return _single_parameter_filter(
                "x",
                "filters.Document.FileExtension("
                + _python_repr_string(original)
                + ", case_sensitive=True)",
                expected,
            )
        expected = _ascii_lowercase(expected)
        return _single_parameter_filter(
            "X",
            "filters.Document.FileExtension("
            + _python_repr_string(_ascii_lowercase(original))
            + ")",
            expected,
        )

    @staticmethod
    def MimeType(mimetype: String) -> BaseFilter:
        return _single_parameter_filter(
            "M",
            "filters.Document.MimeType(" + _python_repr_string(mimetype) + ")",
            mimetype,
        )


def Text(strings: Optional[List[String]] = None) -> BaseFilter:
    """Return a native exact-match text filter, or the unconfigured TEXT filter."""
    if strings is None:
        return TEXT
    return _exact_value_filter(
        "T", "filters.Text", "filters.TEXT", strings.value().copy()
    )


def Caption(strings: Optional[List[String]] = None) -> BaseFilter:
    """Return a native exact-match caption filter, or the unconfigured CAPTION filter."""
    if strings is None:
        return CAPTION
    return _exact_value_filter(
        "C", "filters.Caption", "filters.CAPTION", strings.value().copy()
    )


def SuccessfulPayment(invoice_payloads: Optional[List[String]] = None) -> BaseFilter:
    """Return a native invoice-payload filter, or any successful-payment filter."""
    if invoice_payloads is None:
        return SUCCESSFUL_PAYMENT
    return _exact_value_filter(
        "P",
        "filters.SuccessfulPayment",
        "filters.SUCCESSFUL_PAYMENT",
        invoice_payloads.value().copy(),
    )


def Entity(entity_type: String) -> BaseFilter:
    """Return a filter matching a message entity type."""
    return _single_parameter_filter(
        "E", "filters.Entity(" + entity_type + ")", entity_type
    )


def CaptionEntity(entity_type: String) -> BaseFilter:
    """Return a filter matching a caption entity type."""
    return _single_parameter_filter(
        "e", "filters.CaptionEntity(" + entity_type + ")", entity_type
    )


def Language(languages: List[String]) -> BaseFilter:
    """Return a language filter using starts-with matching for each language prefix."""
    return _exact_value_filter(
        "L",
        "filters.Language",
        "filters.Language([])",
        languages,
    )


def Language(language: String) -> BaseFilter:
    var languages = List[String]()
    languages.append(language)
    return Language(languages^)


def Command(only_start: Bool = True) -> BaseFilter:
    """Return the native command filter, optionally matching any entity position."""
    if only_start:
        return COMMAND
    return BaseFilter(">", "filters.Command(False)", False)


def Chat() raises -> BaseFilter:
    return _identity_config_filter("Chat", List[Int](), List[String]())


def Chat(chat_id: Int) raises -> BaseFilter:
    return _identity_config_filter(
        "Chat", _identity_id_values(chat_id), List[String]()
    )


def Chat(chat_id: List[Int]) raises -> BaseFilter:
    return _identity_config_filter("Chat", chat_id, List[String]())


def Chat(username: String) raises -> BaseFilter:
    return _identity_config_filter(
        "Chat", List[Int](), _identity_username_values(username)
    )


def Chat(usernames: List[String]) raises -> BaseFilter:
    return _identity_config_filter("Chat", List[Int](), usernames)


def Chat(chat_id: Int, username: String, allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter(
        "Chat", _identity_id_values(chat_id), _identity_username_values(username), allow_empty
    )


def Chat(chat_id: List[Int], username: List[String], allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter("Chat", chat_id, username, allow_empty)


def ChatAllowEmpty() raises -> BaseFilter:
    return _identity_config_filter(
        "Chat", List[Int](), List[String](), allow_empty=True
    )


def User() raises -> BaseFilter:
    return _identity_config_filter("User", List[Int](), List[String]())


def User(user_id: Int) raises -> BaseFilter:
    return _identity_config_filter(
        "User", _identity_id_values(user_id), List[String]()
    )


def User(user_id: List[Int]) raises -> BaseFilter:
    return _identity_config_filter("User", user_id, List[String]())


def User(username: String) raises -> BaseFilter:
    return _identity_config_filter(
        "User", List[Int](), _identity_username_values(username)
    )


def User(usernames: List[String]) raises -> BaseFilter:
    return _identity_config_filter("User", List[Int](), usernames)


def User(user_id: Int, username: String, allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter(
        "User", _identity_id_values(user_id), _identity_username_values(username), allow_empty
    )


def User(user_id: List[Int], username: List[String], allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter("User", user_id, username, allow_empty)


def UserAllowEmpty() raises -> BaseFilter:
    return _identity_config_filter(
        "User", List[Int](), List[String](), allow_empty=True
    )


def ViaBot() raises -> BaseFilter:
    return _identity_config_filter("ViaBot", List[Int](), List[String]())


def ViaBot(bot_id: Int) raises -> BaseFilter:
    return _identity_config_filter(
        "ViaBot", _identity_id_values(bot_id), List[String]()
    )


def ViaBot(bot_id: List[Int]) raises -> BaseFilter:
    return _identity_config_filter("ViaBot", bot_id, List[String]())


def ViaBot(username: String) raises -> BaseFilter:
    return _identity_config_filter(
        "ViaBot", List[Int](), _identity_username_values(username)
    )


def ViaBot(usernames: List[String]) raises -> BaseFilter:
    return _identity_config_filter("ViaBot", List[Int](), usernames)


def ViaBot(bot_id: Int, username: String, allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter(
        "ViaBot", _identity_id_values(bot_id), _identity_username_values(username), allow_empty
    )


def ViaBot(bot_id: List[Int], username: List[String], allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter("ViaBot", bot_id, username, allow_empty)


def ViaBotAllowEmpty() raises -> BaseFilter:
    return _identity_config_filter(
        "ViaBot", List[Int](), List[String](), allow_empty=True
    )


def SenderChat() raises -> BaseFilter:
    return _identity_config_filter("SenderChat", List[Int](), List[String]())


def SenderChat(chat_id: Int) raises -> BaseFilter:
    return _identity_config_filter(
        "SenderChat", _identity_id_values(chat_id), List[String]()
    )


def SenderChat(chat_id: List[Int]) raises -> BaseFilter:
    return _identity_config_filter("SenderChat", chat_id, List[String]())


def SenderChat(username: String) raises -> BaseFilter:
    return _identity_config_filter(
        "SenderChat", List[Int](), _identity_username_values(username)
    )


def SenderChat(usernames: List[String]) raises -> BaseFilter:
    return _identity_config_filter("SenderChat", List[Int](), usernames)


def SenderChat(chat_id: Int, username: String, allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter(
        "SenderChat", _identity_id_values(chat_id), _identity_username_values(username), allow_empty
    )


def SenderChat(chat_id: List[Int], username: List[String], allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter("SenderChat", chat_id, username, allow_empty)


def SenderChatAllowEmpty() raises -> BaseFilter:
    return _identity_config_filter(
        "SenderChat", List[Int](), List[String](), allow_empty=True
    )


def ForwardedFrom() raises -> BaseFilter:
    return _identity_config_filter("ForwardedFrom", List[Int](), List[String]())


def ForwardedFrom(chat_id: Int) raises -> BaseFilter:
    return _identity_config_filter(
        "ForwardedFrom", _identity_id_values(chat_id), List[String]()
    )


def ForwardedFrom(chat_id: List[Int]) raises -> BaseFilter:
    return _identity_config_filter("ForwardedFrom", chat_id, List[String]())


def ForwardedFrom(username: String) raises -> BaseFilter:
    return _identity_config_filter(
        "ForwardedFrom", List[Int](), _identity_username_values(username)
    )


def ForwardedFrom(usernames: List[String]) raises -> BaseFilter:
    return _identity_config_filter("ForwardedFrom", List[Int](), usernames)


def ForwardedFrom(chat_id: Int, username: String, allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter(
        "ForwardedFrom", _identity_id_values(chat_id), _identity_username_values(username), allow_empty
    )


def ForwardedFrom(chat_id: List[Int], username: List[String], allow_empty: Bool = False) raises -> BaseFilter:
    return _identity_config_filter("ForwardedFrom", chat_id, username, allow_empty)


def ForwardedFromAllowEmpty() raises -> BaseFilter:
    return _identity_config_filter(
        "ForwardedFrom", List[Int](), List[String](), allow_empty=True
    )


def Mention(mention: Int) -> BaseFilter:
    var ids = List[Int]()
    ids.append(mention)
    return _mention_config_filter(
        ids, List[String](), List[String](),
        "filters.Mention(" + String(mention) + ")",
    )


def Mention(mentions: List[Int]) -> BaseFilter:
    return _mention_config_filter(
        mentions, List[String](), List[String](),
        "filters.Mention(" + _python_repr_int_list(mentions) + ")",
    )


def Mention(mention: String) -> BaseFilter:
    var usernames = List[String]()
    usernames.append(mention)
    return _mention_config_filter(
        List[Int](), usernames, List[String](),
        "filters.Mention(" + mention + ")",
    )


def Mention(usernames: List[String]) -> BaseFilter:
    return _mention_config_filter(
        List[Int](), usernames, List[String](),
        "filters.Mention(" + _python_repr_string_list(usernames) + ")",
    )


def Mention(user: TelegramUser) -> BaseFilter:
    return _mention_user_filter(user)


def Mention(users: List[TelegramUser]) -> BaseFilter:
    var ids = List[Int]()
    var usernames = List[String]()
    for user in users:
        ids.append(user.id)
        if user.username is not None:
            usernames.append(user.username.value().copy())
    return _mention_config_filter(
        ids, List[String](), usernames,
        "filters.Mention(" + _python_repr_int_list(ids) + ")",
    )


def Mention(ids: List[Int], usernames: List[String]) -> BaseFilter:
    return _mention_config_filter(
        ids, usernames, List[String](),
        "filters.Mention(ids=" + _python_repr_int_list(ids)
        + ", usernames=" + _python_repr_string_list(usernames) + ")",
    )
