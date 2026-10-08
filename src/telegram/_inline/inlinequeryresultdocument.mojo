#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InlineQueryResultDocument.
# LGPL-3.0-or-later; see LICENSE.

"""An inline result that sends a document from a URL."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.argumentparsing import parse_sequence_arg
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType


struct InlineQueryResultDocument(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Document result; identity follows its result ``id``."""

    var type: String
    var id: String
    var document_url: String
    var title: String
    var mime_type: String
    var description: Optional[String]
    var caption: Optional[String]
    var parse_mode: Optional[String]
    var caption_entities: List[MessageEntity]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var thumbnail_url: Optional[String]
    var thumbnail_width: Optional[Int]
    var thumbnail_height: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        document_url: String,
        title: String,
        mime_type: String,
        caption: Optional[String] = None,
        description: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
    ):
        self.type = InlineQueryResultType.DOCUMENT.value.copy()
        self.id = id.copy()
        self.document_url = document_url.copy()
        self.title = title.copy()
        self.mime_type = mime_type.copy()
        self.description = description.copy()
        self.caption = caption.copy()
        self.parse_mode = parse_mode.copy()
        self.caption_entities = parse_sequence_arg(caption_entities)
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        document_url: String,
        title: String,
        mime_type: String,
        caption: Optional[String] = None,
        description: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.DOCUMENT.value.copy()
        self.id = id.copy()
        self.document_url = document_url.copy()
        self.title = title.copy()
        self.mime_type = mime_type.copy()
        self.description = description.copy()
        self.caption = caption.copy()
        self.parse_mode = parse_mode.copy()
        self.caption_entities = parse_sequence_arg(caption_entities)
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.document_url = existing.document_url.copy()
        self.title = existing.title.copy()
        self.mime_type = existing.mime_type.copy()
        self.description = existing.description.copy()
        self.caption = existing.caption.copy()
        self.parse_mode = existing.parse_mode.copy()
        self.caption_entities = List[MessageEntity](copy=existing.caption_entities)
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.thumbnail_url = existing.thumbnail_url.copy()
        self.thumbnail_width = existing.thumbnail_width
        self.thumbnail_height = existing.thumbnail_height
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultDocument\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "document_url", self.document_url)
        result.set_string(result.root, "title", self.title)
        result.set_string(result.root, "mime_type", self.mime_type)
        if self.description is not None:
            result.set_string(result.root, "description", self.description.value())
        if self.caption is not None:
            result.set_string(result.root, "caption", self.caption.value())
        if self.thumbnail_url is not None:
            result.set_string(result.root, "thumbnail_url", self.thumbnail_url.value())
        if self.thumbnail_width is not None:
            result.set_number(result.root, "thumbnail_width", String(self.thumbnail_width.value()))
        if self.thumbnail_height is not None:
            result.set_number(result.root, "thumbnail_height", String(self.thumbnail_height.value()))
        if self.parse_mode is not None:
            result.set_string(result.root, "parse_mode", self.parse_mode.value())
        if len(self.caption_entities) > 0:
            var entities_index = result.add_array()
            result.object_set(result.root, "caption_entities", entities_index)
            for index in range(len(self.caption_entities)):
                var entity_document = self.caption_entities[index].to_dict(recursive)
                var entity_index = result.copy_subtree_from(
                    entity_document, entity_document.root
                )
                result.append_child(entities_index, entity_index)
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var markup_index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", markup_index)
        if self.input_message_content is not None:
            var content = self.input_message_content.value().to_dict(recursive)
            var content_index = result.copy_subtree_from(content, content.root)
            result.object_set(result.root, "input_message_content", content_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultDocument JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var title_index = data.object_get(data.root, "title")
        var document_index = data.object_get(data.root, "document_url")
        var mime_type_index = data.object_get(data.root, "mime_type")
        if id_index == -1 or title_index == -1 or document_index == -1 or mime_type_index == -1:
            raise Error("InlineQueryResultDocument JSON object is missing required fields")

        var thumbnail_url: Optional[String] = None
        var thumbnail_url_index = data.object_get(data.root, "thumbnail_url")
        if thumbnail_url_index != -1 and not data.is_null(thumbnail_url_index):
            thumbnail_url = Optional[String](data.string_value(thumbnail_url_index))
        var thumbnail_width: Optional[Int] = None
        var thumbnail_width_index = data.object_get(data.root, "thumbnail_width")
        if thumbnail_width_index != -1 and not data.is_null(thumbnail_width_index):
            thumbnail_width = Optional[Int](data.integer_value(thumbnail_width_index))
        var thumbnail_height: Optional[Int] = None
        var thumbnail_height_index = data.object_get(data.root, "thumbnail_height")
        if thumbnail_height_index != -1 and not data.is_null(thumbnail_height_index):
            thumbnail_height = Optional[Int](data.integer_value(thumbnail_height_index))

        var description: Optional[String] = None
        var description_index = data.object_get(data.root, "description")
        if description_index != -1 and not data.is_null(description_index):
            description = Optional[String](data.string_value(description_index))

        var caption: Optional[String] = None
        var caption_index = data.object_get(data.root, "caption")
        if caption_index != -1 and not data.is_null(caption_index):
            caption = Optional[String](data.string_value(caption_index))
        var parse_mode: Optional[String] = None
        var parse_mode_index = data.object_get(data.root, "parse_mode")
        if parse_mode_index != -1 and not data.is_null(parse_mode_index):
            parse_mode = Optional[String](data.string_value(parse_mode_index))

        var caption_entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "caption_entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("InlineQueryResultDocument caption_entities must be an array")
            caption_entities = MessageEntity.de_list(data, entities_index)

        var reply_markup: Optional[InlineKeyboardMarkup] = None
        var markup_index = data.object_get(data.root, "reply_markup")
        if markup_index != -1 and not data.is_null(markup_index):
            var markup = JsonDocument()
            markup.root = markup.copy_subtree_from(data, markup_index)
            reply_markup = Optional[InlineKeyboardMarkup](InlineKeyboardMarkup.de_json(markup))

        var input_message_content: Optional[InputMessageContent] = None
        var content_index = data.object_get(data.root, "input_message_content")
        if content_index != -1 and not data.is_null(content_index):
            var content = JsonDocument()
            content.root = content.copy_subtree_from(data, content_index)
            input_message_content = Optional[InputMessageContent](
                InputMessageContent.de_json(content)
            )

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type"
                and key != "id"
                and key != "title"
                and key != "document_url"
                and key != "mime_type"
                and key != "description"
                and key != "caption"
                and key != "parse_mode"
                and key != "caption_entities"
                and key != "reply_markup"
                and key != "input_message_content"
                and key != "thumbnail_url"
                and key != "thumbnail_width"
                and key != "thumbnail_height"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return InlineQueryResultDocument(
            data.string_value(id_index),
            data.string_value(document_index),
            data.string_value(title_index),
            data.string_value(mime_type_index),
            caption,
            description,
            reply_markup,
            input_message_content,
            parse_mode,
            Optional[List[MessageEntity]](caption_entities^),
            thumbnail_url,
            thumbnail_width,
            thumbnail_height,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultDocument.de_json(items[index].copy()))
        return result^
