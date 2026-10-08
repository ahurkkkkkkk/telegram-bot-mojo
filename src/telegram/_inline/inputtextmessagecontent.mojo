#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InputTextMessageContent.
# LGPL-3.0-or-later; see LICENSE.

"""Inline-query content that sends text with entities and link previews."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._linkpreviewoptions import LinkPreviewOptions
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.argumentparsing import parse_lpo_and_dwpp, parse_sequence_arg
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct InputTextMessageContent(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Text result; equality and hashing follow ``message_text``."""

    var message_text: String
    var parse_mode: Optional[String]
    var entities: List[MessageEntity]
    var link_preview_options: Optional[LinkPreviewOptions]
    var api_kwargs: JsonDocument

    comptime MIN_TEXT_LENGTH = 1
    comptime MAX_TEXT_LENGTH = 4096

    def __init__(
        out self,
        message_text: String,
        parse_mode: Optional[String] = None,
        entities: Optional[List[MessageEntity]] = None,
        link_preview_options: Optional[LinkPreviewOptions] = None,
        *,
        disable_web_page_preview: Optional[Bool] = None,
    ) raises:
        self.message_text = message_text.copy()
        self.parse_mode = parse_mode
        self.entities = parse_sequence_arg(entities)
        self.link_preview_options = parse_lpo_and_dwpp(
            disable_web_page_preview, link_preview_options
        )
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        message_text: String,
        parse_mode: Optional[String] = None,
        entities: Optional[List[MessageEntity]] = None,
        link_preview_options: Optional[LinkPreviewOptions] = None,
        *,
        disable_web_page_preview: Optional[Bool] = None,
        api_kwargs: JsonDocument,
    ) raises:
        self.message_text = message_text.copy()
        self.parse_mode = parse_mode
        self.entities = parse_sequence_arg(entities)
        self.link_preview_options = parse_lpo_and_dwpp(
            disable_web_page_preview, link_preview_options
        )
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.message_text = existing.message_text.copy()
        self.parse_mode = existing.parse_mode
        self.entities = List[MessageEntity](copy=existing.entities)
        self.link_preview_options = existing.link_preview_options.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_text == other.message_text

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.message_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if len(self.entities) > 0:
            var entities_index = result.add_array()
            result.object_set(result.root, "entities", entities_index)
            for index in range(len(self.entities)):
                var entity_document = self.entities[index].to_dict(recursive)
                var entity_index = result.copy_subtree_from(
                    entity_document, entity_document.root
                )
                result.append_child(entities_index, entity_index)
        if self.link_preview_options is not None:
            var options_document = self.link_preview_options.value().to_dict(recursive)
            var options_index = result.copy_subtree_from(
                options_document, options_document.root
            )
            result.object_set(result.root, "link_preview_options", options_index)
        result.set_string(result.root, "message_text", self.message_text)
        if self.parse_mode is not None:
            result.set_string(result.root, "parse_mode", self.parse_mode.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("InputTextMessageContent JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InputTextMessageContent JSON value is not an object")

        var message_text_index = data.object_get(data.root, "message_text")
        if message_text_index == -1:
            raise Error("InputTextMessageContent JSON object is missing message_text")
        var message_text = data.string_value(message_text_index)

        var parse_mode: Optional[String] = None
        var parse_mode_index = data.object_get(data.root, "parse_mode")
        if parse_mode_index != -1 and not data.is_null(parse_mode_index):
            parse_mode = Optional[String](data.string_value(parse_mode_index))

        var entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("InputTextMessageContent entities must be an array")
            entities = MessageEntity.de_list(data, entities_index)

        var link_preview_options: Optional[LinkPreviewOptions] = None
        var options_index = data.object_get(data.root, "link_preview_options")
        if options_index != -1 and not data.is_null(options_index):
            var options_document = JsonDocument()
            options_document.root = options_document.copy_subtree_from(data, options_index)
            link_preview_options = Optional[LinkPreviewOptions](
                LinkPreviewOptions.de_json(options_document)
            )

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "message_text"
                and key != "parse_mode"
                and key != "entities"
                and key != "link_preview_options"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InputTextMessageContent(
            message_text,
            parse_mode,
            Optional[List[MessageEntity]](entities^),
            link_preview_options,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InputTextMessageContent.de_json(items[index].copy()))
        return result^
