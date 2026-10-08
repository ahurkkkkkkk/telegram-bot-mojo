#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 MessageEntity.
# LGPL-3.0-or-later; see LICENSE.

"""Telegram text entities using UTF-16 offsets and lengths."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.entity_ranges import slice_message_entity
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _message_entity_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _message_entity_utf16_prefix(text: String, codepoint_count: Int) -> Int:
    var total_codepoints = 0
    for _ in text.codepoint_slices():
        total_codepoints += 1
    var end = codepoint_count
    if end < 0:
        end += total_codepoints
    if end < 0:
        end = 0
    elif end > total_codepoints:
        end = total_codepoints
    var units = 0
    var current = 0
    for codepoint in text.codepoint_slices():
        if current >= end:
            break
        if ord(codepoint) > 0xFFFF:
            units += 2
        else:
            units += 1
        current += 1
    return units


def _message_entity_utf16_length(text: String) -> Int:
    var units = 0
    for codepoint in text.codepoint_slices():
        if ord(codepoint) > 0xFFFF:
            units += 2
        else:
            units += 1
    return units


struct MessageEntity(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A formatted or semantic span; identity follows type, offset, and length."""

    comptime ALL_TYPES = (
        "blockquote",
        "bold",
        "bot_command",
        "cashtag",
        "code",
        "custom_emoji",
        "date_time",
        "email",
        "expandable_blockquote",
        "hashtag",
        "italic",
        "mention",
        "phone_number",
        "pre",
        "spoiler",
        "strikethrough",
        "text_link",
        "text_mention",
        "underline",
        "url",
    )
    comptime MENTION = constants.MessageEntityType.MENTION.value
    comptime HASHTAG = constants.MessageEntityType.HASHTAG.value
    comptime CASHTAG = constants.MessageEntityType.CASHTAG.value
    comptime BOT_COMMAND = constants.MessageEntityType.BOT_COMMAND.value
    comptime URL = constants.MessageEntityType.URL.value
    comptime EMAIL = constants.MessageEntityType.EMAIL.value
    comptime PHONE_NUMBER = constants.MessageEntityType.PHONE_NUMBER.value
    comptime BOLD = constants.MessageEntityType.BOLD.value
    comptime ITALIC = constants.MessageEntityType.ITALIC.value
    comptime UNDERLINE = constants.MessageEntityType.UNDERLINE.value
    comptime STRIKETHROUGH = constants.MessageEntityType.STRIKETHROUGH.value
    comptime SPOILER = constants.MessageEntityType.SPOILER.value
    comptime BLOCKQUOTE = constants.MessageEntityType.BLOCKQUOTE.value
    comptime EXPANDABLE_BLOCKQUOTE = constants.MessageEntityType.EXPANDABLE_BLOCKQUOTE.value
    comptime CODE = constants.MessageEntityType.CODE.value
    comptime PRE = constants.MessageEntityType.PRE.value
    comptime TEXT_LINK = constants.MessageEntityType.TEXT_LINK.value
    comptime TEXT_MENTION = constants.MessageEntityType.TEXT_MENTION.value
    comptime CUSTOM_EMOJI = constants.MessageEntityType.CUSTOM_EMOJI.value
    comptime DATE_TIME = constants.MessageEntityType.DATE_TIME.value

    var type: String
    var offset: Int
    var length: Int
    var url: Optional[String]
    var user: Optional[User]
    var language: Optional[String]
    var custom_emoji_id: Optional[String]
    var date_time_format: Optional[String]
    var unix_time: Optional[TimestampDateTime]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        type: String,
        offset: Int,
        length: Int,
        url: Optional[String] = None,
        user: Optional[User] = None,
        language: Optional[String] = None,
        custom_emoji_id: Optional[String] = None,
        date_time_format: Optional[String] = None,
        unix_time: Optional[TimestampDateTime] = None,
    ):
        self.type = type.copy()
        self.offset = offset
        self.length = length
        self.url = url.copy()
        self.user = user.copy()
        self.language = language.copy()
        self.custom_emoji_id = custom_emoji_id.copy()
        self.date_time_format = date_time_format.copy()
        self.unix_time = unix_time.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        type: String,
        offset: Int,
        length: Int,
        url: Optional[String] = None,
        user: Optional[User] = None,
        language: Optional[String] = None,
        custom_emoji_id: Optional[String] = None,
        date_time_format: Optional[String] = None,
        unix_time: Optional[TimestampDateTime] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = type.copy()
        self.offset = offset
        self.length = length
        self.url = url.copy()
        self.user = user.copy()
        self.language = language.copy()
        self.custom_emoji_id = custom_emoji_id.copy()
        self.date_time_format = date_time_format.copy()
        self.unix_time = unix_time.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.offset = existing.offset
        self.length = existing.length
        self.url = existing.url.copy()
        self.user = existing.user.copy()
        self.language = existing.language.copy()
        self.custom_emoji_id = existing.custom_emoji_id.copy()
        self.date_time_format = existing.date_time_format.copy()
        self.unix_time = existing.unix_time.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.offset == other.offset and self.length == other.length

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("MessageEntity\0").as_bytes())
        hasher.update(self.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.offset).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.length).as_bytes())

    def extract_text(self, text: String) raises -> String:
        return slice_message_entity(text, self.offset, self.length)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.custom_emoji_id is not None:
            result.set_string(result.root, "custom_emoji_id", self.custom_emoji_id.value())
        if self.date_time_format is not None:
            result.set_string(result.root, "date_time_format", self.date_time_format.value())
        if self.language is not None:
            result.set_string(result.root, "language", self.language.value())
        result.set_number(result.root, "length", String(self.length))
        result.set_number(result.root, "offset", String(self.offset))
        result.set_string(result.root, "type", self.type)
        if self.unix_time is not None:
            result.set_number(result.root, "unix_time", String(to_timestamp(self.unix_time.value())))
        if self.url is not None:
            result.set_string(result.root, "url", self.url.value())
        if self.user is not None:
            var user_data = self.user.value().to_dict(recursive)
            var user_index = result.copy_subtree_from(user_data, user_data.root)
            result.object_set(result.root, "user", user_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MessageEntity JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        var offset_index = data.object_get(data.root, "offset")
        var length_index = data.object_get(data.root, "length")
        if type_index == -1 or offset_index == -1 or length_index == -1:
            raise Error("MessageEntity JSON object is missing required fields")

        var user: Optional[User] = None
        var user_index = data.object_get(data.root, "user")
        if user_index != -1 and not data.is_null(user_index):
            var user_data = JsonDocument()
            user_data.root = user_data.copy_subtree_from(data, user_index)
            user = Optional[User](User.de_json(user_data))
        var unix_time: Optional[TimestampDateTime] = None
        var unix_time_index = data.object_get(data.root, "unix_time")
        if unix_time_index != -1 and not data.is_null(unix_time_index):
            unix_time = Optional[TimestampDateTime](from_timestamp(data.integer_value(unix_time_index)))

        var url = _message_entity_optional_string(data, "url")
        var language = _message_entity_optional_string(data, "language")
        var custom_emoji_id = _message_entity_optional_string(data, "custom_emoji_id")
        var date_time_format = _message_entity_optional_string(data, "date_time_format")

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type" and key != "offset" and key != "length" and key != "url" and
                key != "user" and key != "language" and key != "custom_emoji_id" and
                key != "date_time_format" and key != "unix_time"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return MessageEntity(
            data.string_value(type_index), data.integer_value(offset_index),
            data.integer_value(length_index), url, user, language, custom_emoji_id,
            date_time_format, unix_time, api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MessageEntity.de_json(items[index].copy()))
        return result^

    @staticmethod
    def adjust_message_entities_to_utf_16(
        text: String,
        entities: List[MessageEntity],
    ) -> List[MessageEntity]:
        var result = List[MessageEntity]()
        for index in range(len(entities)):
            var entity = entities[index].copy()
            var start = _message_entity_utf16_prefix(text, entity.offset)
            var end = _message_entity_utf16_prefix(text, entity.offset + entity.length)
            var adjusted = MessageEntity(
                entity.type.copy(), start, end - start, entity.url.copy(), entity.user.copy(),
                entity.language.copy(), entity.custom_emoji_id.copy(),
                entity.date_time_format.copy(), entity.unix_time.copy(),
                api_kwargs=entity.api_kwargs.copy(),
            )
            result.append(adjusted^)
        return result^

    @staticmethod
    def shift_entities(by: Int, entities: List[MessageEntity]) -> List[MessageEntity]:
        var result = List[MessageEntity]()
        for index in range(len(entities)):
            var entity = entities[index].copy()
            entity.offset += by
            result.append(entity^)
        return result^

    @staticmethod
    def shift_entities(by: String, entities: List[MessageEntity]) -> List[MessageEntity]:
        return MessageEntity.shift_entities(_message_entity_utf16_length(by), entities)
