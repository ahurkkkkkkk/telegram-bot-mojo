#!/usr/bin/env mojo
#
# Native reply parameter and quote values corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Reply parameters and quoted message text."""

from std.collections import Dict, List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._checklists import Checklist
from telegram._dice import Dice
from telegram._files.animation import Animation
from telegram._files.audio import Audio
from telegram._files.contact import Contact
from telegram._files.document import Document
from telegram._files.livephoto import LivePhoto
from telegram._files.location import Location
from telegram._files.photosize import PhotoSize
from telegram._files.sticker import Sticker
from telegram._files.venue import Venue
from telegram._files.video import Video
from telegram._files.videonote import VideoNote
from telegram._files.voice import Voice
from telegram._games.game import Game
from telegram._giveaway import Giveaway, GiveawayWinners
from telegram._linkpreviewoptions import LinkPreviewOptions
from telegram._messageentity import MessageEntity
from telegram._messageorigin import MessageOrigin
from telegram._paidmedia import PaidMediaInfo
from telegram._payment.invoice import Invoice
from telegram._poll import Poll
from telegram._story import Story
from telegram._telegramobject import TelegramJsonDecodable, TelegramJsonObject
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _reply_require_object(data: JsonDocument, class_name: String) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error(String(class_name, " JSON document has no root"))
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error(String(class_name, " JSON value is not an object"))


def _reply_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("Reply JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _reply_entities_array(
    mut result: JsonDocument, key: String, entities: List[MessageEntity]
) raises:
    var array_index = result.add_array()
    for entity in entities:
        var entity_document = entity.to_dict()
        var entity_index = result.copy_subtree_from(entity_document, entity_document.root)
        result.append_child(array_index, entity_index)
    result.object_set(result.root, key, array_index)


def _reply_api_kwargs(data: JsonDocument, first: String, second: String = String()) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if key != first and key != second:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _reply_optional_model[T: TelegramJsonDecodable](
    data: JsonDocument, key: String
) raises -> Optional[T]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[T](T.de_json(_reply_nested(data, index)))


def _reply_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _reply_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _reply_photo_list(data: JsonDocument, index: Int) raises -> List[PhotoSize]:
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error("ExternalReplyInfo photo must be a JSON array")
    var result = List[PhotoSize]()
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(PhotoSize.de_json(_reply_nested(data, child)))
        child = data.nodes[child].next_sibling
    return result^


def _reply_write_optional[T: TelegramJsonObject](
    mut result: JsonDocument,
    key: String,
    value: Optional[T],
    recursive: Bool,
) raises:
    if value is None:
        return
    var document = value.value().to_dict(recursive=recursive)
    var node = result.copy_subtree_from(document, document.root)
    result.object_set(result.root, key, node)


def _reply_write_photos(
    mut result: JsonDocument, photos: List[PhotoSize], recursive: Bool
) raises:
    if len(photos) == 0:
        return
    var array_node = result.add_array()
    for photo in photos:
        var document = photo.to_dict(recursive=recursive)
        var node = result.copy_subtree_from(document, document.root)
        result.append_child(array_node, node)
    result.object_set(result.root, "photo", array_node)


def _reply_external_api_kwargs(data: JsonDocument) raises -> JsonDocument:
    var fields = List[String]()
    fields.append("origin")
    fields.append("chat")
    fields.append("message_id")
    fields.append("link_preview_options")
    fields.append("animation")
    fields.append("audio")
    fields.append("document")
    fields.append("photo")
    fields.append("sticker")
    fields.append("story")
    fields.append("video")
    fields.append("video_note")
    fields.append("voice")
    fields.append("has_media_spoiler")
    fields.append("checklist")
    fields.append("contact")
    fields.append("dice")
    fields.append("game")
    fields.append("giveaway")
    fields.append("giveaway_winners")
    fields.append("invoice")
    fields.append("location")
    fields.append("poll")
    fields.append("venue")
    fields.append("paid_media")
    fields.append("live_photo")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = False
        for field in fields:
            if key == field:
                known = True
                break
        if not known:
            var node = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), node)
        child = data.nodes[child].next_sibling
    return result^


struct ExternalReplyInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Typed metadata for a replied-to message from another chat or topic."""

    var origin: MessageOrigin
    var chat: Optional[Chat]
    var message_id: Optional[Int]
    var link_preview_options: Optional[LinkPreviewOptions]
    var animation: Optional[Animation]
    var audio: Optional[Audio]
    var document: Optional[Document]
    var photo: List[PhotoSize]
    var sticker: Optional[Sticker]
    var story: Optional[Story]
    var video: Optional[Video]
    var video_note: Optional[VideoNote]
    var voice: Optional[Voice]
    var has_media_spoiler: Optional[Bool]
    var checklist: Optional[Checklist]
    var contact: Optional[Contact]
    var dice: Optional[Dice]
    var game: Optional[Game]
    var giveaway: Optional[Giveaway]
    var giveaway_winners: Optional[GiveawayWinners]
    var invoice: Optional[Invoice]
    var location: Optional[Location]
    var poll: Optional[Poll]
    var venue: Optional[Venue]
    var paid_media: Optional[PaidMediaInfo]
    var live_photo: Optional[LivePhoto]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        origin: MessageOrigin,
        chat: Optional[Chat] = None,
        message_id: Optional[Int] = None,
        link_preview_options: Optional[LinkPreviewOptions] = None,
        animation: Optional[Animation] = None,
        audio: Optional[Audio] = None,
        document: Optional[Document] = None,
        photo: List[PhotoSize] = List[PhotoSize](),
        sticker: Optional[Sticker] = None,
        story: Optional[Story] = None,
        video: Optional[Video] = None,
        video_note: Optional[VideoNote] = None,
        voice: Optional[Voice] = None,
        has_media_spoiler: Optional[Bool] = None,
        contact: Optional[Contact] = None,
        dice: Optional[Dice] = None,
        game: Optional[Game] = None,
        giveaway: Optional[Giveaway] = None,
        giveaway_winners: Optional[GiveawayWinners] = None,
        invoice: Optional[Invoice] = None,
        location: Optional[Location] = None,
        poll: Optional[Poll] = None,
        venue: Optional[Venue] = None,
        paid_media: Optional[PaidMediaInfo] = None,
        checklist: Optional[Checklist] = None,
        live_photo: Optional[LivePhoto] = None,
    ):
        self.origin = origin.copy()
        self.chat = chat.copy()
        self.message_id = message_id
        self.link_preview_options = link_preview_options.copy()
        self.animation = animation.copy()
        self.audio = audio.copy()
        self.document = document.copy()
        self.photo = photo.copy()
        self.sticker = sticker.copy()
        self.story = story.copy()
        self.video = video.copy()
        self.video_note = video_note.copy()
        self.voice = voice.copy()
        self.has_media_spoiler = has_media_spoiler
        self.checklist = checklist.copy()
        self.contact = contact.copy()
        self.dice = dice.copy()
        self.game = game.copy()
        self.giveaway = giveaway.copy()
        self.giveaway_winners = giveaway_winners.copy()
        self.invoice = invoice.copy()
        self.location = location.copy()
        self.poll = poll.copy()
        self.venue = venue.copy()
        self.paid_media = paid_media.copy()
        self.live_photo = live_photo.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        origin: MessageOrigin,
        chat: Optional[Chat],
        message_id: Optional[Int],
        link_preview_options: Optional[LinkPreviewOptions],
        animation: Optional[Animation],
        audio: Optional[Audio],
        document: Optional[Document],
        photo: List[PhotoSize],
        sticker: Optional[Sticker],
        story: Optional[Story],
        video: Optional[Video],
        video_note: Optional[VideoNote],
        voice: Optional[Voice],
        has_media_spoiler: Optional[Bool],
        contact: Optional[Contact],
        dice: Optional[Dice],
        game: Optional[Game],
        giveaway: Optional[Giveaway],
        giveaway_winners: Optional[GiveawayWinners],
        invoice: Optional[Invoice],
        location: Optional[Location],
        poll: Optional[Poll],
        venue: Optional[Venue],
        paid_media: Optional[PaidMediaInfo],
        checklist: Optional[Checklist],
        live_photo: Optional[LivePhoto],
        *,
        api_kwargs: JsonDocument,
    ):
        self.origin = origin.copy()
        self.chat = chat.copy()
        self.message_id = message_id
        self.link_preview_options = link_preview_options.copy()
        self.animation = animation.copy()
        self.audio = audio.copy()
        self.document = document.copy()
        self.photo = photo.copy()
        self.sticker = sticker.copy()
        self.story = story.copy()
        self.video = video.copy()
        self.video_note = video_note.copy()
        self.voice = voice.copy()
        self.has_media_spoiler = has_media_spoiler
        self.checklist = checklist.copy()
        self.contact = contact.copy()
        self.dice = dice.copy()
        self.game = game.copy()
        self.giveaway = giveaway.copy()
        self.giveaway_winners = giveaway_winners.copy()
        self.invoice = invoice.copy()
        self.location = location.copy()
        self.poll = poll.copy()
        self.venue = venue.copy()
        self.paid_media = paid_media.copy()
        self.live_photo = live_photo.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.origin = existing.origin.copy()
        self.chat = existing.chat.copy()
        self.message_id = existing.message_id
        self.link_preview_options = existing.link_preview_options.copy()
        self.animation = existing.animation.copy()
        self.audio = existing.audio.copy()
        self.document = existing.document.copy()
        self.photo = existing.photo.copy()
        self.sticker = existing.sticker.copy()
        self.story = existing.story.copy()
        self.video = existing.video.copy()
        self.video_note = existing.video_note.copy()
        self.voice = existing.voice.copy()
        self.has_media_spoiler = existing.has_media_spoiler
        self.checklist = existing.checklist.copy()
        self.contact = existing.contact.copy()
        self.dice = existing.dice.copy()
        self.game = existing.game.copy()
        self.giveaway = existing.giveaway.copy()
        self.giveaway_winners = existing.giveaway_winners.copy()
        self.invoice = existing.invoice.copy()
        self.location = existing.location.copy()
        self.poll = existing.poll.copy()
        self.venue = existing.venue.copy()
        self.paid_media = existing.paid_media.copy()
        self.live_photo = existing.live_photo.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.origin == other.origin

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ExternalReplyInfo\0").as_bytes())
        hasher.update(String(hash(self.origin)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        _reply_write_optional(result, "origin", Optional[MessageOrigin](self.origin.copy()), recursive)
        _reply_write_optional(result, "chat", self.chat, recursive)
        if self.message_id is not None:
            result.set_number(result.root, "message_id", String(self.message_id.value()))
        _reply_write_optional(result, "link_preview_options", self.link_preview_options, recursive)
        _reply_write_optional(result, "animation", self.animation, recursive)
        _reply_write_optional(result, "audio", self.audio, recursive)
        _reply_write_optional(result, "document", self.document, recursive)
        _reply_write_photos(result, self.photo, recursive)
        _reply_write_optional(result, "sticker", self.sticker, recursive)
        _reply_write_optional(result, "story", self.story, recursive)
        _reply_write_optional(result, "video", self.video, recursive)
        _reply_write_optional(result, "video_note", self.video_note, recursive)
        _reply_write_optional(result, "voice", self.voice, recursive)
        if self.has_media_spoiler is not None:
            result.set_boolean(result.root, "has_media_spoiler", self.has_media_spoiler.value())
        _reply_write_optional(result, "contact", self.contact, recursive)
        _reply_write_optional(result, "dice", self.dice, recursive)
        _reply_write_optional(result, "game", self.game, recursive)
        _reply_write_optional(result, "giveaway", self.giveaway, recursive)
        _reply_write_optional(result, "giveaway_winners", self.giveaway_winners, recursive)
        _reply_write_optional(result, "invoice", self.invoice, recursive)
        _reply_write_optional(result, "location", self.location, recursive)
        _reply_write_optional(result, "poll", self.poll, recursive)
        _reply_write_optional(result, "venue", self.venue, recursive)
        _reply_write_optional(result, "paid_media", self.paid_media, recursive)
        _reply_write_optional(result, "checklist", self.checklist, recursive)
        _reply_write_optional(result, "live_photo", self.live_photo, recursive)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _reply_require_object(data, "ExternalReplyInfo")
        var origin = _reply_optional_model[MessageOrigin](data, "origin")
        if origin is None:
            raise Error("ExternalReplyInfo JSON object is missing origin")
        var photo = List[PhotoSize]()
        var photo_index = data.object_get(data.root, "photo")
        if photo_index != -1 and not data.is_null(photo_index):
            photo = _reply_photo_list(data, photo_index)
        return ExternalReplyInfo(
            origin.value(),
            _reply_optional_model[Chat](data, "chat"),
            _reply_optional_int(data, "message_id"),
            _reply_optional_model[LinkPreviewOptions](data, "link_preview_options"),
            _reply_optional_model[Animation](data, "animation"),
            _reply_optional_model[Audio](data, "audio"),
            _reply_optional_model[Document](data, "document"),
            photo,
            _reply_optional_model[Sticker](data, "sticker"),
            _reply_optional_model[Story](data, "story"),
            _reply_optional_model[Video](data, "video"),
            _reply_optional_model[VideoNote](data, "video_note"),
            _reply_optional_model[Voice](data, "voice"),
            _reply_optional_bool(data, "has_media_spoiler"),
            _reply_optional_model[Contact](data, "contact"),
            _reply_optional_model[Dice](data, "dice"),
            _reply_optional_model[Game](data, "game"),
            _reply_optional_model[Giveaway](data, "giveaway"),
            _reply_optional_model[GiveawayWinners](data, "giveaway_winners"),
            _reply_optional_model[Invoice](data, "invoice"),
            _reply_optional_model[Location](data, "location"),
            _reply_optional_model[Poll](data, "poll"),
            _reply_optional_model[Venue](data, "venue"),
            _reply_optional_model[PaidMediaInfo](data, "paid_media"),
            _reply_optional_model[Checklist](data, "checklist"),
            _reply_optional_model[LivePhoto](data, "live_photo"),
            api_kwargs=_reply_external_api_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct TextQuote(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Quoted text and its position in the original message (UTF-16 units)."""

    var text: String
    var position: Int
    var entities: List[MessageEntity]
    var has_entities: Bool
    var is_manual: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, text: String, position: Int):
        self.text = text.copy()
        self.position = position
        self.entities = List[MessageEntity]()
        self.has_entities = False
        self.is_manual = None
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        position: Int,
        entities: List[MessageEntity],
        is_manual: Optional[Bool] = None,
    ):
        self.text = text.copy()
        self.position = position
        self.entities = entities.copy()
        self.has_entities = True
        self.is_manual = is_manual
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        position: Int,
        entities: List[MessageEntity],
        is_manual: Optional[Bool],
        *,
        api_kwargs: JsonDocument,
    ):
        self.text = text.copy()
        self.position = position
        self.entities = entities.copy()
        self.has_entities = True
        self.is_manual = is_manual
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.position = existing.position
        self.entities = existing.entities.copy()
        self.has_entities = existing.has_entities
        self.is_manual = existing.is_manual
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.text == other.text and self.position == other.position

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.text.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.position).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "text", self.text)
        result.set_number(result.root, "position", String(self.position))
        if self.has_entities:
            _reply_entities_array(result, "entities", self.entities)
        if self.is_manual is not None:
            result.set_boolean(result.root, "is_manual", self.is_manual.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def parse_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.text, entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return parse_message_entities(self.text, self.entities, types)

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _reply_require_object(data, "TextQuote")
        var text_index = data.object_get(data.root, "text")
        var position_index = data.object_get(data.root, "position")
        if text_index == -1 or position_index == -1:
            raise Error("TextQuote JSON object is missing text or position")
        var text = data.string_value(text_index)
        var position = data.integer_value(position_index)
        var entities = List[MessageEntity]()
        var has_entities = False
        var entities_index = data.object_get(data.root, "entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("TextQuote entities must be an array")
            has_entities = True
            var entity_documents = data.array_documents(entities_index)
            for item in entity_documents:
                entities.append(MessageEntity.de_json(item))
        var is_manual: Optional[Bool] = None
        var is_manual_index = data.object_get(data.root, "is_manual")
        if is_manual_index != -1 and not data.is_null(is_manual_index):
            is_manual = Optional[Bool](data.boolean_value(is_manual_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "text" and key != "position" and key != "entities" and key != "is_manual":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        var result = TextQuote(text, position, entities, is_manual, api_kwargs=api_kwargs)
        result.has_entities = has_entities
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct ReplyParameters(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Fields that select and format the message a request replies to."""

    var message_id: Int
    var chat_id_kind: Int
    var chat_id_number: Int
    var chat_id_string: String
    var allow_sending_without_reply: Optional[Bool]
    var quote: Optional[String]
    var quote_parse_mode: Optional[String]
    var quote_entities: List[MessageEntity]
    var has_quote_entities: Bool
    var quote_position: Optional[Int]
    var checklist_task_id: Optional[Int]
    var poll_option_id: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, message_id: Int):
        self.message_id = message_id
        self.chat_id_kind = 0
        self.chat_id_number = 0
        self.chat_id_string = String()
        self.allow_sending_without_reply = None
        self.quote = None
        self.quote_parse_mode = None
        self.quote_entities = List[MessageEntity]()
        self.has_quote_entities = False
        self.quote_position = None
        self.checklist_task_id = None
        self.poll_option_id = None
        self.api_kwargs = empty_json_object()

    def __init__(out self, message_id: Int, *, api_kwargs: JsonDocument):
        self.message_id = message_id
        self.chat_id_kind = 0
        self.chat_id_number = 0
        self.chat_id_string = String()
        self.allow_sending_without_reply = None
        self.quote = None
        self.quote_parse_mode = None
        self.quote_entities = List[MessageEntity]()
        self.has_quote_entities = False
        self.quote_position = None
        self.checklist_task_id = None
        self.poll_option_id = None
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.message_id = existing.message_id
        self.chat_id_kind = existing.chat_id_kind
        self.chat_id_number = existing.chat_id_number
        self.chat_id_string = existing.chat_id_string.copy()
        self.allow_sending_without_reply = existing.allow_sending_without_reply
        self.quote = existing.quote
        self.quote_parse_mode = existing.quote_parse_mode
        self.quote_entities = existing.quote_entities.copy()
        self.has_quote_entities = existing.has_quote_entities
        self.quote_position = existing.quote_position
        self.checklist_task_id = existing.checklist_task_id
        self.poll_option_id = existing.poll_option_id
        self.api_kwargs = existing.api_kwargs.copy()

    def set_chat_id_number(mut self, value: Int):
        self.chat_id_kind = 1
        self.chat_id_number = value
        self.chat_id_string = String()

    def set_chat_id_string(mut self, value: String):
        self.chat_id_kind = 2
        self.chat_id_number = 0
        self.chat_id_string = value.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_id == other.message_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ReplyParameters\0").as_bytes())
        hasher.update(String(self.message_id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "message_id", String(self.message_id))
        if self.chat_id_kind == 1:
            result.set_number(result.root, "chat_id", String(self.chat_id_number))
        elif self.chat_id_kind == 2:
            result.set_string(result.root, "chat_id", self.chat_id_string)
        if self.allow_sending_without_reply is not None:
            result.set_boolean(
                result.root,
                "allow_sending_without_reply",
                self.allow_sending_without_reply.value(),
            )
        if self.quote is not None:
            result.set_string(result.root, "quote", self.quote.value())
        if self.quote_parse_mode is not None:
            result.set_string(result.root, "quote_parse_mode", self.quote_parse_mode.value())
        if self.has_quote_entities:
            _reply_entities_array(result, "quote_entities", self.quote_entities)
        if self.quote_position is not None:
            result.set_number(result.root, "quote_position", String(self.quote_position.value()))
        if self.checklist_task_id is not None:
            result.set_number(result.root, "checklist_task_id", String(self.checklist_task_id.value()))
        if self.poll_option_id is not None:
            result.set_string(result.root, "poll_option_id", self.poll_option_id.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _reply_require_object(data, "ReplyParameters")
        var message_id_index = data.object_get(data.root, "message_id")
        if message_id_index == -1 or data.is_null(message_id_index):
            raise Error("ReplyParameters JSON object is missing message_id")
        var result = ReplyParameters(data.integer_value(message_id_index))
        var chat_id_index = data.object_get(data.root, "chat_id")
        if chat_id_index != -1 and not data.is_null(chat_id_index):
            if data.nodes[chat_id_index].kind == JSON_STRING:
                result.set_chat_id_string(data.string_value(chat_id_index))
            else:
                result.set_chat_id_number(data.integer_value(chat_id_index))
        var allow_index = data.object_get(data.root, "allow_sending_without_reply")
        if allow_index != -1 and not data.is_null(allow_index):
            result.allow_sending_without_reply = Optional[Bool](data.boolean_value(allow_index))
        var quote_index = data.object_get(data.root, "quote")
        if quote_index != -1 and not data.is_null(quote_index):
            result.quote = Optional[String](data.string_value(quote_index))
        var parse_mode_index = data.object_get(data.root, "quote_parse_mode")
        if parse_mode_index != -1 and not data.is_null(parse_mode_index):
            result.quote_parse_mode = Optional[String](data.string_value(parse_mode_index))
        var entities_index = data.object_get(data.root, "quote_entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("ReplyParameters quote_entities must be an array")
            result.has_quote_entities = True
            var entity_documents = data.array_documents(entities_index)
            for item in entity_documents:
                result.quote_entities.append(MessageEntity.de_json(item))
        var quote_position_index = data.object_get(data.root, "quote_position")
        if quote_position_index != -1 and not data.is_null(quote_position_index):
            result.quote_position = Optional[Int](data.integer_value(quote_position_index))
        var checklist_index = data.object_get(data.root, "checklist_task_id")
        if checklist_index != -1 and not data.is_null(checklist_index):
            result.checklist_task_id = Optional[Int](data.integer_value(checklist_index))
        var poll_index = data.object_get(data.root, "poll_option_id")
        if poll_index != -1 and not data.is_null(poll_index):
            result.poll_option_id = Optional[String](data.string_value(poll_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "message_id"
                and key != "chat_id"
                and key != "allow_sending_without_reply"
                and key != "quote"
                and key != "quote_parse_mode"
                and key != "quote_entities"
                and key != "quote_position"
                and key != "checklist_task_id"
                and key != "poll_option_id"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        result.api_kwargs = api_kwargs^
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
