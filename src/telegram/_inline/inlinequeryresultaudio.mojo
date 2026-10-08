#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InlineQueryResultAudio.
# LGPL-3.0-or-later; see LICENSE.

"""An inline result that sends an audio file by URL."""

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


struct InlineQueryResultAudio(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Cached audio result; identity follows its result ``id``."""

    var type: String
    var id: String
    var audio_url: String
    var title: String
    var performer: Optional[String]
    var audio_duration: Optional[TimeDelta]
    var caption: Optional[String]
    var parse_mode: Optional[String]
    var caption_entities: List[MessageEntity]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        audio_url: String,
        title: String,
        performer: Optional[String] = None,
        audio_duration: Optional[TimeDelta] = None,
        caption: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
    ):
        self.type = InlineQueryResultType.AUDIO.value.copy()
        self.id = id.copy()
        self.audio_url = audio_url.copy()
        self.title = title.copy()
        self.performer = performer.copy()
        self.audio_duration = audio_duration.copy()
        self.caption = caption.copy()
        self.parse_mode = parse_mode.copy()
        self.caption_entities = parse_sequence_arg(caption_entities)
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        audio_url: String,
        title: String,
        performer: Optional[String] = None,
        audio_duration: Optional[TimeDelta] = None,
        caption: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.AUDIO.value.copy()
        self.id = id.copy()
        self.audio_url = audio_url.copy()
        self.title = title.copy()
        self.performer = performer.copy()
        self.audio_duration = audio_duration.copy()
        self.caption = caption.copy()
        self.parse_mode = parse_mode.copy()
        self.caption_entities = parse_sequence_arg(caption_entities)
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.audio_url = existing.audio_url.copy()
        self.title = existing.title.copy()
        self.performer = existing.performer.copy()
        self.audio_duration = existing.audio_duration.copy()
        self.caption = existing.caption.copy()
        self.parse_mode = existing.parse_mode.copy()
        self.caption_entities = List[MessageEntity](copy=existing.caption_entities)
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultAudio\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "audio_url", self.audio_url)
        result.set_string(result.root, "title", self.title)
        if self.performer is not None:
            result.set_string(result.root, "performer", self.performer.value())
        if self.audio_duration is not None:
            result.set_number(
                result.root, "audio_duration", self.audio_duration.value().seconds_json_number()
            )
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
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultAudio JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var audio_index = data.object_get(data.root, "audio_url")
        var title_index = data.object_get(data.root, "title")
        if id_index == -1 or audio_index == -1 or title_index == -1:
            raise Error("InlineQueryResultAudio JSON object is missing required fields")

        var performer: Optional[String] = None
        var performer_index = data.object_get(data.root, "performer")
        if performer_index != -1 and not data.is_null(performer_index):
            performer = Optional[String](data.string_value(performer_index))
        var audio_duration: Optional[TimeDelta] = None
        var duration_index = data.object_get(data.root, "audio_duration")
        if duration_index != -1 and not data.is_null(duration_index):
            audio_duration = Optional[TimeDelta](
                to_timedelta(atof(data.number_text(duration_index)))
            )

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
                raise Error("InlineQueryResultAudio caption_entities must be an array")
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
                and key != "audio_url"
                and key != "title"
                and key != "performer"
                and key != "audio_duration"
                and key != "caption"
                and key != "parse_mode"
                and key != "caption_entities"
                and key != "reply_markup"
                and key != "input_message_content"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return InlineQueryResultAudio(
            data.string_value(id_index),
            data.string_value(audio_index),
            data.string_value(title_index),
            performer,
            audio_duration,
            caption,
            reply_markup,
            input_message_content,
            parse_mode,
            Optional[List[MessageEntity]](caption_entities^),
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultAudio.de_json(items[index].copy()))
        return result^
