#!/usr/bin/env mojo
#
# Native Message model foundation for python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native message identity, common text fields, and lossless API-field retention."""

from std.collections import Dict, List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._chatboost import ChatBoostAdded
from telegram._chatowner import ChatOwnerChanged, ChatOwnerLeft
from telegram._botcommandscope import ChatIdentifier
from telegram._checklists import Checklist
from telegram._dice import Dice
from telegram._directmessagepricechanged import DirectMessagePriceChanged
from telegram._directmessagestopic import DirectMessagesTopic
from telegram._files.animation import Animation
from telegram._files.audio import Audio
from telegram._files.contact import Contact
from telegram._files.document import Document
from telegram._files.location import Location
from telegram._files.livephoto import LivePhoto
from telegram._files.photosize import PhotoSize
from telegram._files.sticker import Sticker
from telegram._files.venue import Venue
from telegram._files.video import Video
from telegram._files.videonote import VideoNote
from telegram._files.voice import Voice
from telegram._forumtopic import ForumTopicCreated, ForumTopicEdited
from telegram._games.game import Game
from telegram._giveaway import Giveaway, GiveawayCompleted, GiveawayCreated, GiveawayWinners
from telegram._gifts import GiftInfo
from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._linkpreviewoptions import LinkPreviewOptions
from telegram._managedbot import ManagedBotCreated
from telegram._messageautodeletetimerchanged import MessageAutoDeleteTimerChanged
from telegram._messageentity import MessageEntity
from telegram._messageorigin import MessageOrigin
from telegram._payment.invoice import Invoice
from telegram._payment.refundedpayment import RefundedPayment
from telegram._payment.successfulpayment import SuccessfulPayment
from telegram._paidmedia import PaidMediaInfo
from telegram._paidmessagepricechanged import PaidMessagePriceChanged
from telegram._poll import Poll, PollOptionAdded, PollOptionDeleted
from telegram._proximityalerttriggered import ProximityAlertTriggered
from telegram._reply import ExternalReplyInfo, ReplyParameters, TextQuote
from telegram._shared import ChatShared, UsersShared
from telegram._story import Story
from telegram._telegramobject import TelegramJsonDecodable, TelegramJsonObject
from telegram._uniquegift import UniqueGiftInfo
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._videochat import (
    VideoChatEnded,
    VideoChatParticipantsInvited,
    VideoChatScheduled,
    VideoChatStarted,
)
from telegram._webappdata import WebAppData
from telegram._writeaccessallowed import WriteAccessAllowed


def _message_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("Message JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _message_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _message_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _message_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _message_optional_datetime(
    data: JsonDocument, key: String
) raises -> Optional[TimestampDateTime]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[TimestampDateTime](from_timestamp(data.integer_value(index)))


def _message_optional_model[T: TelegramJsonDecodable](
    data: JsonDocument, key: String
) raises -> Optional[T]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[T](T.de_json(_message_nested(data, index)))


def _message_optional_document(
    data: JsonDocument, key: String
) raises -> Optional[JsonDocument]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[JsonDocument](_message_nested(data, index))


def _message_model_list[T: TelegramJsonDecodable](
    data: JsonDocument, key: String
) raises -> List[T]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return List[T]()
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error(String("Message ", key, " field must be a JSON array"))
    return T.de_list(data, index)


def _message_set_optional_model[T: TelegramJsonObject](
    mut result: JsonDocument,
    key: String,
    value: Optional[T],
    recursive: Bool,
) raises:
    if value is None:
        return
    var nested = value.value().to_dict(recursive=recursive)
    var index = result.copy_subtree_from(nested, nested.root)
    result.object_set(result.root, key, index)


def _message_set_optional_document(
    mut result: JsonDocument, key: String, value: Optional[JsonDocument]
) raises:
    if value is None:
        return
    var nested = value.value().copy()
    var index = result.copy_subtree_from(nested, nested.root)
    result.object_set(result.root, key, index)


def _message_set_model_list[T: TelegramJsonObject](
    mut result: JsonDocument,
    key: String,
    values: List[T],
    recursive: Bool,
) raises:
    if len(values) == 0:
        return
    var array_index = result.add_array()
    for value in values:
        var nested = value.to_dict(recursive=recursive)
        var index = result.copy_subtree_from(nested, nested.root)
        result.append_child(array_index, index)
    result.object_set(result.root, key, array_index)


def _message_model_list_document[T: TelegramJsonObject](
    values: List[T], recursive: Bool = True
) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_array()
    for value in values:
        var nested = value.to_dict(recursive=recursive)
        var index = result.copy_subtree_from(nested, nested.root)
        result.append_child(result.root, index)
    return result^


def _message_set_optional_string(
    mut result: JsonDocument, key: String, value: Optional[String]
) raises:
    if value is not None:
        result.set_string(result.root, key, value.value())


def _message_set_optional_int(
    mut result: JsonDocument, key: String, value: Optional[Int]
) raises:
    if value is not None:
        result.set_number(result.root, key, String(value.value()))


def _message_set_optional_bool(
    mut result: JsonDocument, key: String, value: Optional[Bool]
) raises:
    if value is not None:
        result.set_boolean(result.root, key, value.value())


def _message_entities(data: JsonDocument, key: String) raises -> List[MessageEntity]:
    var result = List[MessageEntity]()
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return result^
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error(String("Message ", key, " field must be a JSON array"))
    var elements = data.array_documents(index)
    for element in elements:
        result.append(MessageEntity.de_json(element.copy()))
    return result^


def _message_codepoints(value: String) -> List[Int]:
    var result = List[Int]()
    for character in value.codepoint_slices():
        result.append(ord(character))
    return result^


def _message_utf16_width(codepoint: Int) -> Int:
    if codepoint > 0xFFFF:
        return 2
    return 1


def _message_quote_positions(text: String, quote: String) -> List[Int]:
    var text_codepoints = _message_codepoints(text)
    var quote_codepoints = _message_codepoints(quote)
    var result = List[Int]()
    if len(quote_codepoints) == 0:
        var total_units = 0
        for codepoint in text_codepoints:
            total_units += _message_utf16_width(codepoint)
        for byte_index in range(total_units * 2 + 1):
            result.append(byte_index // 2)
        return result^

    var start = 0
    while start + len(quote_codepoints) <= len(text_codepoints):
        var matches = True
        for quote_index in range(len(quote_codepoints)):
            if text_codepoints[start + quote_index] != quote_codepoints[quote_index]:
                matches = False
                break
        if matches:
            var position_units = 0
            for text_index in range(start):
                position_units += _message_utf16_width(text_codepoints[text_index])
            result.append(position_units)
            start += len(quote_codepoints)
        else:
            start += 1
    return result^


def _message_entities_to_json(
    mut result: JsonDocument,
    key: String,
    entities: List[MessageEntity],
    recursive: Bool,
) raises:
    if len(entities) == 0:
        return
    var array_index = result.add_array()
    for entity in entities:
        var entity_data = entity.to_dict(recursive=recursive)
        var entity_index = result.copy_subtree_from(entity_data, entity_data.root)
        result.append_child(array_index, entity_index)
    result.object_set(result.root, key, array_index)


def _message_api_kwargs(data: JsonDocument) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var is_known = (
            key == "message_id" or key == "date" or key == "chat" or key == "from" or
            key == "sender_chat" or key == "text" or key == "entities" or key == "caption" or
            key == "caption_entities" or key == "edit_date" or key == "new_chat_title" or
            key == "delete_chat_photo" or key == "group_chat_created" or
            key == "supergroup_chat_created" or key == "channel_chat_created" or
            key == "migrate_to_chat_id" or key == "migrate_from_chat_id" or
            key == "author_signature" or key == "media_group_id" or
            key == "connected_website" or key == "is_automatic_forward" or
            key == "has_protected_content" or key == "is_topic_message" or
            key == "message_thread_id" or key == "has_media_spoiler" or
            key == "sender_boost_count" or key == "business_connection_id" or
            key == "is_from_offline" or key == "effect_id" or
            key == "show_caption_above_media" or key == "paid_star_count" or
            key == "is_paid_post" or key == "reply_to_checklist_task_id" or
            key == "reply_to_poll_option_id" or key == "sender_tag" or
            key == "guest_query_id" or key == "reply_to_message" or key == "audio" or
            key == "document" or key == "game" or key == "photo" or key == "sticker" or
            key == "video" or key == "voice" or key == "video_note" or
            key == "new_chat_members" or key == "contact" or key == "location" or
            key == "venue" or key == "left_chat_member" or key == "new_chat_photo" or
            key == "pinned_message" or key == "invoice" or key == "successful_payment" or
            key == "animation" or key == "poll" or key == "reply_markup" or
            key == "dice" or key == "via_bot" or
            key == "proximity_alert_triggered" or
            key == "video_chat_started" or
            key == "video_chat_ended" or
            key == "video_chat_participants_invited" or
            key == "message_auto_delete_timer_changed" or
            key == "video_chat_scheduled" or
            key == "web_app_data" or
            key == "forum_topic_created" or
            key == "forum_topic_edited" or
            key == "write_access_allowed" or
            key == "chat_shared" or
            key == "story" or
            key == "giveaway" or
            key == "giveaway_completed" or
            key == "giveaway_created" or
            key == "giveaway_winners" or
            key == "users_shared" or
            key == "link_preview_options" or
            key == "external_reply" or
            key == "quote" or
            key == "forward_origin" or
            key == "reply_to_story" or
            key == "boost_added" or
            key == "sender_business_bot" or
            key == "paid_media" or
            key == "refunded_payment" or
            key == "gift" or
            key == "unique_gift" or
            key == "paid_message_price_changed" or
            key == "direct_message_price_changed" or
            key == "checklist" or
            key == "direct_messages_topic" or
            key == "gift_upgrade_sent" or
            key == "chat_owner_changed" or
            key == "chat_owner_left" or
            key == "poll_option_added" or
            key == "poll_option_deleted" or
            key == "managed_bot_created" or
            key == "guest_bot_caller_user" or
            key == "guest_bot_caller_chat" or
            key == "live_photo"
        )
        if not is_known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct MessageAttachment(Copyable):
    """A tagged message attachment with its native Bot API JSON payload."""

    var type: String
    var payload: JsonDocument

    def __init__(out self, type: String, payload: JsonDocument):
        self.type = type.copy()
        self.payload = payload.copy()

    def to_dict(self) -> JsonDocument:
        return self.payload.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.payload.copy())


def _message_attachment_model[T: TelegramJsonObject](
    attachment_type: String, value: Optional[T]
) raises -> Optional[MessageAttachment]:
    if value is None:
        return None
    return Optional[MessageAttachment](
        MessageAttachment(attachment_type, value.value().to_dict(recursive=True))
    )


struct MessageReplyArguments(Copyable):
    """Native equivalent of the ``chat_id``/``reply_parameters`` reply mapping."""

    var chat_id: ChatIdentifier
    var reply_parameters: ReplyParameters

    def __init__(out self, chat_id: ChatIdentifier, reply_parameters: ReplyParameters):
        self.chat_id = chat_id.copy()
        self.reply_parameters = reply_parameters.copy()

    def to_dict(self) raises -> JsonDocument:
        var result = empty_json_object()
        if self.chat_id.username.byte_length() > 0:
            result.set_string(result.root, "chat_id", self.chat_id.username)
        else:
            result.set_number(result.root, "chat_id", String(self.chat_id.number))
        var reply_data = self.reply_parameters.to_dict()
        var reply_index = result.copy_subtree_from(reply_data, reply_data.root)
        result.object_set(result.root, "reply_parameters", reply_index)
        return result^


struct Message(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A native Telegram message with typed identity and common text fields."""

    var message_id: Int
    var date: TimestampDateTime
    var chat: Chat
    var from_user: Optional[User]
    var sender_chat: Optional[Chat]
    var text: Optional[String]
    var entities: List[MessageEntity]
    var caption: Optional[String]
    var caption_entities: List[MessageEntity]
    var edit_date: Optional[TimestampDateTime]
    var new_chat_title: Optional[String]
    var delete_chat_photo: Optional[Bool]
    var group_chat_created: Optional[Bool]
    var supergroup_chat_created: Optional[Bool]
    var channel_chat_created: Optional[Bool]
    var migrate_to_chat_id: Optional[Int]
    var migrate_from_chat_id: Optional[Int]
    var author_signature: Optional[String]
    var media_group_id: Optional[String]
    var connected_website: Optional[String]
    var is_automatic_forward: Optional[Bool]
    var has_protected_content: Optional[Bool]
    var is_topic_message: Optional[Bool]
    var message_thread_id: Optional[Int]
    var has_media_spoiler: Optional[Bool]
    var sender_boost_count: Optional[Int]
    var business_connection_id: Optional[String]
    var is_from_offline: Optional[Bool]
    var effect_id: Optional[String]
    var show_caption_above_media: Optional[Bool]
    var paid_star_count: Optional[Int]
    var is_paid_post: Optional[Bool]
    var reply_to_checklist_task_id: Optional[Int]
    var reply_to_poll_option_id: Optional[String]
    var sender_tag: Optional[String]
    var guest_query_id: Optional[String]
    var reply_to_message: Optional[JsonDocument]
    var audio: Optional[Audio]
    var document: Optional[Document]
    var game: Optional[Game]
    var photo: List[PhotoSize]
    var sticker: Optional[Sticker]
    var video: Optional[Video]
    var voice: Optional[Voice]
    var video_note: Optional[VideoNote]
    var new_chat_members: List[User]
    var contact: Optional[Contact]
    var location: Optional[Location]
    var venue: Optional[Venue]
    var left_chat_member: Optional[User]
    var new_chat_photo: List[PhotoSize]
    var pinned_message: Optional[JsonDocument]
    var invoice: Optional[Invoice]
    var successful_payment: Optional[SuccessfulPayment]
    var animation: Optional[Animation]
    var poll: Optional[Poll]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var dice: Optional[Dice]
    var via_bot: Optional[User]
    var proximity_alert_triggered: Optional[ProximityAlertTriggered]
    var video_chat_started: Optional[VideoChatStarted]
    var video_chat_ended: Optional[VideoChatEnded]
    var video_chat_participants_invited: Optional[VideoChatParticipantsInvited]
    var message_auto_delete_timer_changed: Optional[MessageAutoDeleteTimerChanged]
    var video_chat_scheduled: Optional[VideoChatScheduled]
    var web_app_data: Optional[WebAppData]
    var forum_topic_created: Optional[ForumTopicCreated]
    var forum_topic_edited: Optional[ForumTopicEdited]
    var write_access_allowed: Optional[WriteAccessAllowed]
    var chat_shared: Optional[ChatShared]
    var story: Optional[Story]
    var giveaway: Optional[Giveaway]
    var giveaway_completed: Optional[GiveawayCompleted]
    var giveaway_created: Optional[GiveawayCreated]
    var giveaway_winners: Optional[GiveawayWinners]
    var users_shared: Optional[UsersShared]
    var link_preview_options: Optional[LinkPreviewOptions]
    var external_reply: Optional[ExternalReplyInfo]
    var quote: Optional[TextQuote]
    var forward_origin: Optional[MessageOrigin]
    var reply_to_story: Optional[Story]
    var boost_added: Optional[ChatBoostAdded]
    var sender_business_bot: Optional[User]
    var paid_media: Optional[PaidMediaInfo]
    var refunded_payment: Optional[RefundedPayment]
    var gift: Optional[GiftInfo]
    var unique_gift: Optional[UniqueGiftInfo]
    var paid_message_price_changed: Optional[PaidMessagePriceChanged]
    var direct_message_price_changed: Optional[DirectMessagePriceChanged]
    var checklist: Optional[Checklist]
    var direct_messages_topic: Optional[DirectMessagesTopic]
    var gift_upgrade_sent: Optional[GiftInfo]
    var chat_owner_changed: Optional[ChatOwnerChanged]
    var chat_owner_left: Optional[ChatOwnerLeft]
    var poll_option_added: Optional[PollOptionAdded]
    var poll_option_deleted: Optional[PollOptionDeleted]
    var managed_bot_created: Optional[ManagedBotCreated]
    var guest_bot_caller_user: Optional[User]
    var guest_bot_caller_chat: Optional[Chat]
    var live_photo: Optional[LivePhoto]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        message_id: Int,
        date: TimestampDateTime,
        chat: Chat,
        from_user: Optional[User] = None,
        sender_chat: Optional[Chat] = None,
        text: Optional[String] = None,
        entities: List[MessageEntity] = List[MessageEntity](),
        caption: Optional[String] = None,
        caption_entities: List[MessageEntity] = List[MessageEntity](),
        edit_date: Optional[TimestampDateTime] = None,
        new_chat_title: Optional[String] = None,
        delete_chat_photo: Optional[Bool] = None,
        group_chat_created: Optional[Bool] = None,
        supergroup_chat_created: Optional[Bool] = None,
        channel_chat_created: Optional[Bool] = None,
        migrate_to_chat_id: Optional[Int] = None,
        migrate_from_chat_id: Optional[Int] = None,
        author_signature: Optional[String] = None,
        media_group_id: Optional[String] = None,
        connected_website: Optional[String] = None,
        is_automatic_forward: Optional[Bool] = None,
        has_protected_content: Optional[Bool] = None,
        is_topic_message: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        has_media_spoiler: Optional[Bool] = None,
        sender_boost_count: Optional[Int] = None,
        business_connection_id: Optional[String] = None,
        is_from_offline: Optional[Bool] = None,
        effect_id: Optional[String] = None,
        show_caption_above_media: Optional[Bool] = None,
        paid_star_count: Optional[Int] = None,
        is_paid_post: Optional[Bool] = None,
        reply_to_checklist_task_id: Optional[Int] = None,
        reply_to_poll_option_id: Optional[String] = None,
        sender_tag: Optional[String] = None,
        guest_query_id: Optional[String] = None,
        reply_to_message: Optional[JsonDocument] = None,
        audio: Optional[Audio] = None,
        document: Optional[Document] = None,
        game: Optional[Game] = None,
        photo: List[PhotoSize] = List[PhotoSize](),
        sticker: Optional[Sticker] = None,
        video: Optional[Video] = None,
        voice: Optional[Voice] = None,
        video_note: Optional[VideoNote] = None,
        new_chat_members: List[User] = List[User](),
        contact: Optional[Contact] = None,
        location: Optional[Location] = None,
        venue: Optional[Venue] = None,
        left_chat_member: Optional[User] = None,
        new_chat_photo: List[PhotoSize] = List[PhotoSize](),
        pinned_message: Optional[JsonDocument] = None,
        invoice: Optional[Invoice] = None,
        successful_payment: Optional[SuccessfulPayment] = None,
        animation: Optional[Animation] = None,
        poll: Optional[Poll] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        dice: Optional[Dice] = None,
        via_bot: Optional[User] = None,
        proximity_alert_triggered: Optional[ProximityAlertTriggered] = None,
        video_chat_started: Optional[VideoChatStarted] = None,
        video_chat_ended: Optional[VideoChatEnded] = None,
        video_chat_participants_invited: Optional[VideoChatParticipantsInvited] = None,
        message_auto_delete_timer_changed: Optional[MessageAutoDeleteTimerChanged] = None,
        video_chat_scheduled: Optional[VideoChatScheduled] = None,
        web_app_data: Optional[WebAppData] = None,
        forum_topic_created: Optional[ForumTopicCreated] = None,
        forum_topic_edited: Optional[ForumTopicEdited] = None,
        write_access_allowed: Optional[WriteAccessAllowed] = None,
        chat_shared: Optional[ChatShared] = None,
        story: Optional[Story] = None,
        giveaway: Optional[Giveaway] = None,
        giveaway_completed: Optional[GiveawayCompleted] = None,
        giveaway_created: Optional[GiveawayCreated] = None,
        giveaway_winners: Optional[GiveawayWinners] = None,
        users_shared: Optional[UsersShared] = None,
        link_preview_options: Optional[LinkPreviewOptions] = None,
        external_reply: Optional[ExternalReplyInfo] = None,
        quote: Optional[TextQuote] = None,
        forward_origin: Optional[MessageOrigin] = None,
        reply_to_story: Optional[Story] = None,
        boost_added: Optional[ChatBoostAdded] = None,
        sender_business_bot: Optional[User] = None,
        paid_media: Optional[PaidMediaInfo] = None,
        refunded_payment: Optional[RefundedPayment] = None,
        gift: Optional[GiftInfo] = None,
        unique_gift: Optional[UniqueGiftInfo] = None,
        paid_message_price_changed: Optional[PaidMessagePriceChanged] = None,
        direct_message_price_changed: Optional[DirectMessagePriceChanged] = None,
        checklist: Optional[Checklist] = None,
        direct_messages_topic: Optional[DirectMessagesTopic] = None,
        gift_upgrade_sent: Optional[GiftInfo] = None,
        chat_owner_changed: Optional[ChatOwnerChanged] = None,
        chat_owner_left: Optional[ChatOwnerLeft] = None,
        poll_option_added: Optional[PollOptionAdded] = None,
        poll_option_deleted: Optional[PollOptionDeleted] = None,
        managed_bot_created: Optional[ManagedBotCreated] = None,
        guest_bot_caller_user: Optional[User] = None,
        guest_bot_caller_chat: Optional[Chat] = None,
        live_photo: Optional[LivePhoto] = None,
    ):
        self.message_id = message_id
        self.date = date.copy()
        self.chat = chat.copy()
        self.from_user = from_user.copy()
        self.sender_chat = sender_chat.copy()
        self.text = text.copy()
        self.entities = entities.copy()
        self.caption = caption.copy()
        self.caption_entities = caption_entities.copy()
        self.edit_date = edit_date.copy()
        self.new_chat_title = new_chat_title.copy()
        self.delete_chat_photo = delete_chat_photo.copy()
        self.group_chat_created = group_chat_created.copy()
        self.supergroup_chat_created = supergroup_chat_created.copy()
        self.channel_chat_created = channel_chat_created.copy()
        self.migrate_to_chat_id = migrate_to_chat_id.copy()
        self.migrate_from_chat_id = migrate_from_chat_id.copy()
        self.author_signature = author_signature.copy()
        self.media_group_id = media_group_id.copy()
        self.connected_website = connected_website.copy()
        self.is_automatic_forward = is_automatic_forward.copy()
        self.has_protected_content = has_protected_content.copy()
        self.is_topic_message = is_topic_message.copy()
        self.message_thread_id = message_thread_id.copy()
        self.has_media_spoiler = has_media_spoiler.copy()
        self.sender_boost_count = sender_boost_count.copy()
        self.business_connection_id = business_connection_id.copy()
        self.is_from_offline = is_from_offline.copy()
        self.effect_id = effect_id.copy()
        self.show_caption_above_media = show_caption_above_media.copy()
        self.paid_star_count = paid_star_count.copy()
        self.is_paid_post = is_paid_post.copy()
        self.reply_to_checklist_task_id = reply_to_checklist_task_id.copy()
        self.reply_to_poll_option_id = reply_to_poll_option_id.copy()
        self.sender_tag = sender_tag.copy()
        self.guest_query_id = guest_query_id.copy()
        self.reply_to_message = reply_to_message.copy()
        self.audio = audio.copy()
        self.document = document.copy()
        self.game = game.copy()
        self.photo = photo.copy()
        self.sticker = sticker.copy()
        self.video = video.copy()
        self.voice = voice.copy()
        self.video_note = video_note.copy()
        self.new_chat_members = new_chat_members.copy()
        self.contact = contact.copy()
        self.location = location.copy()
        self.venue = venue.copy()
        self.left_chat_member = left_chat_member.copy()
        self.new_chat_photo = new_chat_photo.copy()
        self.pinned_message = pinned_message.copy()
        self.invoice = invoice.copy()
        self.successful_payment = successful_payment.copy()
        self.animation = animation.copy()
        self.poll = poll.copy()
        self.reply_markup = reply_markup.copy()
        self.dice = dice.copy()
        self.via_bot = via_bot.copy()
        self.proximity_alert_triggered = proximity_alert_triggered.copy()
        self.video_chat_started = video_chat_started.copy()
        self.video_chat_ended = video_chat_ended.copy()
        self.video_chat_participants_invited = video_chat_participants_invited.copy()
        self.message_auto_delete_timer_changed = message_auto_delete_timer_changed.copy()
        self.video_chat_scheduled = video_chat_scheduled.copy()
        self.web_app_data = web_app_data.copy()
        self.forum_topic_created = forum_topic_created.copy()
        self.forum_topic_edited = forum_topic_edited.copy()
        self.write_access_allowed = write_access_allowed.copy()
        self.chat_shared = chat_shared.copy()
        self.story = story.copy()
        self.giveaway = giveaway.copy()
        self.giveaway_completed = giveaway_completed.copy()
        self.giveaway_created = giveaway_created.copy()
        self.giveaway_winners = giveaway_winners.copy()
        self.users_shared = users_shared.copy()
        self.link_preview_options = link_preview_options.copy()
        self.external_reply = external_reply.copy()
        self.quote = quote.copy()
        self.forward_origin = forward_origin.copy()
        self.reply_to_story = reply_to_story.copy()
        self.boost_added = boost_added.copy()
        self.sender_business_bot = sender_business_bot.copy()
        self.paid_media = paid_media.copy()
        self.refunded_payment = refunded_payment.copy()
        self.gift = gift.copy()
        self.unique_gift = unique_gift.copy()
        self.paid_message_price_changed = paid_message_price_changed.copy()
        self.direct_message_price_changed = direct_message_price_changed.copy()
        self.checklist = checklist.copy()
        self.direct_messages_topic = direct_messages_topic.copy()
        self.gift_upgrade_sent = gift_upgrade_sent.copy()
        self.chat_owner_changed = chat_owner_changed.copy()
        self.chat_owner_left = chat_owner_left.copy()
        self.poll_option_added = poll_option_added.copy()
        self.poll_option_deleted = poll_option_deleted.copy()
        self.managed_bot_created = managed_bot_created.copy()
        self.guest_bot_caller_user = guest_bot_caller_user.copy()
        self.guest_bot_caller_chat = guest_bot_caller_chat.copy()
        self.live_photo = live_photo.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        message_id: Int,
        date: TimestampDateTime,
        chat: Chat,
        from_user: Optional[User] = None,
        sender_chat: Optional[Chat] = None,
        text: Optional[String] = None,
        entities: List[MessageEntity] = List[MessageEntity](),
        caption: Optional[String] = None,
        caption_entities: List[MessageEntity] = List[MessageEntity](),
        edit_date: Optional[TimestampDateTime] = None,
        new_chat_title: Optional[String] = None,
        delete_chat_photo: Optional[Bool] = None,
        group_chat_created: Optional[Bool] = None,
        supergroup_chat_created: Optional[Bool] = None,
        channel_chat_created: Optional[Bool] = None,
        migrate_to_chat_id: Optional[Int] = None,
        migrate_from_chat_id: Optional[Int] = None,
        author_signature: Optional[String] = None,
        media_group_id: Optional[String] = None,
        connected_website: Optional[String] = None,
        is_automatic_forward: Optional[Bool] = None,
        has_protected_content: Optional[Bool] = None,
        is_topic_message: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        has_media_spoiler: Optional[Bool] = None,
        sender_boost_count: Optional[Int] = None,
        business_connection_id: Optional[String] = None,
        is_from_offline: Optional[Bool] = None,
        effect_id: Optional[String] = None,
        show_caption_above_media: Optional[Bool] = None,
        paid_star_count: Optional[Int] = None,
        is_paid_post: Optional[Bool] = None,
        reply_to_checklist_task_id: Optional[Int] = None,
        reply_to_poll_option_id: Optional[String] = None,
        sender_tag: Optional[String] = None,
        guest_query_id: Optional[String] = None,
        reply_to_message: Optional[JsonDocument] = None,
        audio: Optional[Audio] = None,
        document: Optional[Document] = None,
        game: Optional[Game] = None,
        photo: List[PhotoSize] = List[PhotoSize](),
        sticker: Optional[Sticker] = None,
        video: Optional[Video] = None,
        voice: Optional[Voice] = None,
        video_note: Optional[VideoNote] = None,
        new_chat_members: List[User] = List[User](),
        contact: Optional[Contact] = None,
        location: Optional[Location] = None,
        venue: Optional[Venue] = None,
        left_chat_member: Optional[User] = None,
        new_chat_photo: List[PhotoSize] = List[PhotoSize](),
        pinned_message: Optional[JsonDocument] = None,
        invoice: Optional[Invoice] = None,
        successful_payment: Optional[SuccessfulPayment] = None,
        animation: Optional[Animation] = None,
        poll: Optional[Poll] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        dice: Optional[Dice] = None,
        via_bot: Optional[User] = None,
        proximity_alert_triggered: Optional[ProximityAlertTriggered] = None,
        video_chat_started: Optional[VideoChatStarted] = None,
        video_chat_ended: Optional[VideoChatEnded] = None,
        video_chat_participants_invited: Optional[VideoChatParticipantsInvited] = None,
        message_auto_delete_timer_changed: Optional[MessageAutoDeleteTimerChanged] = None,
        video_chat_scheduled: Optional[VideoChatScheduled] = None,
        web_app_data: Optional[WebAppData] = None,
        forum_topic_created: Optional[ForumTopicCreated] = None,
        forum_topic_edited: Optional[ForumTopicEdited] = None,
        write_access_allowed: Optional[WriteAccessAllowed] = None,
        chat_shared: Optional[ChatShared] = None,
        story: Optional[Story] = None,
        giveaway: Optional[Giveaway] = None,
        giveaway_completed: Optional[GiveawayCompleted] = None,
        giveaway_created: Optional[GiveawayCreated] = None,
        giveaway_winners: Optional[GiveawayWinners] = None,
        users_shared: Optional[UsersShared] = None,
        link_preview_options: Optional[LinkPreviewOptions] = None,
        external_reply: Optional[ExternalReplyInfo] = None,
        quote: Optional[TextQuote] = None,
        forward_origin: Optional[MessageOrigin] = None,
        reply_to_story: Optional[Story] = None,
        boost_added: Optional[ChatBoostAdded] = None,
        sender_business_bot: Optional[User] = None,
        paid_media: Optional[PaidMediaInfo] = None,
        refunded_payment: Optional[RefundedPayment] = None,
        gift: Optional[GiftInfo] = None,
        unique_gift: Optional[UniqueGiftInfo] = None,
        paid_message_price_changed: Optional[PaidMessagePriceChanged] = None,
        direct_message_price_changed: Optional[DirectMessagePriceChanged] = None,
        checklist: Optional[Checklist] = None,
        direct_messages_topic: Optional[DirectMessagesTopic] = None,
        gift_upgrade_sent: Optional[GiftInfo] = None,
        chat_owner_changed: Optional[ChatOwnerChanged] = None,
        chat_owner_left: Optional[ChatOwnerLeft] = None,
        poll_option_added: Optional[PollOptionAdded] = None,
        poll_option_deleted: Optional[PollOptionDeleted] = None,
        managed_bot_created: Optional[ManagedBotCreated] = None,
        guest_bot_caller_user: Optional[User] = None,
        guest_bot_caller_chat: Optional[Chat] = None,
        live_photo: Optional[LivePhoto] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.message_id = message_id
        self.date = date.copy()
        self.chat = chat.copy()
        self.from_user = from_user.copy()
        self.sender_chat = sender_chat.copy()
        self.text = text.copy()
        self.entities = entities.copy()
        self.caption = caption.copy()
        self.caption_entities = caption_entities.copy()
        self.edit_date = edit_date.copy()
        self.new_chat_title = new_chat_title.copy()
        self.delete_chat_photo = delete_chat_photo.copy()
        self.group_chat_created = group_chat_created.copy()
        self.supergroup_chat_created = supergroup_chat_created.copy()
        self.channel_chat_created = channel_chat_created.copy()
        self.migrate_to_chat_id = migrate_to_chat_id.copy()
        self.migrate_from_chat_id = migrate_from_chat_id.copy()
        self.author_signature = author_signature.copy()
        self.media_group_id = media_group_id.copy()
        self.connected_website = connected_website.copy()
        self.is_automatic_forward = is_automatic_forward.copy()
        self.has_protected_content = has_protected_content.copy()
        self.is_topic_message = is_topic_message.copy()
        self.message_thread_id = message_thread_id.copy()
        self.has_media_spoiler = has_media_spoiler.copy()
        self.sender_boost_count = sender_boost_count.copy()
        self.business_connection_id = business_connection_id.copy()
        self.is_from_offline = is_from_offline.copy()
        self.effect_id = effect_id.copy()
        self.show_caption_above_media = show_caption_above_media.copy()
        self.paid_star_count = paid_star_count.copy()
        self.is_paid_post = is_paid_post.copy()
        self.reply_to_checklist_task_id = reply_to_checklist_task_id.copy()
        self.reply_to_poll_option_id = reply_to_poll_option_id.copy()
        self.sender_tag = sender_tag.copy()
        self.guest_query_id = guest_query_id.copy()
        self.reply_to_message = reply_to_message.copy()
        self.audio = audio.copy()
        self.document = document.copy()
        self.game = game.copy()
        self.photo = photo.copy()
        self.sticker = sticker.copy()
        self.video = video.copy()
        self.voice = voice.copy()
        self.video_note = video_note.copy()
        self.new_chat_members = new_chat_members.copy()
        self.contact = contact.copy()
        self.location = location.copy()
        self.venue = venue.copy()
        self.left_chat_member = left_chat_member.copy()
        self.new_chat_photo = new_chat_photo.copy()
        self.pinned_message = pinned_message.copy()
        self.invoice = invoice.copy()
        self.successful_payment = successful_payment.copy()
        self.animation = animation.copy()
        self.poll = poll.copy()
        self.reply_markup = reply_markup.copy()
        self.dice = dice.copy()
        self.via_bot = via_bot.copy()
        self.proximity_alert_triggered = proximity_alert_triggered.copy()
        self.video_chat_started = video_chat_started.copy()
        self.video_chat_ended = video_chat_ended.copy()
        self.video_chat_participants_invited = video_chat_participants_invited.copy()
        self.message_auto_delete_timer_changed = message_auto_delete_timer_changed.copy()
        self.video_chat_scheduled = video_chat_scheduled.copy()
        self.web_app_data = web_app_data.copy()
        self.forum_topic_created = forum_topic_created.copy()
        self.forum_topic_edited = forum_topic_edited.copy()
        self.write_access_allowed = write_access_allowed.copy()
        self.chat_shared = chat_shared.copy()
        self.story = story.copy()
        self.giveaway = giveaway.copy()
        self.giveaway_completed = giveaway_completed.copy()
        self.giveaway_created = giveaway_created.copy()
        self.giveaway_winners = giveaway_winners.copy()
        self.users_shared = users_shared.copy()
        self.link_preview_options = link_preview_options.copy()
        self.external_reply = external_reply.copy()
        self.quote = quote.copy()
        self.forward_origin = forward_origin.copy()
        self.reply_to_story = reply_to_story.copy()
        self.boost_added = boost_added.copy()
        self.sender_business_bot = sender_business_bot.copy()
        self.paid_media = paid_media.copy()
        self.refunded_payment = refunded_payment.copy()
        self.gift = gift.copy()
        self.unique_gift = unique_gift.copy()
        self.paid_message_price_changed = paid_message_price_changed.copy()
        self.direct_message_price_changed = direct_message_price_changed.copy()
        self.checklist = checklist.copy()
        self.direct_messages_topic = direct_messages_topic.copy()
        self.gift_upgrade_sent = gift_upgrade_sent.copy()
        self.chat_owner_changed = chat_owner_changed.copy()
        self.chat_owner_left = chat_owner_left.copy()
        self.poll_option_added = poll_option_added.copy()
        self.poll_option_deleted = poll_option_deleted.copy()
        self.managed_bot_created = managed_bot_created.copy()
        self.guest_bot_caller_user = guest_bot_caller_user.copy()
        self.guest_bot_caller_chat = guest_bot_caller_chat.copy()
        self.live_photo = live_photo.copy()
        self.api_kwargs = api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_id == other.message_id and self.chat == other.chat

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.message_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.chat)).as_bytes())

    def chat_id(self) -> Int:
        return self.chat.id

    def id(self) -> Int:
        return self.message_id

    def is_accessible(self) raises -> Bool:
        """Whether this message has a nonzero Bot API date."""
        return self.date != from_timestamp(0)

    def link(self) raises -> Optional[String]:
        """Return the t.me link for a non-private, non-group chat message."""
        var chat_type = self.chat.type()
        if chat_type == Chat.PRIVATE or chat_type == Chat.GROUP:
            return None

        var target: String
        if self.chat.username is not None and self.chat.username.value().byte_length() > 0:
            target = self.chat.username.value().copy()
        else:
            # Match PTB's str(chat.id)[4:] fallback for username-less supergroups/channels.
            var id_text = String(self.chat.id)
            var index = 0
            var suffix = String()
            for character in id_text.codepoint_slices():
                if index >= 4:
                    suffix.write_string(character)
                index += 1
            target = String("c/", suffix)

        var result = String("https://t.me/", target, "/", self.message_id)
        var is_topic = False
        if self.is_topic_message is not None:
            is_topic = self.is_topic_message.value()
        var has_thread = self.message_thread_id is not None
        var is_reply = self.reply_to_message is not None
        if (is_topic and has_thread and self.message_thread_id.value() != 0) or is_reply:
            result += "?thread="
            if has_thread:
                result += String(self.message_thread_id.value())
            else:
                result += "None"
        return Optional[String](result^)

    def parse_entity(self, entity: MessageEntity) raises -> String:
        if self.text is None:
            raise Error("This Message has no 'text'.")
        return parse_message_entity(self.text.value(), entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        if self.text is None:
            raise Error("This Message has no 'text'.")
        return parse_message_entities(self.text.value(), self.entities, types)

    def parse_caption_entity(self, entity: MessageEntity) raises -> String:
        if self.caption is None:
            raise Error("This Message has no 'caption'.")
        return parse_message_entity(self.caption.value(), entity)

    def parse_caption_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        if self.caption is None:
            raise Error("This Message has no 'caption'.")
        return parse_message_entities(self.caption.value(), self.caption_entities, types)

    def effective_attachment(self) raises -> Optional[MessageAttachment]:
        """Return the first attachment in upstream ``MessageAttachmentType`` order."""
        var attachment_types = List[String]()
        attachment_types.append("animation")
        attachment_types.append("audio")
        attachment_types.append("contact")
        attachment_types.append("dice")
        attachment_types.append("document")
        attachment_types.append("game")
        attachment_types.append("invoice")
        attachment_types.append("live_photo")
        attachment_types.append("location")
        attachment_types.append("paid_media")
        attachment_types.append("passport_data")
        attachment_types.append("photo")
        attachment_types.append("poll")
        attachment_types.append("sticker")
        attachment_types.append("story")
        attachment_types.append("successful_payment")
        attachment_types.append("video")
        attachment_types.append("video_note")
        attachment_types.append("voice")
        attachment_types.append("venue")
        for attachment_type in attachment_types:
            var typed_attachment: Optional[MessageAttachment] = None
            if attachment_type == "animation":
                typed_attachment = _message_attachment_model[Animation](attachment_type, self.animation)
            elif attachment_type == "audio":
                typed_attachment = _message_attachment_model[Audio](attachment_type, self.audio)
            elif attachment_type == "contact":
                typed_attachment = _message_attachment_model[Contact](attachment_type, self.contact)
            elif attachment_type == "dice":
                typed_attachment = _message_attachment_model[Dice](attachment_type, self.dice)
            elif attachment_type == "document":
                typed_attachment = _message_attachment_model[Document](attachment_type, self.document)
            elif attachment_type == "game":
                typed_attachment = _message_attachment_model[Game](attachment_type, self.game)
            elif attachment_type == "invoice":
                typed_attachment = _message_attachment_model[Invoice](attachment_type, self.invoice)
            elif attachment_type == "location":
                typed_attachment = _message_attachment_model[Location](attachment_type, self.location)
            elif attachment_type == "live_photo":
                typed_attachment = _message_attachment_model[LivePhoto](attachment_type, self.live_photo)
            elif attachment_type == "photo" and len(self.photo) > 0:
                return Optional[MessageAttachment](
                    MessageAttachment(attachment_type, _message_model_list_document(self.photo))
                )
            elif attachment_type == "poll":
                typed_attachment = _message_attachment_model[Poll](attachment_type, self.poll)
            elif attachment_type == "paid_media":
                typed_attachment = _message_attachment_model[PaidMediaInfo](attachment_type, self.paid_media)
            elif attachment_type == "sticker":
                typed_attachment = _message_attachment_model[Sticker](attachment_type, self.sticker)
            elif attachment_type == "story":
                typed_attachment = _message_attachment_model[Story](attachment_type, self.story)
            elif attachment_type == "successful_payment":
                typed_attachment = _message_attachment_model[SuccessfulPayment](attachment_type, self.successful_payment)
            elif attachment_type == "video":
                typed_attachment = _message_attachment_model[Video](attachment_type, self.video)
            elif attachment_type == "video_note":
                typed_attachment = _message_attachment_model[VideoNote](attachment_type, self.video_note)
            elif attachment_type == "voice":
                typed_attachment = _message_attachment_model[Voice](attachment_type, self.voice)
            elif attachment_type == "venue":
                typed_attachment = _message_attachment_model[Venue](attachment_type, self.venue)
            if typed_attachment is not None:
                return typed_attachment.copy()
            var index = self.api_kwargs.object_get(self.api_kwargs.root, attachment_type)
            if index == -1 or self.api_kwargs.is_null(index):
                continue
            if attachment_type == "photo" and self.api_kwargs.nodes[index].kind == JSON_ARRAY:
                if len(self.api_kwargs.array_documents(index)) == 0:
                    continue
            var payload = _message_nested(self.api_kwargs, index)
            return Optional[MessageAttachment](MessageAttachment(attachment_type, payload))
        return None

    def compute_quote_position_and_entities(
        self, quote: String, index: Optional[Int] = None
    ) raises -> Tuple[Int, Optional[List[MessageEntity]]]:
        """Find a quote and clip overlapping entities using Telegram UTF-16 offsets."""
        var text: String
        if self.text is not None and self.text.value().byte_length() > 0:
            text = self.text.value().copy()
        elif self.caption is not None and self.caption.value().byte_length() > 0:
            text = self.caption.value().copy()
        else:
            raise Error("This message has neither text nor caption.")

        var positions = _message_quote_positions(text, quote)
        var requested_index = 0
        if index is not None:
            requested_index = index.value()
        var effective_index = requested_index
        if effective_index < 0:
            effective_index += len(positions)
        if effective_index < 0 or effective_index >= len(positions):
            var index_description = String("None")
            if index is not None:
                index_description = String(requested_index)
            raise Error(
                String(
                    "You requested the ",
                    index_description,
                    "-th occurrence of '",
                    quote,
                    "', but this text appears only ",
                    len(positions),
                    " times.",
                )
            )

        var position = positions[effective_index]
        var quote_length = 0
        for codepoint in _message_codepoints(quote):
            quote_length += _message_utf16_width(codepoint)
        var end_position = position + quote_length
        var source_entities = self.entities.copy()
        if len(source_entities) == 0:
            source_entities = self.caption_entities.copy()
        var quote_entities = List[MessageEntity]()
        for entity in source_entities:
            var entity_end = entity.offset + entity.length
            if position <= entity_end and entity.offset <= end_position:
                var entity_start = position
                if entity.offset > entity_start:
                    entity_start = entity.offset
                var overlap_end = end_position
                if entity_end < overlap_end:
                    overlap_end = entity_end
                var clipped_length = overlap_end - entity_start
                if clipped_length <= 0:
                    continue
                var clipped_offset = entity.offset - position
                if clipped_offset < 0:
                    clipped_offset = 0
                quote_entities.append(
                    MessageEntity(
                        entity.type,
                        clipped_offset,
                        clipped_length,
                        entity.url,
                        entity.user,
                        entity.language,
                        entity.custom_emoji_id,
                        entity.date_time_format,
                        entity.unix_time,
                        api_kwargs=entity.api_kwargs.copy(),
                    )
                )
        var maybe_entities: Optional[List[MessageEntity]] = None
        if len(quote_entities) > 0:
            maybe_entities = Optional[List[MessageEntity]](quote_entities^)
        return (position, maybe_entities^)

    def build_reply_arguments(
        self,
        quote: Optional[String] = None,
        quote_index: Optional[Int] = None,
        target_chat_id: Optional[ChatIdentifier] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
    ) raises -> MessageReplyArguments:
        """Build native chat and ReplyParameters values for replying to this message."""
        var target_is_self = target_chat_id is None
        var resolved_chat_id = ChatIdentifier(self.chat.id)
        if target_chat_id is not None:
            var target = target_chat_id.value().copy()
            var target_is_truthy = target.username.byte_length() > 0 or target.number != 0
            if target_is_truthy:
                resolved_chat_id = target.copy()
            if target.username.byte_length() > 0:
                if self.chat.username is not None:
                    target_is_self = (
                        target.username == String("@", self.chat.username.value())
                    )
            else:
                target_is_self = target.number == self.chat.id

        var current_thread_id = self.message_thread_id.copy()
        var same_thread = message_thread_id is None and current_thread_id is None
        if message_thread_id is not None and current_thread_id is not None:
            same_thread = message_thread_id.value() == current_thread_id.value()
        var effective_allow_sending_without_reply: Optional[Bool] = None
        if target_is_self and same_thread:
            effective_allow_sending_without_reply = allow_sending_without_reply.copy()

        var reply_parameters = ReplyParameters(self.message_id)
        if not target_is_self:
            reply_parameters.set_chat_id_number(self.chat.id)
        reply_parameters.allow_sending_without_reply = effective_allow_sending_without_reply
        if quote is not None:
            reply_parameters.quote = quote.copy()
            if quote.value().byte_length() > 0:
                var quote_result = self.compute_quote_position_and_entities(
                    quote.value(), quote_index
                )
                reply_parameters.quote_position = Optional[Int](quote_result[0])
                if quote_result[1] is not None:
                    reply_parameters.has_quote_entities = True
                    reply_parameters.quote_entities = quote_result[1].value().copy()

        return MessageReplyArguments(resolved_chat_id, reply_parameters)

    def extract_direct_messages_topic_id(self) raises -> Optional[Int]:
        if self.direct_messages_topic is None:
            return None
        return Optional[Int](self.direct_messages_topic.value().topic_id)

    def parse_message_thread_id(
        self,
        chat_id: ChatIdentifier,
        message_thread_id: Optional[Int] = None,
    ) raises -> Optional[Int]:
        """Resolve a send-method thread ID using this message's topic and target chat."""
        if message_thread_id is not None:
            return message_thread_id.copy()
        var is_topic = self.is_topic_message.copy()
        if is_topic is None or not is_topic.value():
            return None

        var same_chat = False
        if chat_id.username.byte_length() == 0:
            same_chat = chat_id.number == self.chat.id
        elif self.chat.username is not None:
            same_chat = (
                chat_id.username == self.chat.username.value()
                or chat_id.username == String("@", self.chat.username.value())
            )
        if not same_chat:
            return None
        return self.message_thread_id.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "message_id", String(self.message_id))
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        var chat_data = self.chat.to_dict(recursive=recursive)
        var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_index)
        if self.from_user is not None:
            var user_data = self.from_user.value().to_dict(recursive=recursive)
            var user_index = result.copy_subtree_from(user_data, user_data.root)
            result.object_set(result.root, "from", user_index)
        if self.sender_chat is not None:
            var sender_chat_data = self.sender_chat.value().to_dict(recursive=recursive)
            var sender_chat_index = result.copy_subtree_from(
                sender_chat_data, sender_chat_data.root
            )
            result.object_set(result.root, "sender_chat", sender_chat_index)
        if self.text is not None:
            result.set_string(result.root, "text", self.text.value())
        _message_entities_to_json(result, "entities", self.entities, recursive)
        if self.caption is not None:
            result.set_string(result.root, "caption", self.caption.value())
        _message_entities_to_json(result, "caption_entities", self.caption_entities, recursive)
        if self.edit_date is not None:
            result.set_number(
                result.root,
                "edit_date",
                String(to_timestamp(self.edit_date.value())),
            )
        _message_set_optional_string(result, "new_chat_title", self.new_chat_title)
        _message_set_optional_bool(result, "delete_chat_photo", self.delete_chat_photo)
        _message_set_optional_bool(result, "group_chat_created", self.group_chat_created)
        _message_set_optional_bool(
            result, "supergroup_chat_created", self.supergroup_chat_created
        )
        _message_set_optional_bool(result, "channel_chat_created", self.channel_chat_created)
        _message_set_optional_int(result, "migrate_to_chat_id", self.migrate_to_chat_id)
        _message_set_optional_int(result, "migrate_from_chat_id", self.migrate_from_chat_id)
        _message_set_optional_string(result, "author_signature", self.author_signature)
        _message_set_optional_string(result, "media_group_id", self.media_group_id)
        _message_set_optional_string(result, "connected_website", self.connected_website)
        _message_set_optional_bool(
            result, "is_automatic_forward", self.is_automatic_forward
        )
        _message_set_optional_bool(
            result, "has_protected_content", self.has_protected_content
        )
        _message_set_optional_bool(result, "is_topic_message", self.is_topic_message)
        _message_set_optional_int(result, "message_thread_id", self.message_thread_id)
        _message_set_optional_bool(result, "has_media_spoiler", self.has_media_spoiler)
        _message_set_optional_int(result, "sender_boost_count", self.sender_boost_count)
        _message_set_optional_string(
            result, "business_connection_id", self.business_connection_id
        )
        _message_set_optional_bool(result, "is_from_offline", self.is_from_offline)
        _message_set_optional_string(result, "effect_id", self.effect_id)
        _message_set_optional_bool(
            result, "show_caption_above_media", self.show_caption_above_media
        )
        _message_set_optional_int(result, "paid_star_count", self.paid_star_count)
        _message_set_optional_bool(result, "is_paid_post", self.is_paid_post)
        _message_set_optional_int(
            result, "reply_to_checklist_task_id", self.reply_to_checklist_task_id
        )
        _message_set_optional_string(
            result, "reply_to_poll_option_id", self.reply_to_poll_option_id
        )
        _message_set_optional_string(result, "sender_tag", self.sender_tag)
        _message_set_optional_string(result, "guest_query_id", self.guest_query_id)
        _message_set_optional_document(result, "reply_to_message", self.reply_to_message)
        _message_set_optional_model(result, "audio", self.audio, recursive)
        _message_set_optional_model(result, "document", self.document, recursive)
        _message_set_optional_model(result, "game", self.game, recursive)
        _message_set_model_list(result, "photo", self.photo, recursive)
        _message_set_optional_model(result, "sticker", self.sticker, recursive)
        _message_set_optional_model(result, "video", self.video, recursive)
        _message_set_optional_model(result, "voice", self.voice, recursive)
        _message_set_optional_model(result, "video_note", self.video_note, recursive)
        _message_set_model_list(result, "new_chat_members", self.new_chat_members, recursive)
        _message_set_optional_model(result, "contact", self.contact, recursive)
        _message_set_optional_model(result, "location", self.location, recursive)
        _message_set_optional_model(result, "venue", self.venue, recursive)
        _message_set_optional_model(result, "left_chat_member", self.left_chat_member, recursive)
        _message_set_model_list(result, "new_chat_photo", self.new_chat_photo, recursive)
        _message_set_optional_document(result, "pinned_message", self.pinned_message)
        _message_set_optional_model(result, "invoice", self.invoice, recursive)
        _message_set_optional_model(result, "successful_payment", self.successful_payment, recursive)
        _message_set_optional_model(result, "animation", self.animation, recursive)
        _message_set_optional_model(result, "poll", self.poll, recursive)
        _message_set_optional_model(result, "reply_markup", self.reply_markup, recursive)
        _message_set_optional_model(result, "dice", self.dice, recursive)
        _message_set_optional_model(result, "via_bot", self.via_bot, recursive)
        _message_set_optional_model(result, "proximity_alert_triggered", self.proximity_alert_triggered, recursive)
        _message_set_optional_model(result, "video_chat_started", self.video_chat_started, recursive)
        _message_set_optional_model(result, "video_chat_ended", self.video_chat_ended, recursive)
        _message_set_optional_model(result, "video_chat_participants_invited", self.video_chat_participants_invited, recursive)
        _message_set_optional_model(result, "message_auto_delete_timer_changed", self.message_auto_delete_timer_changed, recursive)
        _message_set_optional_model(result, "video_chat_scheduled", self.video_chat_scheduled, recursive)
        _message_set_optional_model(result, "web_app_data", self.web_app_data, recursive)
        _message_set_optional_model(result, "forum_topic_created", self.forum_topic_created, recursive)
        _message_set_optional_model(result, "forum_topic_edited", self.forum_topic_edited, recursive)
        _message_set_optional_model(result, "write_access_allowed", self.write_access_allowed, recursive)
        _message_set_optional_model(result, "chat_shared", self.chat_shared, recursive)
        _message_set_optional_model(result, "story", self.story, recursive)
        _message_set_optional_model(result, "giveaway", self.giveaway, recursive)
        _message_set_optional_model(result, "giveaway_completed", self.giveaway_completed, recursive)
        _message_set_optional_model(result, "giveaway_created", self.giveaway_created, recursive)
        _message_set_optional_model(result, "giveaway_winners", self.giveaway_winners, recursive)
        _message_set_optional_model(result, "users_shared", self.users_shared, recursive)
        _message_set_optional_model(result, "link_preview_options", self.link_preview_options, recursive)
        _message_set_optional_model(result, "external_reply", self.external_reply, recursive)
        _message_set_optional_model(result, "quote", self.quote, recursive)
        _message_set_optional_model(result, "forward_origin", self.forward_origin, recursive)
        _message_set_optional_model(result, "reply_to_story", self.reply_to_story, recursive)
        _message_set_optional_model(result, "boost_added", self.boost_added, recursive)
        _message_set_optional_model(result, "sender_business_bot", self.sender_business_bot, recursive)
        _message_set_optional_model(result, "paid_media", self.paid_media, recursive)
        _message_set_optional_model(result, "refunded_payment", self.refunded_payment, recursive)
        _message_set_optional_model(result, "gift", self.gift, recursive)
        _message_set_optional_model(result, "unique_gift", self.unique_gift, recursive)
        _message_set_optional_model(result, "paid_message_price_changed", self.paid_message_price_changed, recursive)
        _message_set_optional_model(result, "direct_message_price_changed", self.direct_message_price_changed, recursive)
        _message_set_optional_model(result, "checklist", self.checklist, recursive)
        _message_set_optional_model(result, "direct_messages_topic", self.direct_messages_topic, recursive)
        _message_set_optional_model(result, "gift_upgrade_sent", self.gift_upgrade_sent, recursive)
        _message_set_optional_model(result, "chat_owner_changed", self.chat_owner_changed, recursive)
        _message_set_optional_model(result, "chat_owner_left", self.chat_owner_left, recursive)
        _message_set_optional_model(result, "poll_option_added", self.poll_option_added, recursive)
        _message_set_optional_model(result, "poll_option_deleted", self.poll_option_deleted, recursive)
        _message_set_optional_model(result, "managed_bot_created", self.managed_bot_created, recursive)
        _message_set_optional_model(result, "guest_bot_caller_user", self.guest_bot_caller_user, recursive)
        _message_set_optional_model(result, "guest_bot_caller_chat", self.guest_bot_caller_chat, recursive)
        _message_set_optional_model(result, "live_photo", self.live_photo, recursive)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Message:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Message JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Message JSON value is not an object")
        var message_id_index = data.object_get(data.root, "message_id")
        var date_index = data.object_get(data.root, "date")
        var chat_index = data.object_get(data.root, "chat")
        if message_id_index == -1 or date_index == -1 or chat_index == -1:
            raise Error("Message JSON object is missing a required field")
        var message_id = data.integer_value(message_id_index)
        var date = from_timestamp(data.integer_value(date_index))
        var chat = Chat.de_json(_message_nested(data, chat_index))

        var from_user: Optional[User] = None
        var from_index = data.object_get(data.root, "from")
        if from_index != -1 and not data.is_null(from_index):
            from_user = Optional[User](User.de_json(_message_nested(data, from_index)))
        var sender_chat: Optional[Chat] = None
        var sender_chat_index = data.object_get(data.root, "sender_chat")
        if sender_chat_index != -1 and not data.is_null(sender_chat_index):
            sender_chat = Optional[Chat](Chat.de_json(_message_nested(data, sender_chat_index)))

        var text = _message_optional_string(data, "text")
        var entities = _message_entities(data, "entities")
        var caption = _message_optional_string(data, "caption")
        var caption_entities = _message_entities(data, "caption_entities")

        return Message(
            message_id,
            date,
            chat,
            from_user,
            sender_chat,
            text,
            entities,
            caption,
            caption_entities,
            edit_date=_message_optional_datetime(data, "edit_date"),
            new_chat_title=_message_optional_string(data, "new_chat_title"),
            delete_chat_photo=_message_optional_bool(data, "delete_chat_photo"),
            group_chat_created=_message_optional_bool(data, "group_chat_created"),
            supergroup_chat_created=_message_optional_bool(data, "supergroup_chat_created"),
            channel_chat_created=_message_optional_bool(data, "channel_chat_created"),
            migrate_to_chat_id=_message_optional_int(data, "migrate_to_chat_id"),
            migrate_from_chat_id=_message_optional_int(data, "migrate_from_chat_id"),
            author_signature=_message_optional_string(data, "author_signature"),
            media_group_id=_message_optional_string(data, "media_group_id"),
            connected_website=_message_optional_string(data, "connected_website"),
            is_automatic_forward=_message_optional_bool(data, "is_automatic_forward"),
            has_protected_content=_message_optional_bool(data, "has_protected_content"),
            is_topic_message=_message_optional_bool(data, "is_topic_message"),
            message_thread_id=_message_optional_int(data, "message_thread_id"),
            has_media_spoiler=_message_optional_bool(data, "has_media_spoiler"),
            sender_boost_count=_message_optional_int(data, "sender_boost_count"),
            business_connection_id=_message_optional_string(data, "business_connection_id"),
            is_from_offline=_message_optional_bool(data, "is_from_offline"),
            effect_id=_message_optional_string(data, "effect_id"),
            show_caption_above_media=_message_optional_bool(data, "show_caption_above_media"),
            paid_star_count=_message_optional_int(data, "paid_star_count"),
            is_paid_post=_message_optional_bool(data, "is_paid_post"),
            reply_to_checklist_task_id=_message_optional_int(
                data, "reply_to_checklist_task_id"
            ),
            reply_to_poll_option_id=_message_optional_string(data, "reply_to_poll_option_id"),
            sender_tag=_message_optional_string(data, "sender_tag"),
            guest_query_id=_message_optional_string(data, "guest_query_id"),
            reply_to_message=_message_optional_document(data, "reply_to_message"),
            audio=_message_optional_model[Audio](data, "audio"),
            document=_message_optional_model[Document](data, "document"),
            game=_message_optional_model[Game](data, "game"),
            photo=_message_model_list[PhotoSize](data, "photo"),
            sticker=_message_optional_model[Sticker](data, "sticker"),
            video=_message_optional_model[Video](data, "video"),
            voice=_message_optional_model[Voice](data, "voice"),
            video_note=_message_optional_model[VideoNote](data, "video_note"),
            new_chat_members=_message_model_list[User](data, "new_chat_members"),
            contact=_message_optional_model[Contact](data, "contact"),
            location=_message_optional_model[Location](data, "location"),
            venue=_message_optional_model[Venue](data, "venue"),
            left_chat_member=_message_optional_model[User](data, "left_chat_member"),
            new_chat_photo=_message_model_list[PhotoSize](data, "new_chat_photo"),
            pinned_message=_message_optional_document(data, "pinned_message"),
            invoice=_message_optional_model[Invoice](data, "invoice"),
            successful_payment=_message_optional_model[SuccessfulPayment](data, "successful_payment"),
            animation=_message_optional_model[Animation](data, "animation"),
            poll=_message_optional_model[Poll](data, "poll"),
            reply_markup=_message_optional_model[InlineKeyboardMarkup](data, "reply_markup"),
            dice=_message_optional_model[Dice](data, "dice"),
            via_bot=_message_optional_model[User](data, "via_bot"),
            proximity_alert_triggered=_message_optional_model[ProximityAlertTriggered](data, "proximity_alert_triggered"),
            video_chat_started=_message_optional_model[VideoChatStarted](data, "video_chat_started"),
            video_chat_ended=_message_optional_model[VideoChatEnded](data, "video_chat_ended"),
            video_chat_participants_invited=_message_optional_model[VideoChatParticipantsInvited](data, "video_chat_participants_invited"),
            message_auto_delete_timer_changed=_message_optional_model[MessageAutoDeleteTimerChanged](data, "message_auto_delete_timer_changed"),
            video_chat_scheduled=_message_optional_model[VideoChatScheduled](data, "video_chat_scheduled"),
            web_app_data=_message_optional_model[WebAppData](data, "web_app_data"),
            forum_topic_created=_message_optional_model[ForumTopicCreated](data, "forum_topic_created"),
            forum_topic_edited=_message_optional_model[ForumTopicEdited](data, "forum_topic_edited"),
            write_access_allowed=_message_optional_model[WriteAccessAllowed](data, "write_access_allowed"),
            chat_shared=_message_optional_model[ChatShared](data, "chat_shared"),
            story=_message_optional_model[Story](data, "story"),
            giveaway=_message_optional_model[Giveaway](data, "giveaway"),
            giveaway_completed=_message_optional_model[GiveawayCompleted](data, "giveaway_completed"),
            giveaway_created=_message_optional_model[GiveawayCreated](data, "giveaway_created"),
            giveaway_winners=_message_optional_model[GiveawayWinners](data, "giveaway_winners"),
            users_shared=_message_optional_model[UsersShared](data, "users_shared"),
            link_preview_options=_message_optional_model[LinkPreviewOptions](data, "link_preview_options"),
            external_reply=_message_optional_model[ExternalReplyInfo](data, "external_reply"),
            quote=_message_optional_model[TextQuote](data, "quote"),
            forward_origin=_message_optional_model[MessageOrigin](data, "forward_origin"),
            reply_to_story=_message_optional_model[Story](data, "reply_to_story"),
            boost_added=_message_optional_model[ChatBoostAdded](data, "boost_added"),
            sender_business_bot=_message_optional_model[User](data, "sender_business_bot"),
            paid_media=_message_optional_model[PaidMediaInfo](data, "paid_media"),
            refunded_payment=_message_optional_model[RefundedPayment](data, "refunded_payment"),
            gift=_message_optional_model[GiftInfo](data, "gift"),
            unique_gift=_message_optional_model[UniqueGiftInfo](data, "unique_gift"),
            paid_message_price_changed=_message_optional_model[PaidMessagePriceChanged](data, "paid_message_price_changed"),
            direct_message_price_changed=_message_optional_model[DirectMessagePriceChanged](data, "direct_message_price_changed"),
            checklist=_message_optional_model[Checklist](data, "checklist"),
            direct_messages_topic=_message_optional_model[DirectMessagesTopic](data, "direct_messages_topic"),
            gift_upgrade_sent=_message_optional_model[GiftInfo](data, "gift_upgrade_sent"),
            chat_owner_changed=_message_optional_model[ChatOwnerChanged](data, "chat_owner_changed"),
            chat_owner_left=_message_optional_model[ChatOwnerLeft](data, "chat_owner_left"),
            poll_option_added=_message_optional_model[PollOptionAdded](data, "poll_option_added"),
            poll_option_deleted=_message_optional_model[PollOptionDeleted](data, "poll_option_deleted"),
            managed_bot_created=_message_optional_model[ManagedBotCreated](data, "managed_bot_created"),
            guest_bot_caller_user=_message_optional_model[User](data, "guest_bot_caller_user"),
            guest_bot_caller_chat=_message_optional_model[Chat](data, "guest_bot_caller_chat"),
            live_photo=_message_optional_model[LivePhoto](data, "live_photo"),
            api_kwargs=_message_api_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Message]:
        var items = data.array_documents(array_index)
        var result = List[Message]()
        for item in items:
            result.append(Message.de_json(item.copy()))
        return result^


struct InaccessibleMessage(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram message that is no longer accessible, represented by date zero."""

    var message_id: Int
    var chat: Chat
    var api_kwargs: JsonDocument

    def __init__(out self, chat: Chat, message_id: Int):
        self.message_id = message_id
        self.chat = chat.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat: Chat, message_id: Int, *, api_kwargs: JsonDocument):
        self.message_id = message_id
        self.chat = chat.copy()
        self.api_kwargs = api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_id == other.message_id and self.chat == other.chat

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.message_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.chat)).as_bytes())

    def chat_id(self) -> Int:
        return self.chat.id

    def id(self) -> Int:
        return self.message_id

    def is_accessible(self) -> Bool:
        return False

    def date(self) raises -> TimestampDateTime:
        return from_timestamp(0)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "message_id", String(self.message_id))
        result.set_number(result.root, "date", "0")
        var chat_data = self.chat.to_dict(recursive=recursive)
        var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> InaccessibleMessage:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InaccessibleMessage JSON value must be an object")
        var id_index = data.object_get(data.root, "message_id")
        var date_index = data.object_get(data.root, "date")
        var chat_index = data.object_get(data.root, "chat")
        if id_index == -1 or date_index == -1 or chat_index == -1:
            raise Error("InaccessibleMessage JSON object is missing a required field")
        if data.integer_value(date_index) != 0:
            raise Error("InaccessibleMessage date must be zero")
        return InaccessibleMessage(
            Chat.de_json(_message_nested(data, chat_index)),
            data.integer_value(id_index),
            api_kwargs=_message_api_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[InaccessibleMessage]:
        var items = data.array_documents(array_index)
        var result = List[InaccessibleMessage]()
        for item in items:
            result.append(InaccessibleMessage.de_json(item.copy()))
        return result^


struct MaybeInaccessibleMessage(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Tagged native value for the Bot API's accessible/inaccessible message union."""

    var message_id: Int
    var chat: Chat
    var accessible_message: Optional[Message]
    var inaccessible_message: Optional[InaccessibleMessage]

    def __init__(out self, message: Message):
        self.message_id = message.message_id
        self.chat = message.chat.copy()
        self.accessible_message = Optional[Message](message.copy())
        self.inaccessible_message = None

    def __init__(out self, message: InaccessibleMessage):
        self.message_id = message.message_id
        self.chat = message.chat.copy()
        self.accessible_message = None
        self.inaccessible_message = Optional[InaccessibleMessage](message.copy())

    def __eq__(self, other: Self) -> Bool:
        return self.message_id == other.message_id and self.chat == other.chat

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.message_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.chat)).as_bytes())

    def chat_id(self) -> Int:
        return self.chat.id

    def id(self) -> Int:
        return self.message_id

    def is_accessible(self) raises -> Bool:
        return self.date() != from_timestamp(0)

    def date(self) raises -> TimestampDateTime:
        if self.accessible_message is not None:
            return self.accessible_message.value().date.copy()
        return from_timestamp(0)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        if self.accessible_message is not None:
            return self.accessible_message.value().to_dict(recursive=recursive)
        return self.inaccessible_message.value().to_dict(recursive=recursive)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> MaybeInaccessibleMessage:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MaybeInaccessibleMessage JSON value must be an object")
        var date_index = data.object_get(data.root, "date")
        if date_index == -1:
            raise Error("MaybeInaccessibleMessage JSON object is missing 'date'")
        if data.integer_value(date_index) == 0:
            return MaybeInaccessibleMessage(InaccessibleMessage.de_json(data))
        return MaybeInaccessibleMessage(Message.de_json(data))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[MaybeInaccessibleMessage]:
        var items = data.array_documents(array_index)
        var result = List[MaybeInaccessibleMessage]()
        for item in items:
            result.append(MaybeInaccessibleMessage.de_json(item.copy()))
        return result^
