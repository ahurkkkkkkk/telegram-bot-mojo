#!/usr/bin/env mojo
#
# Native Game model corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""A Telegram game and its optional text and animation."""

from std.collections import Dict, List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.animation import Animation
from telegram._files.photosize import PhotoSize
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Game(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Game metadata; identity uses title, description, and photo sizes."""

    var title: String
    var description: String
    var photo: List[PhotoSize]
    var text: Optional[String]
    var text_entities: List[MessageEntity]
    var animation: Optional[Animation]
    var api_kwargs: JsonDocument

    def __init__(out self, title: String, description: String, photo: List[PhotoSize]):
        self.title = title.copy()
        self.description = description.copy()
        self.photo = photo.copy()
        self.text = None
        self.text_entities = List[MessageEntity]()
        self.animation = None
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        description: String,
        photo: List[PhotoSize],
        text: Optional[String],
        text_entities: List[MessageEntity],
        animation: Optional[Animation],
    ):
        self.title = title.copy()
        self.description = description.copy()
        self.photo = photo.copy()
        self.text = text
        self.text_entities = text_entities.copy()
        self.animation = animation.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        description: String,
        photo: List[PhotoSize],
        text: Optional[String],
        text_entities: List[MessageEntity],
        animation: Optional[Animation],
        *,
        api_kwargs: JsonDocument,
    ):
        self.title = title.copy()
        self.description = description.copy()
        self.photo = photo.copy()
        self.text = text
        self.text_entities = text_entities.copy()
        self.animation = animation.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.title = existing.title.copy()
        self.description = existing.description.copy()
        self.photo = existing.photo.copy()
        self.text = existing.text
        self.text_entities = existing.text_entities.copy()
        self.animation = existing.animation.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.title != other.title or self.description != other.description:
            return False
        if len(self.photo) != len(other.photo):
            return False
        for index in range(len(self.photo)):
            if self.photo[index] != other.photo[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("Game\0").as_bytes())
        hasher.update(self.title.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.description.as_bytes())
        for photo_size in self.photo:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(hash(photo_size)).as_bytes())

    def parse_text_entity(self, entity: MessageEntity) raises -> String:
        if self.text is None or self.text.value().byte_length() == 0:
            raise Error("This Game has no 'text'.")
        return parse_message_entity(self.text.value(), entity)

    def parse_text_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        if self.text is None or self.text.value().byte_length() == 0:
            raise Error("This Game has no 'text'.")
        return parse_message_entities(self.text.value(), self.text_entities, types)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "title", self.title)
        result.set_string(result.root, "description", self.description)
        var photo_array = result.add_array()
        for item in self.photo:
            var photo_document = item.to_dict(recursive=recursive)
            var photo_node = result.copy_subtree_from(photo_document, photo_document.root)
            result.append_child(photo_array, photo_node)
        result.object_set(result.root, "photo", photo_array)
        if self.text is not None:
            result.set_string(result.root, "text", self.text.value())
        if len(self.text_entities) > 0:
            var entities_array = result.add_array()
            for entity in self.text_entities:
                var entity_document = entity.to_dict(recursive=recursive)
                var entity_node = result.copy_subtree_from(entity_document, entity_document.root)
                result.append_child(entities_array, entity_node)
            result.object_set(result.root, "text_entities", entities_array)
        if self.animation is not None:
            var animation_document = self.animation.value().to_dict(recursive=recursive)
            var animation_node = result.copy_subtree_from(animation_document, animation_document.root)
            result.object_set(result.root, "animation", animation_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Game JSON value must be an object")
        var title_index = data.object_get(data.root, "title")
        var description_index = data.object_get(data.root, "description")
        var photo_index = data.object_get(data.root, "photo")
        if title_index == -1 or description_index == -1 or photo_index == -1:
            raise Error("Game JSON object is missing title, description, or photo")
        if data.nodes[photo_index].kind != JSON_ARRAY:
            raise Error("Game photo must be an array")
        var photo_documents = data.array_documents(photo_index)
        var photo = List[PhotoSize]()
        for item in photo_documents:
            photo.append(PhotoSize.de_json(item))
        var text: Optional[String] = None
        var text_index = data.object_get(data.root, "text")
        if text_index != -1 and not data.is_null(text_index):
            text = Optional[String](data.string_value(text_index))
        var text_entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "text_entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("Game text_entities must be an array")
            var entity_documents = data.array_documents(entities_index)
            for item in entity_documents:
                text_entities.append(MessageEntity.de_json(item))
        var animation: Optional[Animation] = None
        var animation_index = data.object_get(data.root, "animation")
        if animation_index != -1 and not data.is_null(animation_index):
            animation = Optional[Animation](
                Animation.de_json(_game_nested(data, animation_index)).copy()
            )
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "title" and key != "description" and key != "photo" and key != "text" and key != "text_entities" and key != "animation":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Game(
            data.string_value(title_index),
            data.string_value(description_index),
            photo,
            text,
            text_entities,
            animation,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


def _game_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^
