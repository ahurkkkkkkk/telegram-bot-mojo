#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResultContact.
# LGPL-3.0-or-later; see LICENSE.

"""A contact card returned as an inline query result."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType


def _inline_contact_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _inline_contact_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


struct InlineQueryResultContact(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Contact result; identity is the inherited inline result id."""

    var type: String
    var id: String
    var phone_number: String
    var first_name: String
    var last_name: Optional[String]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var vcard: Optional[String]
    var thumbnail_url: Optional[String]
    var thumbnail_width: Optional[Int]
    var thumbnail_height: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        phone_number: String,
        first_name: String,
        last_name: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        vcard: Optional[String] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
    ):
        self.type = InlineQueryResultType.CONTACT.value.copy()
        self.id = id.copy()
        self.phone_number = phone_number.copy()
        self.first_name = first_name.copy()
        self.last_name = last_name.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.vcard = vcard.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        phone_number: String,
        first_name: String,
        last_name: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        vcard: Optional[String] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.CONTACT.value.copy()
        self.id = id.copy()
        self.phone_number = phone_number.copy()
        self.first_name = first_name.copy()
        self.last_name = last_name.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.vcard = vcard.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.phone_number = existing.phone_number.copy()
        self.first_name = existing.first_name.copy()
        self.last_name = existing.last_name.copy()
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.vcard = existing.vcard.copy()
        self.thumbnail_url = existing.thumbnail_url.copy()
        self.thumbnail_width = existing.thumbnail_width
        self.thumbnail_height = existing.thumbnail_height
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultContact\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "phone_number", self.phone_number)
        result.set_string(result.root, "first_name", self.first_name)
        if self.last_name is not None:
            result.set_string(result.root, "last_name", self.last_name.value())
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", index)
        if self.input_message_content is not None:
            var content = self.input_message_content.value().to_dict(recursive)
            var index = result.copy_subtree_from(content, content.root)
            result.object_set(result.root, "input_message_content", index)
        if self.vcard is not None:
            result.set_string(result.root, "vcard", self.vcard.value())
        if self.thumbnail_url is not None:
            result.set_string(result.root, "thumbnail_url", self.thumbnail_url.value())
        if self.thumbnail_width is not None:
            result.set_number(result.root, "thumbnail_width", String(self.thumbnail_width.value()))
        if self.thumbnail_height is not None:
            result.set_number(result.root, "thumbnail_height", String(self.thumbnail_height.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultContact JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var phone_index = data.object_get(data.root, "phone_number")
        var first_name_index = data.object_get(data.root, "first_name")
        if id_index == -1 or phone_index == -1 or first_name_index == -1:
            raise Error("InlineQueryResultContact JSON object is missing required fields")

        var markup: Optional[InlineKeyboardMarkup] = None
        var markup_index = data.object_get(data.root, "reply_markup")
        if markup_index != -1 and not data.is_null(markup_index):
            var nested = JsonDocument()
            nested.root = nested.copy_subtree_from(data, markup_index)
            markup = Optional[InlineKeyboardMarkup](InlineKeyboardMarkup.de_json(nested))
        var content: Optional[InputMessageContent] = None
        var content_index = data.object_get(data.root, "input_message_content")
        if content_index != -1 and not data.is_null(content_index):
            var nested = JsonDocument()
            nested.root = nested.copy_subtree_from(data, content_index)
            content = Optional[InputMessageContent](InputMessageContent.de_json(nested))

        var last_name = _inline_contact_optional_string(data, "last_name")
        var vcard = _inline_contact_optional_string(data, "vcard")
        var thumbnail_url = _inline_contact_optional_string(data, "thumbnail_url")
        var thumbnail_width = _inline_contact_optional_int(data, "thumbnail_width")
        var thumbnail_height = _inline_contact_optional_int(data, "thumbnail_height")

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type" and key != "id" and key != "phone_number" and
                key != "first_name" and key != "last_name" and key != "reply_markup" and
                key != "input_message_content" and key != "vcard" and key != "thumbnail_url" and
                key != "thumbnail_width" and key != "thumbnail_height"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultContact(
            data.string_value(id_index), data.string_value(phone_index),
            data.string_value(first_name_index), last_name, markup, content, vcard,
            thumbnail_url, thumbnail_width, thumbnail_height, api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultContact.de_json(items[index].copy()))
        return result^
