#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResultArticle.
# LGPL-3.0-or-later; see LICENSE.

"""An article-style inline result with nested message content."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType


def _inline_article_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _inline_article_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


struct InlineQueryResultArticle(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Article result; equality follows the inherited inline-result id identity."""

    var type: String
    var id: String
    var title: String
    var input_message_content: InputMessageContent
    var reply_markup: Optional[InlineKeyboardMarkup]
    var url: Optional[String]
    var description: Optional[String]
    var thumbnail_url: Optional[String]
    var thumbnail_width: Optional[Int]
    var thumbnail_height: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        title: String,
        input_message_content: InputMessageContent,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        url: Optional[String] = None,
        description: Optional[String] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
    ):
        self.type = InlineQueryResultType.ARTICLE.value.copy()
        self.id = id.copy()
        self.title = title.copy()
        self.input_message_content = input_message_content.copy()
        self.reply_markup = reply_markup.copy()
        self.url = url.copy()
        self.description = description.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        title: String,
        input_message_content: InputMessageContent,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        url: Optional[String] = None,
        description: Optional[String] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.ARTICLE.value.copy()
        self.id = id.copy()
        self.title = title.copy()
        self.input_message_content = input_message_content.copy()
        self.reply_markup = reply_markup.copy()
        self.url = url.copy()
        self.description = description.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.title = existing.title.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.reply_markup = existing.reply_markup.copy()
        self.url = existing.url.copy()
        self.description = existing.description.copy()
        self.thumbnail_url = existing.thumbnail_url.copy()
        self.thumbnail_width = existing.thumbnail_width
        self.thumbnail_height = existing.thumbnail_height
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultArticle\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "title", self.title)
        var content = self.input_message_content.to_dict(recursive)
        var content_index = result.copy_subtree_from(content, content.root)
        result.object_set(result.root, "input_message_content", content_index)
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var markup_index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", markup_index)
        if self.url is not None:
            result.set_string(result.root, "url", self.url.value())
        if self.description is not None:
            result.set_string(result.root, "description", self.description.value())
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
            raise Error("InlineQueryResultArticle JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var title_index = data.object_get(data.root, "title")
        var content_index = data.object_get(data.root, "input_message_content")
        if id_index == -1 or title_index == -1 or content_index == -1:
            raise Error("InlineQueryResultArticle JSON object is missing required fields")

        var content_data = JsonDocument()
        content_data.root = content_data.copy_subtree_from(data, content_index)
        var content = InputMessageContent.de_json(content_data)
        var markup: Optional[InlineKeyboardMarkup] = None
        var markup_index = data.object_get(data.root, "reply_markup")
        if markup_index != -1 and not data.is_null(markup_index):
            var markup_data = JsonDocument()
            markup_data.root = markup_data.copy_subtree_from(data, markup_index)
            markup = Optional[InlineKeyboardMarkup](InlineKeyboardMarkup.de_json(markup_data))

        var url = _inline_article_optional_string(data, "url")
        var description = _inline_article_optional_string(data, "description")
        var thumbnail_url = _inline_article_optional_string(data, "thumbnail_url")
        var thumbnail_width = _inline_article_optional_int(data, "thumbnail_width")
        var thumbnail_height = _inline_article_optional_int(data, "thumbnail_height")

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type" and key != "id" and key != "title" and
                key != "input_message_content" and key != "reply_markup" and
                key != "url" and key != "description" and key != "thumbnail_url" and
                key != "thumbnail_width" and key != "thumbnail_height"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultArticle(
            data.string_value(id_index), data.string_value(title_index), content,
            markup, url, description, thumbnail_url, thumbnail_width, thumbnail_height,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultArticle.de_json(items[index].copy()))
        return result^
