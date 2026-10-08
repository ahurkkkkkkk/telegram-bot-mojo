#!/usr/bin/env mojo
#
# Native entity parsing helpers translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Extract text covered by Telegram MessageEntity values."""

from std.collections import Dict, List
from std.collections.optional import Optional

from telegram import constants
from telegram._messageentity import MessageEntity
from telegram._utils.entity_ranges import slice_message_entity


def parse_message_entity(text: String, offset: Int, length: Int) raises -> String:
    """Native offset overload retained for model methods using explicit ranges."""
    return slice_message_entity(text, offset, length)


def parse_message_entity(text: String, entity: MessageEntity) raises -> String:
    """Return the substring selected by one MessageEntity."""
    return slice_message_entity(text, entity.offset, entity.length)


def _is_known_entity_type(value: String) -> Bool:
    return (
        value == constants.MessageEntityType.BLOCKQUOTE.value
        or value == constants.MessageEntityType.BOLD.value
        or value == constants.MessageEntityType.BOT_COMMAND.value
        or value == constants.MessageEntityType.CASHTAG.value
        or value == constants.MessageEntityType.CODE.value
        or value == constants.MessageEntityType.CUSTOM_EMOJI.value
        or value == constants.MessageEntityType.DATE_TIME.value
        or value == constants.MessageEntityType.EMAIL.value
        or value == constants.MessageEntityType.EXPANDABLE_BLOCKQUOTE.value
        or value == constants.MessageEntityType.HASHTAG.value
        or value == constants.MessageEntityType.ITALIC.value
        or value == constants.MessageEntityType.MENTION.value
        or value == constants.MessageEntityType.PHONE_NUMBER.value
        or value == constants.MessageEntityType.PRE.value
        or value == constants.MessageEntityType.SPOILER.value
        or value == constants.MessageEntityType.STRIKETHROUGH.value
        or value == constants.MessageEntityType.TEXT_LINK.value
        or value == constants.MessageEntityType.TEXT_MENTION.value
        or value == constants.MessageEntityType.UNDERLINE.value
        or value == constants.MessageEntityType.URL.value
    )


def parse_message_entities(
    text: String,
    entities: List[MessageEntity],
    types: Optional[List[String]] = None,
) raises -> Dict[MessageEntity, String]:
    """Map selected entities to their text, defaulting to known Bot API entity types."""
    var result = Dict[MessageEntity, String]()
    for entity in entities:
        var include = False
        if types is None:
            include = _is_known_entity_type(entity.type)
        else:
            for entity_type in types.value():
                if entity_type == entity.type:
                    include = True
                    break
        if include:
            result[entity.copy()] = slice_message_entity(text, entity.offset, entity.length)
    return result^
