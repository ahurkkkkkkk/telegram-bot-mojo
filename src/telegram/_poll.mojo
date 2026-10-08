#!/usr/bin/env mojo
#
# Native PollAnswer model corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""An answer submitted to a non-anonymous Telegram poll."""

from std.collections import Dict, List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram import constants
from telegram._files.animation import Animation
from telegram._files.audio import Audio
from telegram._files.document import Document
from telegram._files.livephoto import LivePhoto
from telegram._files.location import Location
from telegram._files.photosize import PhotoSize
from telegram._files.sticker import Sticker
from telegram._files.venue import Venue
from telegram._files.video import Video
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonDecodable, TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimeDelta, TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _pollanswer_require_object(data: JsonDocument) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("PollAnswer JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("PollAnswer JSON value is not an object")


def _pollanswer_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("PollAnswer JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _poll_api_kwargs(data: JsonDocument, known_fields: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = False
        for field in known_fields:
            if key == field:
                known = True
        if not known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _poll_media_optional[T: TelegramJsonDecodable](
    data: JsonDocument, key: String
) raises -> Optional[T]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[T](T.de_json(_pollanswer_nested(data, index)))


def _poll_media_photo_list(data: JsonDocument, index: Int) raises -> List[PhotoSize]:
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error("PollMedia photo must be a JSON array")
    var result = List[PhotoSize]()
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(PhotoSize.de_json(_pollanswer_nested(data, child)))
        child = data.nodes[child].next_sibling
    return result^


struct PollMedia(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Optional media associated with a poll or poll option."""

    var animation: Optional[Animation]
    var audio: Optional[Audio]
    var document: Optional[Document]
    var live_photo: Optional[LivePhoto]
    var location: Optional[Location]
    var photo: List[PhotoSize]
    var sticker: Optional[Sticker]
    var venue: Optional[Venue]
    var video: Optional[Video]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        animation: Optional[Animation] = None,
        audio: Optional[Audio] = None,
        document: Optional[Document] = None,
        live_photo: Optional[LivePhoto] = None,
        location: Optional[Location] = None,
        photo: List[PhotoSize] = List[PhotoSize](),
        sticker: Optional[Sticker] = None,
        venue: Optional[Venue] = None,
        video: Optional[Video] = None,
    ):
        self.animation = animation.copy()
        self.audio = audio.copy()
        self.document = document.copy()
        self.live_photo = live_photo.copy()
        self.location = location.copy()
        self.photo = photo.copy()
        self.sticker = sticker.copy()
        self.venue = venue.copy()
        self.video = video.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        animation: Optional[Animation],
        audio: Optional[Audio],
        document: Optional[Document],
        live_photo: Optional[LivePhoto],
        location: Optional[Location],
        photo: List[PhotoSize],
        sticker: Optional[Sticker],
        venue: Optional[Venue],
        video: Optional[Video],
        *,
        api_kwargs: JsonDocument,
    ):
        self.animation = animation.copy()
        self.audio = audio.copy()
        self.document = document.copy()
        self.live_photo = live_photo.copy()
        self.location = location.copy()
        self.photo = photo.copy()
        self.sticker = sticker.copy()
        self.venue = venue.copy()
        self.video = video.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.animation = existing.animation.copy()
        self.audio = existing.audio.copy()
        self.document = existing.document.copy()
        self.live_photo = existing.live_photo.copy()
        self.location = existing.location.copy()
        self.photo = existing.photo.copy()
        self.sticker = existing.sticker.copy()
        self.venue = existing.venue.copy()
        self.video = existing.video.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.animation == other.animation
            and self.audio == other.audio
            and self.document == other.document
            and self.live_photo == other.live_photo
            and self.location == other.location
            and self.photo == other.photo
            and self.sticker == other.sticker
            and self.venue == other.venue
            and self.video == other.video
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PollMedia\0").as_bytes())
        if self.animation is not None:
            hasher.update(String(hash(self.animation.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.audio is not None:
            hasher.update(String(hash(self.audio.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.document is not None:
            hasher.update(String(hash(self.document.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.live_photo is not None:
            hasher.update(String(hash(self.live_photo.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.location is not None:
            hasher.update(String(hash(self.location.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        for item in self.photo:
            hasher.update(String(hash(item)).as_bytes())
            hasher.update(String(",").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.sticker is not None:
            hasher.update(String(hash(self.sticker.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.venue is not None:
            hasher.update(String(hash(self.venue.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.video is not None:
            hasher.update(String(hash(self.video.value())).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.animation is not None:
            var value = self.animation.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "animation", node)
        if self.audio is not None:
            var value = self.audio.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "audio", node)
        if self.document is not None:
            var value = self.document.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "document", node)
        if self.live_photo is not None:
            var value = self.live_photo.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "live_photo", node)
        if self.location is not None:
            var value = self.location.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "location", node)
        if len(self.photo) > 0:
            var photo_array = result.add_array()
            for item in self.photo:
                var value = item.to_dict(recursive=recursive)
                var node = result.copy_subtree_from(value, value.root)
                result.append_child(photo_array, node)
            result.object_set(result.root, "photo", photo_array)
        if self.sticker is not None:
            var value = self.sticker.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "sticker", node)
        if self.venue is not None:
            var value = self.venue.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "venue", node)
        if self.video is not None:
            var value = self.video.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "video", node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var animation = _poll_media_optional[Animation](data, "animation")
        var audio = _poll_media_optional[Audio](data, "audio")
        var document = _poll_media_optional[Document](data, "document")
        var live_photo = _poll_media_optional[LivePhoto](data, "live_photo")
        var location = _poll_media_optional[Location](data, "location")
        var photo = List[PhotoSize]()
        var photo_index = data.object_get(data.root, "photo")
        if photo_index != -1 and not data.is_null(photo_index):
            photo = _poll_media_photo_list(data, photo_index)
        var sticker = _poll_media_optional[Sticker](data, "sticker")
        var venue = _poll_media_optional[Venue](data, "venue")
        var video = _poll_media_optional[Video](data, "video")
        var fields = List[String]()
        fields.append("animation")
        fields.append("audio")
        fields.append("document")
        fields.append("live_photo")
        fields.append("location")
        fields.append("photo")
        fields.append("sticker")
        fields.append("venue")
        fields.append("video")
        return PollMedia(
            animation,
            audio,
            document,
            live_photo,
            location,
            photo,
            sticker,
            venue,
            video,
            api_kwargs=_poll_api_kwargs(data, fields),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


def _polloption_parse_entities(
    text: String,
    entities: List[MessageEntity],
    types: Optional[List[String]],
) raises -> Dict[MessageEntity, String]:
    return parse_message_entities(text, entities, types)


struct PollOption(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A poll answer option with stable API identity and optional media."""

    comptime MIN_LENGTH = constants.PollLimit.MIN_OPTION_LENGTH.value
    comptime MAX_LENGTH = constants.PollLimit.MAX_OPTION_LENGTH.value

    var text: String
    var voter_count: Int
    var text_entities: List[MessageEntity]
    var added_by_user: Optional[User]
    var added_by_chat: Optional[Chat]
    var addition_date: Optional[TimestampDateTime]
    var media: Optional[PollMedia]
    var persistent_id: String
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        text: String,
        voter_count: Int,
        text_entities: List[MessageEntity] = List[MessageEntity](),
        added_by_user: Optional[User] = None,
        added_by_chat: Optional[Chat] = None,
        addition_date: Optional[TimestampDateTime] = None,
        media: Optional[PollMedia] = None,
        persistent_id: Optional[String] = None,
    ) raises:
        if persistent_id is None:
            raise Error("PollOption persistent_id is required")
        self.text = text.copy()
        self.voter_count = voter_count
        self.text_entities = text_entities.copy()
        self.added_by_user = added_by_user.copy()
        self.added_by_chat = added_by_chat.copy()
        self.addition_date = addition_date.copy()
        self.media = media.copy()
        self.persistent_id = persistent_id.value().copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        voter_count: Int,
        text_entities: List[MessageEntity],
        added_by_user: Optional[User],
        added_by_chat: Optional[Chat],
        addition_date: Optional[TimestampDateTime],
        media: Optional[PollMedia],
        persistent_id: Optional[String],
        *,
        api_kwargs: JsonDocument,
    ) raises:
        if persistent_id is None:
            raise Error("PollOption persistent_id is required")
        self.text = text.copy()
        self.voter_count = voter_count
        self.text_entities = text_entities.copy()
        self.added_by_user = added_by_user.copy()
        self.added_by_chat = added_by_chat.copy()
        self.addition_date = addition_date.copy()
        self.media = media.copy()
        self.persistent_id = persistent_id.value().copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.voter_count = existing.voter_count
        self.text_entities = existing.text_entities.copy()
        self.added_by_user = existing.added_by_user.copy()
        self.added_by_chat = existing.added_by_chat.copy()
        self.addition_date = existing.addition_date.copy()
        self.media = existing.media.copy()
        self.persistent_id = existing.persistent_id.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.text == other.text
            and self.voter_count == other.voter_count
            and self.persistent_id == other.persistent_id
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PollOption\0").as_bytes())
        hasher.update(self.text.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.voter_count).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.persistent_id.as_bytes())

    def parse_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.text, entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return _polloption_parse_entities(self.text, self.text_entities, types)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "text", self.text)
        result.set_number(result.root, "voter_count", String(self.voter_count))
        if len(self.text_entities) > 0:
            var entities = result.add_array()
            for entity in self.text_entities:
                var value = entity.to_dict(recursive=recursive)
                var node = result.copy_subtree_from(value, value.root)
                result.append_child(entities, node)
            result.object_set(result.root, "text_entities", entities)
        if self.added_by_user is not None:
            var value = self.added_by_user.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "added_by_user", node)
        if self.added_by_chat is not None:
            var value = self.added_by_chat.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "added_by_chat", node)
        if self.addition_date is not None:
            result.set_number(
                result.root,
                "addition_date",
                String(to_timestamp(self.addition_date.value())),
            )
        if self.media is not None:
            var value = self.media.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "media", node)
        result.set_string(result.root, "persistent_id", self.persistent_id)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var text_index = data.object_get(data.root, "text")
        var voter_count_index = data.object_get(data.root, "voter_count")
        var persistent_id_index = data.object_get(data.root, "persistent_id")
        if text_index == -1 or voter_count_index == -1 or persistent_id_index == -1:
            raise Error("PollOption JSON object is missing a required field")
        if data.is_null(text_index) or data.is_null(voter_count_index) or data.is_null(persistent_id_index):
            raise Error("PollOption required field is null")
        var text_entities = List[MessageEntity]()
        var index = data.object_get(data.root, "text_entities")
        if index != -1 and not data.is_null(index):
            if data.nodes[index].kind != JSON_ARRAY:
                raise Error("PollOption text_entities must be an array")
            var child = data.nodes[index].first_child
            while child != -1:
                text_entities.append(MessageEntity.de_json(_pollanswer_nested(data, child)))
                child = data.nodes[child].next_sibling
        var added_by_user: Optional[User] = None
        index = data.object_get(data.root, "added_by_user")
        if index != -1 and not data.is_null(index):
            added_by_user = Optional[User](User.de_json(_pollanswer_nested(data, index)))
        var added_by_chat: Optional[Chat] = None
        index = data.object_get(data.root, "added_by_chat")
        if index != -1 and not data.is_null(index):
            added_by_chat = Optional[Chat](Chat.de_json(_pollanswer_nested(data, index)))
        var addition_date: Optional[TimestampDateTime] = None
        index = data.object_get(data.root, "addition_date")
        if index != -1 and not data.is_null(index):
            addition_date = Optional[TimestampDateTime](from_timestamp(data.integer_value(index)))
        var media: Optional[PollMedia] = None
        index = data.object_get(data.root, "media")
        if index != -1 and not data.is_null(index):
            media = Optional[PollMedia](PollMedia.de_json(_pollanswer_nested(data, index)))
        var fields = List[String]()
        fields.append("text")
        fields.append("voter_count")
        fields.append("text_entities")
        fields.append("added_by_user")
        fields.append("added_by_chat")
        fields.append("addition_date")
        fields.append("media")
        fields.append("persistent_id")
        return PollOption(
            data.string_value(text_index),
            data.integer_value(voter_count_index),
            text_entities,
            added_by_user,
            added_by_chat,
            addition_date,
            media,
            Optional[String](data.string_value(persistent_id_index)),
            api_kwargs=_poll_api_kwargs(data, fields),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


def _poll_entities_to_dict(
    mut result: JsonDocument,
    key: String,
    entities: List[MessageEntity],
    recursive: Bool,
) raises:
    if len(entities) == 0:
        return
    var array_node = result.add_array()
    for entity in entities:
        var value = entity.to_dict(recursive=recursive)
        var node = result.copy_subtree_from(value, value.root)
        result.append_child(array_node, node)
    result.object_set(result.root, key, array_node)


def _poll_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _poll_entity_list(data: JsonDocument, key: String) raises -> List[MessageEntity]:
    var result = List[MessageEntity]()
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return result^
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error("Poll entity field must be a JSON array")
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(MessageEntity.de_json(_pollanswer_nested(data, child)))
        child = data.nodes[child].next_sibling
    return result^


def _poll_parse_entities(
    text: String,
    entities: List[MessageEntity],
    types: Optional[List[String]],
) raises -> Dict[MessageEntity, String]:
    return parse_message_entities(text, entities, types)


struct InputPollOption(Equatable, Hashable, Copyable, TelegramJsonObject):
    """One answer option supplied when creating a poll."""

    var text: String
    var text_parse_mode: Optional[String]
    var text_entities: List[MessageEntity]
    var media: Optional[JsonDocument]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        text: String,
        text_parse_mode: Optional[String] = None,
        text_entities: List[MessageEntity] = List[MessageEntity](),
        media: Optional[JsonDocument] = None,
    ):
        self.text = text.copy()
        self.text_parse_mode = text_parse_mode.copy()
        self.text_entities = text_entities.copy()
        self.media = media.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        text_parse_mode: Optional[String],
        text_entities: List[MessageEntity],
        media: Optional[JsonDocument],
        *,
        api_kwargs: JsonDocument,
    ):
        self.text = text.copy()
        self.text_parse_mode = text_parse_mode.copy()
        self.text_entities = text_entities.copy()
        self.media = media.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.text_parse_mode = existing.text_parse_mode.copy()
        self.text_entities = existing.text_entities.copy()
        self.media = existing.media.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.text == other.text

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InputPollOption\0").as_bytes())
        hasher.update(self.text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "text", self.text)
        if self.text_parse_mode is not None:
            result.set_string(result.root, "text_parse_mode", self.text_parse_mode.value())
        _poll_entities_to_dict(result, "text_entities", self.text_entities, recursive)
        if self.media is not None:
            var value = self.media.value().copy()
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "media", node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var text_index = data.object_get(data.root, "text")
        if text_index == -1 or data.is_null(text_index):
            raise Error("InputPollOption JSON object is missing text")
        var entities = _poll_entity_list(data, "text_entities")
        var fields = List[String]()
        fields.append("text")
        fields.append("text_parse_mode")
        fields.append("text_entities")
        return InputPollOption(
            data.string_value(text_index),
            _poll_optional_string(data, "text_parse_mode"),
            entities,
            None,
            api_kwargs=_poll_api_kwargs(data, fields),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct Poll(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A complete poll value, including option, explanation, and description data."""

    comptime REGULAR = constants.PollType.REGULAR.value
    comptime QUIZ = constants.PollType.QUIZ.value
    comptime MAX_EXPLANATION_LENGTH = constants.PollLimit.MAX_EXPLANATION_LENGTH.value
    comptime MAX_EXPLANATION_LINE_FEEDS = constants.PollLimit.MAX_EXPLANATION_LINE_FEEDS.value
    comptime MIN_OPEN_PERIOD = constants.PollLimit.MIN_OPEN_PERIOD.value
    comptime MAX_OPEN_PERIOD = constants.PollLimit.MAX_OPEN_PERIOD.value
    comptime MIN_QUESTION_LENGTH = constants.PollLimit.MIN_QUESTION_LENGTH.value
    comptime MAX_QUESTION_LENGTH = constants.PollLimit.MAX_QUESTION_LENGTH.value
    comptime MIN_OPTION_LENGTH = constants.PollLimit.MIN_OPTION_LENGTH.value
    comptime MAX_OPTION_LENGTH = constants.PollLimit.MAX_OPTION_LENGTH.value
    comptime MIN_OPTION_NUMBER = constants.PollLimit.MIN_OPTION_NUMBER.value
    comptime MAX_OPTION_NUMBER = constants.PollLimit.MAX_OPTION_NUMBER.value
    comptime MAX_DESCRIPTION_CHARACTERS = constants.PollLimit.MAX_DESCRIPTION_CHARACTERS.value
    comptime MIN_MEMBERSHIP_HOURS = constants.PollLimit.MIN_MEMBERSHIP_HOURS.value

    var id: String
    var question: String
    var options: List[PollOption]
    var total_voter_count: Int
    var is_closed: Bool
    var is_anonymous: Bool
    var type: String
    var allows_multiple_answers: Bool
    var allows_revoting: Bool
    var members_only: Bool
    var correct_option_ids: List[Int]
    var explanation: Optional[String]
    var explanation_entities: List[MessageEntity]
    var explanation_media: Optional[PollMedia]
    var open_period: Optional[TimeDelta]
    var close_date: Optional[TimestampDateTime]
    var question_entities: List[MessageEntity]
    var description: Optional[String]
    var description_entities: List[MessageEntity]
    var country_codes: List[String]
    var media: Optional[PollMedia]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        question: String,
        options: List[PollOption],
        total_voter_count: Int,
        is_closed: Bool,
        is_anonymous: Bool,
        type: String,
        allows_multiple_answers: Bool,
        correct_option_id: Optional[Int] = None,
        explanation: Optional[String] = None,
        explanation_entities: List[MessageEntity] = List[MessageEntity](),
        open_period: Optional[TimeDelta] = None,
        close_date: Optional[TimestampDateTime] = None,
        question_entities: List[MessageEntity] = List[MessageEntity](),
        allows_revoting: Optional[Bool] = None,
        members_only: Optional[Bool] = None,
        correct_option_ids: List[Int] = List[Int](),
        description: Optional[String] = None,
        description_entities: List[MessageEntity] = List[MessageEntity](),
        country_codes: List[String] = List[String](),
        media: Optional[PollMedia] = None,
        explanation_media: Optional[PollMedia] = None,
    ) raises:
        if allows_revoting is None:
            raise Error("Poll allows_revoting is required")
        if members_only is None:
            raise Error("Poll members_only is required")
        self.id = id.copy()
        self.question = question.copy()
        self.options = options.copy()
        self.total_voter_count = total_voter_count
        self.is_closed = is_closed
        self.is_anonymous = is_anonymous
        self.type = type.copy()
        self.allows_multiple_answers = allows_multiple_answers
        self.allows_revoting = allows_revoting.value()
        self.members_only = members_only.value()
        self.correct_option_ids = correct_option_ids.copy()
        if correct_option_id is not None and len(self.correct_option_ids) == 0:
            self.correct_option_ids.append(correct_option_id.value())
        self.explanation = explanation.copy()
        self.explanation_entities = explanation_entities.copy()
        self.explanation_media = explanation_media.copy()
        self.open_period = open_period.copy()
        self.close_date = close_date.copy()
        self.question_entities = question_entities.copy()
        self.description = description.copy()
        self.description_entities = description_entities.copy()
        self.country_codes = country_codes.copy()
        self.media = media.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        question: String,
        options: List[PollOption],
        total_voter_count: Int,
        is_closed: Bool,
        is_anonymous: Bool,
        type: String,
        allows_multiple_answers: Bool,
        correct_option_id: Optional[Int],
        explanation: Optional[String],
        explanation_entities: List[MessageEntity],
        open_period: Optional[TimeDelta],
        close_date: Optional[TimestampDateTime],
        question_entities: List[MessageEntity],
        allows_revoting: Optional[Bool],
        members_only: Optional[Bool],
        correct_option_ids: List[Int],
        description: Optional[String],
        description_entities: List[MessageEntity],
        country_codes: List[String],
        media: Optional[PollMedia],
        explanation_media: Optional[PollMedia],
        *,
        api_kwargs: JsonDocument,
    ) raises:
        if allows_revoting is None:
            raise Error("Poll allows_revoting is required")
        if members_only is None:
            raise Error("Poll members_only is required")
        self.id = id.copy()
        self.question = question.copy()
        self.options = options.copy()
        self.total_voter_count = total_voter_count
        self.is_closed = is_closed
        self.is_anonymous = is_anonymous
        self.type = type.copy()
        self.allows_multiple_answers = allows_multiple_answers
        self.allows_revoting = allows_revoting.value()
        self.members_only = members_only.value()
        self.correct_option_ids = correct_option_ids.copy()
        if correct_option_id is not None and len(self.correct_option_ids) == 0:
            self.correct_option_ids.append(correct_option_id.value())
        self.explanation = explanation.copy()
        self.explanation_entities = explanation_entities.copy()
        self.explanation_media = explanation_media.copy()
        self.open_period = open_period.copy()
        self.close_date = close_date.copy()
        self.question_entities = question_entities.copy()
        self.description = description.copy()
        self.description_entities = description_entities.copy()
        self.country_codes = country_codes.copy()
        self.media = media.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.question = existing.question.copy()
        self.options = existing.options.copy()
        self.total_voter_count = existing.total_voter_count
        self.is_closed = existing.is_closed
        self.is_anonymous = existing.is_anonymous
        self.type = existing.type.copy()
        self.allows_multiple_answers = existing.allows_multiple_answers
        self.allows_revoting = existing.allows_revoting
        self.members_only = existing.members_only
        self.correct_option_ids = existing.correct_option_ids.copy()
        self.explanation = existing.explanation.copy()
        self.explanation_entities = existing.explanation_entities.copy()
        self.explanation_media = existing.explanation_media.copy()
        self.open_period = existing.open_period.copy()
        self.close_date = existing.close_date.copy()
        self.question_entities = existing.question_entities.copy()
        self.description = existing.description.copy()
        self.description_entities = existing.description_entities.copy()
        self.country_codes = existing.country_codes.copy()
        self.media = existing.media.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("Poll\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def parse_explanation_entity(self, entity: MessageEntity) raises -> String:
        if self.explanation is None or self.explanation.value().byte_length() == 0:
            raise Error("This Poll has no explanation")
        return parse_message_entity(
            self.explanation.value(), entity
        )

    def parse_explanation_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        if self.explanation is None or self.explanation.value().byte_length() == 0:
            raise Error("This Poll has no explanation")
        return _poll_parse_entities(
            self.explanation.value(), self.explanation_entities, types
        )

    def parse_question_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.question, entity)

    def parse_question_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return _poll_parse_entities(self.question, self.question_entities, types)

    def parse_description_entity(self, entity: MessageEntity) raises -> String:
        if self.description is None or self.description.value().byte_length() == 0:
            raise Error("This Poll has no description")
        return parse_message_entity(
            self.description.value(), entity
        )

    def parse_description_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        if self.description is None or self.description.value().byte_length() == 0:
            raise Error("This Poll has no description")
        return _poll_parse_entities(
            self.description.value(), self.description_entities, types
        )

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "question", self.question)
        var options_node = result.add_array()
        for option in self.options:
            var value = option.to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.append_child(options_node, node)
        result.object_set(result.root, "options", options_node)
        result.set_number(result.root, "total_voter_count", String(self.total_voter_count))
        result.set_boolean(result.root, "is_closed", self.is_closed)
        result.set_boolean(result.root, "is_anonymous", self.is_anonymous)
        result.set_string(result.root, "type", self.type)
        result.set_boolean(result.root, "allows_multiple_answers", self.allows_multiple_answers)
        result.set_boolean(result.root, "allows_revoting", self.allows_revoting)
        result.set_boolean(result.root, "members_only", self.members_only)
        if len(self.correct_option_ids) > 0:
            var correct_array = result.add_array()
            for option_id in self.correct_option_ids:
                var node = result.add_number(String(option_id))
                result.append_child(correct_array, node)
            result.object_set(result.root, "correct_option_ids", correct_array)
        if self.explanation is not None:
            result.set_string(result.root, "explanation", self.explanation.value())
        _poll_entities_to_dict(result, "explanation_entities", self.explanation_entities, recursive)
        if self.explanation_media is not None:
            var value = self.explanation_media.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "explanation_media", node)
        if self.open_period is not None:
            result.set_number(result.root, "open_period", self.open_period.value().seconds_json_number())
        if self.close_date is not None:
            result.set_number(result.root, "close_date", String(to_timestamp(self.close_date.value())))
        _poll_entities_to_dict(result, "question_entities", self.question_entities, recursive)
        if self.description is not None:
            result.set_string(result.root, "description", self.description.value())
        _poll_entities_to_dict(result, "description_entities", self.description_entities, recursive)
        if len(self.country_codes) > 0:
            var country_array = result.add_array()
            for country in self.country_codes:
                var node = result.add_string(country.copy())
                result.append_child(country_array, node)
            result.object_set(result.root, "country_codes", country_array)
        if self.media is not None:
            var value = self.media.value().to_dict(recursive=recursive)
            var node = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "media", node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var id_index = data.object_get(data.root, "id")
        var question_index = data.object_get(data.root, "question")
        var options_index = data.object_get(data.root, "options")
        var voters_index = data.object_get(data.root, "total_voter_count")
        var closed_index = data.object_get(data.root, "is_closed")
        var anonymous_index = data.object_get(data.root, "is_anonymous")
        var type_index = data.object_get(data.root, "type")
        var multiple_index = data.object_get(data.root, "allows_multiple_answers")
        var revoting_index = data.object_get(data.root, "allows_revoting")
        var members_index = data.object_get(data.root, "members_only")
        if id_index == -1 or question_index == -1 or options_index == -1 or voters_index == -1 or closed_index == -1 or anonymous_index == -1 or type_index == -1 or multiple_index == -1 or revoting_index == -1 or members_index == -1:
            raise Error("Poll JSON object is missing a required field")
        if data.nodes[options_index].kind != JSON_ARRAY:
            raise Error("Poll options must be a JSON array")
        var correct_option_ids = List[Int]()
        var correct_index = data.object_get(data.root, "correct_option_ids")
        if correct_index != -1 and not data.is_null(correct_index):
            if data.nodes[correct_index].kind != JSON_ARRAY:
                raise Error("Poll correct_option_ids must be a JSON array")
            var child = data.nodes[correct_index].first_child
            while child != -1:
                correct_option_ids.append(data.integer_value(child))
                child = data.nodes[child].next_sibling
        var legacy_correct: Optional[Int] = None
        var legacy_index = data.object_get(data.root, "correct_option_id")
        if len(correct_option_ids) == 0 and legacy_index != -1 and not data.is_null(legacy_index):
            legacy_correct = Optional[Int](data.integer_value(legacy_index))
        var open_period: Optional[TimeDelta] = None
        var open_index = data.object_get(data.root, "open_period")
        if open_index != -1 and not data.is_null(open_index):
            open_period = Optional[TimeDelta](TimeDelta(data.integer_value(open_index)))
        var close_date: Optional[TimestampDateTime] = None
        var close_index = data.object_get(data.root, "close_date")
        if close_index != -1 and not data.is_null(close_index):
            close_date = Optional[TimestampDateTime](from_timestamp(data.integer_value(close_index)))
        var country_codes = List[String]()
        var country_index = data.object_get(data.root, "country_codes")
        if country_index != -1 and not data.is_null(country_index):
            if data.nodes[country_index].kind != JSON_ARRAY:
                raise Error("Poll country_codes must be a JSON array")
            var child = data.nodes[country_index].first_child
            while child != -1:
                country_codes.append(data.string_value(child))
                child = data.nodes[child].next_sibling
        var options = PollOption.de_list(data, options_index)
        var explanation_media = _poll_media_optional[PollMedia](data, "explanation_media")
        var media = _poll_media_optional[PollMedia](data, "media")
        var fields = List[String]()
        fields.append("id")
        fields.append("question")
        fields.append("options")
        fields.append("total_voter_count")
        fields.append("is_closed")
        fields.append("is_anonymous")
        fields.append("type")
        fields.append("allows_multiple_answers")
        fields.append("correct_option_id")
        fields.append("correct_option_ids")
        fields.append("explanation")
        fields.append("explanation_entities")
        fields.append("explanation_media")
        fields.append("open_period")
        fields.append("close_date")
        fields.append("question_entities")
        fields.append("allows_revoting")
        fields.append("members_only")
        fields.append("description")
        fields.append("description_entities")
        fields.append("country_codes")
        fields.append("media")
        return Poll(
            data.string_value(id_index),
            data.string_value(question_index),
            options,
            data.integer_value(voters_index),
            data.boolean_value(closed_index),
            data.boolean_value(anonymous_index),
            data.string_value(type_index),
            data.boolean_value(multiple_index),
            legacy_correct,
            _poll_optional_string(data, "explanation"),
            _poll_entity_list(data, "explanation_entities"),
            open_period,
            close_date,
            _poll_entity_list(data, "question_entities"),
            Optional[Bool](data.boolean_value(revoting_index)),
            Optional[Bool](data.boolean_value(members_index)),
            correct_option_ids,
            _poll_optional_string(data, "description"),
            _poll_entity_list(data, "description_entities"),
            country_codes,
            media,
            explanation_media,
            api_kwargs=_poll_api_kwargs(data, fields),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


def _poll_option_event_json(
    persistent_id: String,
    text: String,
    poll_message: Optional[JsonDocument],
    entities: List[MessageEntity],
    api_kwargs: JsonDocument,
    recursive: Bool,
) raises -> JsonDocument:
    var result = empty_json_object()
    result.set_string(result.root, "option_persistent_id", persistent_id)
    result.set_string(result.root, "option_text", text)
    if poll_message is not None:
        var message = poll_message.value().copy()
        var node = result.copy_subtree_from(message, message.root)
        result.object_set(result.root, "poll_message", node)
    _poll_entities_to_dict(result, "option_text_entities", entities, recursive)
    result.merge_object(result.root, api_kwargs.copy(), api_kwargs.root)
    return result^


def _poll_option_event_kwargs(data: JsonDocument) raises -> JsonDocument:
    var fields = List[String]()
    fields.append("option_persistent_id")
    fields.append("option_text")
    fields.append("poll_message")
    fields.append("option_text_entities")
    return _poll_api_kwargs(data, fields)


def _poll_option_event_message(data: JsonDocument) raises -> Optional[JsonDocument]:
    var index = data.object_get(data.root, "poll_message")
    if index == -1 or data.is_null(index):
        return None
    return Optional[JsonDocument](_pollanswer_nested(data, index))


struct PollOptionAdded(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A service event describing an option added to a poll."""

    var option_persistent_id: String
    var option_text: String
    var poll_message: Optional[JsonDocument]
    var option_text_entities: List[MessageEntity]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        option_persistent_id: String,
        option_text: String,
        poll_message: Optional[JsonDocument] = None,
        option_text_entities: List[MessageEntity] = List[MessageEntity](),
    ):
        self.option_persistent_id = option_persistent_id.copy()
        self.option_text = option_text.copy()
        self.poll_message = poll_message.copy()
        self.option_text_entities = option_text_entities.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        option_persistent_id: String,
        option_text: String,
        poll_message: Optional[JsonDocument],
        option_text_entities: List[MessageEntity],
        *,
        api_kwargs: JsonDocument,
    ):
        self.option_persistent_id = option_persistent_id.copy()
        self.option_text = option_text.copy()
        self.poll_message = poll_message.copy()
        self.option_text_entities = option_text_entities.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.option_persistent_id = existing.option_persistent_id.copy()
        self.option_text = existing.option_text.copy()
        self.poll_message = existing.poll_message.copy()
        self.option_text_entities = existing.option_text_entities.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.option_persistent_id == other.option_persistent_id and self.option_text == other.option_text

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PollOptionAdded\0").as_bytes())
        hasher.update(self.option_persistent_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.option_text.as_bytes())

    def parse_option_text_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.option_text, entity)

    def parse_option_text_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return _poll_parse_entities(self.option_text, self.option_text_entities, types)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _poll_option_event_json(
            self.option_persistent_id,
            self.option_text,
            self.poll_message,
            self.option_text_entities,
            self.api_kwargs,
            recursive,
        )

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var id_index = data.object_get(data.root, "option_persistent_id")
        var text_index = data.object_get(data.root, "option_text")
        if id_index == -1 or text_index == -1 or data.is_null(id_index) or data.is_null(text_index):
            raise Error("PollOptionAdded JSON object is missing a required field")
        return PollOptionAdded(
            data.string_value(id_index),
            data.string_value(text_index),
            _poll_option_event_message(data),
            _poll_entity_list(data, "option_text_entities"),
            api_kwargs=_poll_option_event_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct PollOptionDeleted(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A service event describing an option removed from a poll."""

    var option_persistent_id: String
    var option_text: String
    var poll_message: Optional[JsonDocument]
    var option_text_entities: List[MessageEntity]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        option_persistent_id: String,
        option_text: String,
        poll_message: Optional[JsonDocument] = None,
        option_text_entities: List[MessageEntity] = List[MessageEntity](),
    ):
        self.option_persistent_id = option_persistent_id.copy()
        self.option_text = option_text.copy()
        self.poll_message = poll_message.copy()
        self.option_text_entities = option_text_entities.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        option_persistent_id: String,
        option_text: String,
        poll_message: Optional[JsonDocument],
        option_text_entities: List[MessageEntity],
        *,
        api_kwargs: JsonDocument,
    ):
        self.option_persistent_id = option_persistent_id.copy()
        self.option_text = option_text.copy()
        self.poll_message = poll_message.copy()
        self.option_text_entities = option_text_entities.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.option_persistent_id = existing.option_persistent_id.copy()
        self.option_text = existing.option_text.copy()
        self.poll_message = existing.poll_message.copy()
        self.option_text_entities = existing.option_text_entities.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.option_persistent_id == other.option_persistent_id and self.option_text == other.option_text

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PollOptionDeleted\0").as_bytes())
        hasher.update(self.option_persistent_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.option_text.as_bytes())

    def parse_option_text_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.option_text, entity)

    def parse_option_text_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return _poll_parse_entities(self.option_text, self.option_text_entities, types)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _poll_option_event_json(
            self.option_persistent_id,
            self.option_text,
            self.poll_message,
            self.option_text_entities,
            self.api_kwargs,
            recursive,
        )

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var id_index = data.object_get(data.root, "option_persistent_id")
        var text_index = data.object_get(data.root, "option_text")
        if id_index == -1 or text_index == -1 or data.is_null(id_index) or data.is_null(text_index):
            raise Error("PollOptionDeleted JSON object is missing a required field")
        return PollOptionDeleted(
            data.string_value(id_index),
            data.string_value(text_index),
            _poll_option_event_message(data),
            _poll_entity_list(data, "option_text_entities"),
            api_kwargs=_poll_option_event_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct PollAnswer(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A poll ID, selected option indexes, persistent option IDs, and voter."""

    var poll_id: String
    var option_ids: List[Int]
    var option_persistent_ids: List[String]
    var user: Optional[User]
    var voter_chat: Optional[Chat]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        poll_id: String,
        option_ids: List[Int],
        option_persistent_ids: List[String],
        user: Optional[User] = None,
        voter_chat: Optional[Chat] = None,
    ):
        self.poll_id = poll_id.copy()
        self.option_ids = option_ids.copy()
        self.option_persistent_ids = option_persistent_ids.copy()
        self.user = user.copy()
        self.voter_chat = voter_chat.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        poll_id: String,
        option_ids: List[Int],
        option_persistent_ids: List[String],
        user: Optional[User],
        voter_chat: Optional[Chat],
        *,
        api_kwargs: JsonDocument,
    ):
        self.poll_id = poll_id.copy()
        self.option_ids = option_ids.copy()
        self.option_persistent_ids = option_persistent_ids.copy()
        self.user = user.copy()
        self.voter_chat = voter_chat.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.poll_id = existing.poll_id.copy()
        self.option_ids = existing.option_ids.copy()
        self.option_persistent_ids = existing.option_persistent_ids.copy()
        self.user = existing.user.copy()
        self.voter_chat = existing.voter_chat.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.poll_id != other.poll_id or len(self.option_ids) != len(other.option_ids):
            return False
        for index in range(len(self.option_ids)):
            if self.option_ids[index] != other.option_ids[index]:
                return False
        if self.user is None or other.user is None:
            if self.user is not None or other.user is not None:
                return False
        elif self.user.value() != other.user.value():
            return False
        if self.voter_chat is None or other.voter_chat is None:
            return self.voter_chat is None and other.voter_chat is None
        return self.voter_chat.value() == other.voter_chat.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PollAnswer\0").as_bytes())
        hasher.update(self.poll_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        for option_id in self.option_ids:
            hasher.update(String(option_id).as_bytes())
            hasher.update(String(",").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.user is not None:
            hasher.update(String(hash(self.user.value())).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.voter_chat is not None:
            hasher.update(String(hash(self.voter_chat.value())).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "poll_id", self.poll_id)
        var option_ids_array = result.add_array()
        for option_id in self.option_ids:
            var option_node = result.add_number(String(option_id))
            result.append_child(option_ids_array, option_node)
        result.object_set(result.root, "option_ids", option_ids_array)
        var persistent_ids_array = result.add_array()
        for persistent_id in self.option_persistent_ids:
            var persistent_node = result.add_string(persistent_id.copy())
            result.append_child(persistent_ids_array, persistent_node)
        result.object_set(result.root, "option_persistent_ids", persistent_ids_array)
        if self.user is not None:
            var user_document = self.user.value().to_dict(recursive=recursive)
            var user_node = result.copy_subtree_from(user_document, user_document.root)
            result.object_set(result.root, "user", user_node)
        if self.voter_chat is not None:
            var chat_document = self.voter_chat.value().to_dict(recursive=recursive)
            var chat_node = result.copy_subtree_from(chat_document, chat_document.root)
            result.object_set(result.root, "voter_chat", chat_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _pollanswer_require_object(data)
        var poll_id_index = data.object_get(data.root, "poll_id")
        var option_ids_index = data.object_get(data.root, "option_ids")
        var persistent_ids_index = data.object_get(data.root, "option_persistent_ids")
        if poll_id_index == -1 or option_ids_index == -1 or persistent_ids_index == -1:
            raise Error("PollAnswer JSON object is missing required fields")
        if data.nodes[option_ids_index].kind != JSON_ARRAY or data.nodes[persistent_ids_index].kind != JSON_ARRAY:
            raise Error("PollAnswer option ID fields must be arrays")
        var option_ids = List[Int]()
        var id_index = data.nodes[option_ids_index].first_child
        while id_index != -1:
            option_ids.append(data.integer_value(id_index))
            id_index = data.nodes[id_index].next_sibling
        var persistent_ids = List[String]()
        var persistent_index = data.nodes[persistent_ids_index].first_child
        while persistent_index != -1:
            persistent_ids.append(data.string_value(persistent_index))
            persistent_index = data.nodes[persistent_index].next_sibling
        var user: Optional[User] = None
        var user_index = data.object_get(data.root, "user")
        if user_index != -1 and not data.is_null(user_index):
            user = Optional[User](User.de_json(_pollanswer_nested(data, user_index)).copy())
        var voter_chat: Optional[Chat] = None
        var voter_chat_index = data.object_get(data.root, "voter_chat")
        if voter_chat_index != -1 and not data.is_null(voter_chat_index):
            voter_chat = Optional[Chat](
                Chat.de_json(_pollanswer_nested(data, voter_chat_index)).copy()
            )
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "poll_id" and key != "option_ids" and key != "option_persistent_ids" and key != "user" and key != "voter_chat":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return PollAnswer(
            data.string_value(poll_id_index),
            option_ids,
            persistent_ids,
            user,
            voter_chat,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
