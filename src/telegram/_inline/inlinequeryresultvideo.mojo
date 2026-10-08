#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InlineQueryResultVideo.
# LGPL-3.0-or-later; see LICENSE.

"""An inline result that sends a photo by URL."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.argumentparsing import parse_sequence_arg
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType


struct InlineQueryResultVideo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Video result; identity follows its result ``id``."""

    var type: String
    var id: String
    var video_url: String
    var mime_type: String
    var thumbnail_url: String
    var video_width: Optional[Int]
    var video_height: Optional[Int]
    var title: String
    var video_duration: Optional[TimeDelta]
    var description: Optional[String]
    var caption: Optional[String]
    var parse_mode: Optional[String]
    var caption_entities: List[MessageEntity]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var show_caption_above_media: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        video_url: String,
        mime_type: String,
        thumbnail_url: String,
        title: String,
        caption: Optional[String] = None,
        video_width: Optional[Int] = None,
        video_height: Optional[Int] = None,
        video_duration: Optional[TimeDelta] = None,
        description: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        show_caption_above_media: Optional[Bool] = None,
    ):
        self.type = InlineQueryResultType.VIDEO.value.copy()
        self.id = id.copy()
        self.video_url = video_url.copy()
        self.mime_type = mime_type.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.video_width = video_width
        self.video_height = video_height
        self.title = title.copy()
        self.video_duration = video_duration.copy()
        self.description = description.copy()
        self.caption = caption.copy()
        self.parse_mode = parse_mode.copy()
        self.caption_entities = parse_sequence_arg(caption_entities)
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.show_caption_above_media = show_caption_above_media
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        video_url: String,
        mime_type: String,
        thumbnail_url: String,
        title: String,
        caption: Optional[String] = None,
        video_width: Optional[Int] = None,
        video_height: Optional[Int] = None,
        video_duration: Optional[TimeDelta] = None,
        description: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        show_caption_above_media: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.VIDEO.value.copy()
        self.id = id.copy()
        self.video_url = video_url.copy()
        self.mime_type = mime_type.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.video_width = video_width
        self.video_height = video_height
        self.title = title.copy()
        self.video_duration = video_duration.copy()
        self.description = description.copy()
        self.caption = caption.copy()
        self.parse_mode = parse_mode.copy()
        self.caption_entities = parse_sequence_arg(caption_entities)
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.show_caption_above_media = show_caption_above_media
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.video_url = existing.video_url.copy()
        self.mime_type = existing.mime_type.copy()
        self.thumbnail_url = existing.thumbnail_url.copy()
        self.video_width = existing.video_width
        self.video_height = existing.video_height
        self.title = existing.title.copy()
        self.video_duration = existing.video_duration.copy()
        self.description = existing.description.copy()
        self.caption = existing.caption.copy()
        self.parse_mode = existing.parse_mode.copy()
        self.caption_entities = List[MessageEntity](copy=existing.caption_entities)
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.show_caption_above_media = existing.show_caption_above_media
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultVideo\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "video_url", self.video_url)
        result.set_string(result.root, "mime_type", self.mime_type)
        result.set_string(result.root, "thumbnail_url", self.thumbnail_url)
        if self.video_width is not None:
            result.set_number(result.root, "video_width", String(self.video_width.value()))
        if self.video_height is not None:
            result.set_number(result.root, "video_height", String(self.video_height.value()))
        result.set_string(result.root, "title", self.title)
        if self.video_duration is not None:
            result.set_number(
                result.root, "video_duration", self.video_duration.value().seconds_json_number()
            )
        if self.description is not None:
            result.set_string(result.root, "description", self.description.value())
        if self.caption is not None:
            result.set_string(result.root, "caption", self.caption.value())
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
        if self.show_caption_above_media is not None:
            result.set_boolean(
                result.root, "show_caption_above_media", self.show_caption_above_media.value()
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultVideo JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var photo_index = data.object_get(data.root, "video_url")
        var mime_type_index = data.object_get(data.root, "mime_type")
        var thumbnail_index = data.object_get(data.root, "thumbnail_url")
        var title_index = data.object_get(data.root, "title")
        if (
            id_index == -1
            or photo_index == -1
            or mime_type_index == -1
            or thumbnail_index == -1
            or title_index == -1
        ):
            raise Error("InlineQueryResultVideo JSON object is missing required fields")

        var video_width: Optional[Int] = None
        var video_width_index = data.object_get(data.root, "video_width")
        if video_width_index != -1 and not data.is_null(video_width_index):
            video_width = Optional[Int](data.integer_value(video_width_index))
        var video_height: Optional[Int] = None
        var video_height_index = data.object_get(data.root, "video_height")
        if video_height_index != -1 and not data.is_null(video_height_index):
            video_height = Optional[Int](data.integer_value(video_height_index))

        var title = data.string_value(title_index)
        var video_duration: Optional[TimeDelta] = None
        var duration_index = data.object_get(data.root, "video_duration")
        if duration_index != -1 and not data.is_null(duration_index):
            video_duration = Optional[TimeDelta](
                to_timedelta(atof(data.number_text(duration_index)))
            )

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
        var show_caption_above_media: Optional[Bool] = None
        var show_index = data.object_get(data.root, "show_caption_above_media")
        if show_index != -1 and not data.is_null(show_index):
            show_caption_above_media = Optional[Bool](data.boolean_value(show_index))

        var caption_entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "caption_entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("InlineQueryResultVideo caption_entities must be an array")
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
                and key != "video_url"
                and key != "mime_type"
                and key != "thumbnail_url"
                and key != "video_width"
                and key != "video_height"
                and key != "video_duration"
                and key != "description"
                and key != "caption"
                and key != "parse_mode"
                and key != "caption_entities"
                and key != "reply_markup"
                and key != "input_message_content"
                and key != "show_caption_above_media"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return InlineQueryResultVideo(
            data.string_value(id_index),
            data.string_value(photo_index),
            data.string_value(mime_type_index),
            data.string_value(thumbnail_index),
            title,
            caption,
            video_width,
            video_height,
            video_duration,
            description,
            reply_markup,
            input_message_content,
            parse_mode,
            Optional[List[MessageEntity]](caption_entities^),
            show_caption_above_media,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultVideo.de_json(items[index].copy()))
        return result^
