#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResultCachedSticker.
# LGPL-3.0-or-later; see LICENSE.

"""A cached Telegram sticker returned as an inline query result."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType


struct InlineQueryResultCachedSticker(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Cached sticker result with source id identity and optional message content."""

    var type: String
    var id: String
    var sticker_file_id: String
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        sticker_file_id: String,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
    ):
        self.type = InlineQueryResultType.STICKER.value.copy()
        self.id = id.copy()
        self.sticker_file_id = sticker_file_id.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        sticker_file_id: String,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.STICKER.value.copy()
        self.id = id.copy()
        self.sticker_file_id = sticker_file_id.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.sticker_file_id = existing.sticker_file_id.copy()
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultCachedSticker\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "sticker_file_id", self.sticker_file_id)
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", index)
        if self.input_message_content is not None:
            var content = self.input_message_content.value().to_dict(recursive)
            var index = result.copy_subtree_from(content, content.root)
            result.object_set(result.root, "input_message_content", index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultCachedSticker JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var sticker_index = data.object_get(data.root, "sticker_file_id")
        if id_index == -1 or sticker_index == -1:
            raise Error("InlineQueryResultCachedSticker JSON object is missing required fields")

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

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type" and key != "id" and key != "sticker_file_id" and
                key != "reply_markup" and key != "input_message_content"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultCachedSticker(
            data.string_value(id_index), data.string_value(sticker_index), markup, content,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultCachedSticker.de_json(items[index].copy()))
        return result^
