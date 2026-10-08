#!/usr/bin/env mojo
#
# Native Update model translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

# Native model for incoming Telegram updates.

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._callbackquery import CallbackQuery
from telegram._business import BusinessConnection, BusinessMessagesDeleted
from telegram._chatboost import ChatBoostRemoved, ChatBoostUpdated
from telegram._chat import Chat
from telegram._chatjoinrequest import ChatJoinRequest
from telegram._chatmemberupdated import ChatMemberUpdated
from telegram._choseninlineresult import ChosenInlineResult
from telegram._inline.inlinequery import InlineQuery
from telegram._managedbot import ManagedBotUpdated
from telegram._message import MaybeInaccessibleMessage, Message
from telegram._messagereactionupdated import MessageReactionCountUpdated, MessageReactionUpdated
from telegram._paidmedia import PaidMediaPurchased
from telegram._payment.precheckoutquery import PreCheckoutQuery
from telegram._payment.shippingquery import ShippingQuery
from telegram._poll import Poll, PollAnswer
from telegram._telegramobject import TelegramJsonDecodable, TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _update_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("Update JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _update_optional_model[T: TelegramJsonDecodable](
    data: JsonDocument, key: String
) raises -> Optional[T]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[T](T.de_json(_update_nested(data, index)))


def _update_optional_document(
    data: JsonDocument, key: String
) raises -> Optional[JsonDocument]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[JsonDocument](_update_nested(data, index))


def _update_set_optional_model[T: TelegramJsonObject](
    mut result: JsonDocument, key: String, value: Optional[T], recursive: Bool
) raises:
    if value is None:
        return
    var nested = value.value().to_dict(recursive=recursive)
    var index = result.copy_subtree_from(nested, nested.root)
    result.object_set(result.root, key, index)


def _update_set_optional_document(
    mut result: JsonDocument, key: String, value: Optional[JsonDocument]
) raises:
    if value is None:
        return
    var nested = value.value().copy()
    var index = result.copy_subtree_from(nested, nested.root)
    result.object_set(result.root, key, index)


def _update_api_kwargs(data: JsonDocument) raises -> JsonDocument:
    if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("Update JSON value must be an object")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = key == "update_id"
        known = known or key == "message"
        known = known or key == "edited_message"
        known = known or key == "channel_post"
        known = known or key == "edited_channel_post"
        known = known or key == "inline_query"
        known = known or key == "chosen_inline_result"
        known = known or key == "callback_query"
        known = known or key == "shipping_query"
        known = known or key == "pre_checkout_query"
        known = known or key == "poll"
        known = known or key == "poll_answer"
        known = known or key == "my_chat_member"
        known = known or key == "chat_member"
        known = known or key == "chat_join_request"
        known = known or key == "chat_boost"
        known = known or key == "removed_chat_boost"
        known = known or key == "message_reaction"
        known = known or key == "message_reaction_count"
        known = known or key == "business_connection"
        known = known or key == "business_message"
        known = known or key == "edited_business_message"
        known = known or key == "deleted_business_messages"
        known = known or key == "purchased_paid_media"
        known = known or key == "managed_bot"
        known = known or key == "guest_message"
        if not known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct EffectiveSender(Copyable):
    # Native tagged-by-presence User-or-Chat sender value.

    var user: Optional[User]
    var chat: Optional[Chat]

    def __init__(out self, user: Optional[User] = None, chat: Optional[Chat] = None):
        self.user = user.copy()
        self.chat = chat.copy()


struct Update(Equatable, Hashable, Copyable, TelegramJsonObject):
    # A native Telegram update with typed event payloads where available.

    var update_id: Int
    var message: Optional[Message]
    var edited_message: Optional[Message]
    var channel_post: Optional[Message]
    var edited_channel_post: Optional[Message]
    var inline_query: Optional[InlineQuery]
    var chosen_inline_result: Optional[ChosenInlineResult]
    var callback_query: Optional[CallbackQuery]
    var shipping_query: Optional[ShippingQuery]
    var pre_checkout_query: Optional[PreCheckoutQuery]
    var poll: Optional[Poll]
    var poll_answer: Optional[PollAnswer]
    var my_chat_member: Optional[ChatMemberUpdated]
    var chat_member: Optional[ChatMemberUpdated]
    var chat_join_request: Optional[ChatJoinRequest]
    var chat_boost: Optional[ChatBoostUpdated]
    var removed_chat_boost: Optional[ChatBoostRemoved]
    var message_reaction: Optional[MessageReactionUpdated]
    var message_reaction_count: Optional[MessageReactionCountUpdated]
    var business_connection: Optional[BusinessConnection]
    var business_message: Optional[Message]
    var edited_business_message: Optional[Message]
    var deleted_business_messages: Optional[BusinessMessagesDeleted]
    var purchased_paid_media: Optional[PaidMediaPurchased]
    var managed_bot: Optional[ManagedBotUpdated]
    var guest_message: Optional[Message]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        update_id: Int,
        message: Optional[Message] = None,
        edited_message: Optional[Message] = None,
        channel_post: Optional[Message] = None,
        edited_channel_post: Optional[Message] = None,
        inline_query: Optional[InlineQuery] = None,
        chosen_inline_result: Optional[ChosenInlineResult] = None,
        callback_query: Optional[CallbackQuery] = None,
        shipping_query: Optional[ShippingQuery] = None,
        pre_checkout_query: Optional[PreCheckoutQuery] = None,
        poll: Optional[Poll] = None,
        poll_answer: Optional[PollAnswer] = None,
        my_chat_member: Optional[ChatMemberUpdated] = None,
        chat_member: Optional[ChatMemberUpdated] = None,
        chat_join_request: Optional[ChatJoinRequest] = None,
        chat_boost: Optional[ChatBoostUpdated] = None,
        removed_chat_boost: Optional[ChatBoostRemoved] = None,
        message_reaction: Optional[MessageReactionUpdated] = None,
        message_reaction_count: Optional[MessageReactionCountUpdated] = None,
        business_connection: Optional[BusinessConnection] = None,
        business_message: Optional[Message] = None,
        edited_business_message: Optional[Message] = None,
        deleted_business_messages: Optional[BusinessMessagesDeleted] = None,
        purchased_paid_media: Optional[PaidMediaPurchased] = None,
        managed_bot: Optional[ManagedBotUpdated] = None,
        guest_message: Optional[Message] = None,
    ):
        self.update_id = update_id
        self.message = message.copy()
        self.edited_message = edited_message.copy()
        self.channel_post = channel_post.copy()
        self.edited_channel_post = edited_channel_post.copy()
        self.inline_query = inline_query.copy()
        self.chosen_inline_result = chosen_inline_result.copy()
        self.callback_query = callback_query.copy()
        self.shipping_query = shipping_query.copy()
        self.pre_checkout_query = pre_checkout_query.copy()
        self.poll = poll.copy()
        self.poll_answer = poll_answer.copy()
        self.my_chat_member = my_chat_member.copy()
        self.chat_member = chat_member.copy()
        self.chat_join_request = chat_join_request.copy()
        self.chat_boost = chat_boost.copy()
        self.removed_chat_boost = removed_chat_boost.copy()
        self.message_reaction = message_reaction.copy()
        self.message_reaction_count = message_reaction_count.copy()
        self.business_connection = business_connection.copy()
        self.business_message = business_message.copy()
        self.edited_business_message = edited_business_message.copy()
        self.deleted_business_messages = deleted_business_messages.copy()
        self.purchased_paid_media = purchased_paid_media.copy()
        self.managed_bot = managed_bot.copy()
        self.guest_message = guest_message.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        update_id: Int,
        message: Optional[Message] = None,
        edited_message: Optional[Message] = None,
        channel_post: Optional[Message] = None,
        edited_channel_post: Optional[Message] = None,
        inline_query: Optional[InlineQuery] = None,
        chosen_inline_result: Optional[ChosenInlineResult] = None,
        callback_query: Optional[CallbackQuery] = None,
        shipping_query: Optional[ShippingQuery] = None,
        pre_checkout_query: Optional[PreCheckoutQuery] = None,
        poll: Optional[Poll] = None,
        poll_answer: Optional[PollAnswer] = None,
        my_chat_member: Optional[ChatMemberUpdated] = None,
        chat_member: Optional[ChatMemberUpdated] = None,
        chat_join_request: Optional[ChatJoinRequest] = None,
        chat_boost: Optional[ChatBoostUpdated] = None,
        removed_chat_boost: Optional[ChatBoostRemoved] = None,
        message_reaction: Optional[MessageReactionUpdated] = None,
        message_reaction_count: Optional[MessageReactionCountUpdated] = None,
        business_connection: Optional[BusinessConnection] = None,
        business_message: Optional[Message] = None,
        edited_business_message: Optional[Message] = None,
        deleted_business_messages: Optional[BusinessMessagesDeleted] = None,
        purchased_paid_media: Optional[PaidMediaPurchased] = None,
        managed_bot: Optional[ManagedBotUpdated] = None,
        guest_message: Optional[Message] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.update_id = update_id
        self.message = message.copy()
        self.edited_message = edited_message.copy()
        self.channel_post = channel_post.copy()
        self.edited_channel_post = edited_channel_post.copy()
        self.inline_query = inline_query.copy()
        self.chosen_inline_result = chosen_inline_result.copy()
        self.callback_query = callback_query.copy()
        self.shipping_query = shipping_query.copy()
        self.pre_checkout_query = pre_checkout_query.copy()
        self.poll = poll.copy()
        self.poll_answer = poll_answer.copy()
        self.my_chat_member = my_chat_member.copy()
        self.chat_member = chat_member.copy()
        self.chat_join_request = chat_join_request.copy()
        self.chat_boost = chat_boost.copy()
        self.removed_chat_boost = removed_chat_boost.copy()
        self.message_reaction = message_reaction.copy()
        self.message_reaction_count = message_reaction_count.copy()
        self.business_connection = business_connection.copy()
        self.business_message = business_message.copy()
        self.edited_business_message = edited_business_message.copy()
        self.deleted_business_messages = deleted_business_messages.copy()
        self.purchased_paid_media = purchased_paid_media.copy()
        self.managed_bot = managed_bot.copy()
        self.guest_message = guest_message.copy()
        self.api_kwargs = api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.update_id == other.update_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.update_id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "update_id", String(self.update_id))
        _update_set_optional_model(result, "message", self.message, recursive)
        _update_set_optional_model(result, "edited_message", self.edited_message, recursive)
        _update_set_optional_model(result, "channel_post", self.channel_post, recursive)
        _update_set_optional_model(result, "edited_channel_post", self.edited_channel_post, recursive)
        _update_set_optional_model(result, "inline_query", self.inline_query, recursive)
        _update_set_optional_model(result, "chosen_inline_result", self.chosen_inline_result, recursive)
        _update_set_optional_model(result, "callback_query", self.callback_query, recursive)
        _update_set_optional_model(result, "shipping_query", self.shipping_query, recursive)
        _update_set_optional_model(result, "pre_checkout_query", self.pre_checkout_query, recursive)
        _update_set_optional_model(result, "poll", self.poll, recursive)
        _update_set_optional_model(result, "poll_answer", self.poll_answer, recursive)
        _update_set_optional_model(result, "my_chat_member", self.my_chat_member, recursive)
        _update_set_optional_model(result, "chat_member", self.chat_member, recursive)
        _update_set_optional_model(result, "chat_join_request", self.chat_join_request, recursive)
        _update_set_optional_model(result, "chat_boost", self.chat_boost, recursive)
        _update_set_optional_model(result, "removed_chat_boost", self.removed_chat_boost, recursive)
        _update_set_optional_model(result, "message_reaction", self.message_reaction, recursive)
        _update_set_optional_model(result, "message_reaction_count", self.message_reaction_count, recursive)
        _update_set_optional_model(result, "business_connection", self.business_connection, recursive)
        _update_set_optional_model(result, "business_message", self.business_message, recursive)
        _update_set_optional_model(result, "edited_business_message", self.edited_business_message, recursive)
        _update_set_optional_model(result, "deleted_business_messages", self.deleted_business_messages, recursive)
        _update_set_optional_model(result, "purchased_paid_media", self.purchased_paid_media, recursive)
        _update_set_optional_model(result, "managed_bot", self.managed_bot, recursive)
        _update_set_optional_model(result, "guest_message", self.guest_message, recursive)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Update:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Update JSON value must be an object")
        var update_id_index = data.object_get(data.root, "update_id")
        if update_id_index == -1 or data.is_null(update_id_index):
            raise Error("Update JSON object is missing update_id")
        var update_id = data.integer_value(update_id_index)
        return Update(
            update_id,
            message=_update_optional_model[Message](data, "message"),
            edited_message=_update_optional_model[Message](data, "edited_message"),
            channel_post=_update_optional_model[Message](data, "channel_post"),
            edited_channel_post=_update_optional_model[Message](data, "edited_channel_post"),
            inline_query=_update_optional_model[InlineQuery](data, "inline_query"),
            chosen_inline_result=_update_optional_model[ChosenInlineResult](data, "chosen_inline_result"),
            callback_query=_update_optional_model[CallbackQuery](data, "callback_query"),
            shipping_query=_update_optional_model[ShippingQuery](data, "shipping_query"),
            pre_checkout_query=_update_optional_model[PreCheckoutQuery](data, "pre_checkout_query"),
            poll=_update_optional_model[Poll](data, "poll"),
            poll_answer=_update_optional_model[PollAnswer](data, "poll_answer"),
            my_chat_member=_update_optional_model[ChatMemberUpdated](data, "my_chat_member"),
            chat_member=_update_optional_model[ChatMemberUpdated](data, "chat_member"),
            chat_join_request=_update_optional_model[ChatJoinRequest](data, "chat_join_request"),
            chat_boost=_update_optional_model[ChatBoostUpdated](data, "chat_boost"),
            removed_chat_boost=_update_optional_model[ChatBoostRemoved](data, "removed_chat_boost"),
            message_reaction=_update_optional_model[MessageReactionUpdated](data, "message_reaction"),
            message_reaction_count=_update_optional_model[MessageReactionCountUpdated](data, "message_reaction_count"),
            business_connection=_update_optional_model[BusinessConnection](data, "business_connection"),
            business_message=_update_optional_model[Message](data, "business_message"),
            edited_business_message=_update_optional_model[Message](data, "edited_business_message"),
            deleted_business_messages=_update_optional_model[BusinessMessagesDeleted](data, "deleted_business_messages"),
            purchased_paid_media=_update_optional_model[PaidMediaPurchased](data, "purchased_paid_media"),
            managed_bot=_update_optional_model[ManagedBotUpdated](data, "managed_bot"),
            guest_message=_update_optional_model[Message](data, "guest_message"),
            api_kwargs=_update_api_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Update]:
        var items = data.array_documents(array_index)
        var result = List[Update]()
        for item in items:
            result.append(Update.de_json(item.copy()))
        return result^

    @staticmethod
    def all_types() -> List[String]:
        var result = List[String]()
        result.append("message")
        result.append("edited_message")
        result.append("channel_post")
        result.append("edited_channel_post")
        result.append("inline_query")
        result.append("chosen_inline_result")
        result.append("callback_query")
        result.append("shipping_query")
        result.append("pre_checkout_query")
        result.append("poll")
        result.append("poll_answer")
        result.append("my_chat_member")
        result.append("chat_member")
        result.append("chat_join_request")
        result.append("chat_boost")
        result.append("removed_chat_boost")
        result.append("message_reaction")
        result.append("message_reaction_count")
        result.append("business_connection")
        result.append("business_message")
        result.append("edited_business_message")
        result.append("deleted_business_messages")
        result.append("purchased_paid_media")
        result.append("managed_bot")
        result.append("guest_message")
        return result^

    def effective_message(self) -> Optional[Message]:
        if self.message is not None:
            return self.message.copy()
        if self.edited_message is not None:
            return self.edited_message.copy()
        if self.callback_query is not None:
            if self.callback_query.value().message is None:
                return None
            var callback_message = self.callback_query.value().message.value().copy()
            return callback_message.accessible_message.copy()
        if self.channel_post is not None:
            return self.channel_post.copy()
        if self.edited_channel_post is not None:
            return self.edited_channel_post.copy()
        if self.business_message is not None:
            return self.business_message.copy()
        if self.edited_business_message is not None:
            return self.edited_business_message.copy()
        if self.guest_message is not None:
            return self.guest_message.copy()
        return None

    def effective_user(self) raises -> Optional[User]:
        if self.message is not None:
            return self.message.value().from_user.copy()
        if self.edited_message is not None:
            return self.edited_message.value().from_user.copy()
        if self.business_message is not None:
            return self.business_message.value().from_user.copy()
        if self.edited_business_message is not None:
            return self.edited_business_message.value().from_user.copy()
        if self.guest_message is not None:
            return self.guest_message.value().from_user.copy()
        if self.channel_post is not None:
            return self.channel_post.value().from_user.copy()
        if self.edited_channel_post is not None:
            return self.edited_channel_post.value().from_user.copy()
        if self.inline_query is not None:
            return Optional[User](self.inline_query.value().from_user.copy())
        if self.chosen_inline_result is not None:
            return Optional[User](self.chosen_inline_result.value().from_user.copy())
        if self.callback_query is not None:
            return Optional[User](self.callback_query.value().from_user.copy())
        if self.shipping_query is not None:
            return Optional[User](self.shipping_query.value().from_user.copy())
        if self.pre_checkout_query is not None:
            return Optional[User](self.pre_checkout_query.value().from_user.copy())
        if self.poll_answer is not None:
            return self.poll_answer.value().user.copy()
        if self.my_chat_member is not None:
            return Optional[User](self.my_chat_member.value().from_user.copy())
        if self.chat_member is not None:
            return Optional[User](self.chat_member.value().from_user.copy())
        if self.chat_join_request is not None:
            return Optional[User](self.chat_join_request.value().from_user.copy())
        if self.message_reaction is not None:
            return self.message_reaction.value().user.copy()
        if self.purchased_paid_media is not None:
            return Optional[User](self.purchased_paid_media.value().from_user.copy())
        if self.managed_bot is not None:
            return Optional[User](self.managed_bot.value().user.copy())
        if self.business_connection is not None:
            return Optional[User](self.business_connection.value().user.copy())
        return None

    def effective_sender(self) raises -> EffectiveSender:
        if self.message is not None:
            if self.message.value().sender_chat is not None:
                return EffectiveSender(chat=self.message.value().sender_chat.copy())
        elif self.edited_message is not None:
            if self.edited_message.value().sender_chat is not None:
                return EffectiveSender(chat=self.edited_message.value().sender_chat.copy())
        elif self.channel_post is not None:
            if self.channel_post.value().sender_chat is not None:
                return EffectiveSender(chat=self.channel_post.value().sender_chat.copy())
        elif self.edited_channel_post is not None:
            if self.edited_channel_post.value().sender_chat is not None:
                return EffectiveSender(chat=self.edited_channel_post.value().sender_chat.copy())
        elif self.business_message is not None:
            if self.business_message.value().sender_chat is not None:
                return EffectiveSender(chat=self.business_message.value().sender_chat.copy())
        elif self.edited_business_message is not None:
            if self.edited_business_message.value().sender_chat is not None:
                return EffectiveSender(chat=self.edited_business_message.value().sender_chat.copy())
        elif self.guest_message is not None:
            if self.guest_message.value().sender_chat is not None:
                return EffectiveSender(chat=self.guest_message.value().sender_chat.copy())
        if self.poll_answer is not None and self.poll_answer.value().voter_chat is not None:
            return EffectiveSender(chat=self.poll_answer.value().voter_chat.copy())
        if self.message_reaction is not None and self.message_reaction.value().actor_chat is not None:
            return EffectiveSender(chat=self.message_reaction.value().actor_chat.copy())
        return EffectiveSender(user=self.effective_user())

    def effective_chat(self) raises -> Optional[Chat]:
        if self.message is not None:
            return Optional[Chat](self.message.value().chat.copy())
        if self.edited_message is not None:
            return Optional[Chat](self.edited_message.value().chat.copy())
        if self.channel_post is not None:
            return Optional[Chat](self.channel_post.value().chat.copy())
        if self.edited_channel_post is not None:
            return Optional[Chat](self.edited_channel_post.value().chat.copy())
        if self.business_message is not None:
            return Optional[Chat](self.business_message.value().chat.copy())
        if self.edited_business_message is not None:
            return Optional[Chat](self.edited_business_message.value().chat.copy())
        if self.deleted_business_messages is not None:
            return Optional[Chat](self.deleted_business_messages.value().chat.copy())
        if self.guest_message is not None:
            return Optional[Chat](self.guest_message.value().chat.copy())
        if self.callback_query is not None and self.callback_query.value().message is not None:
            return Optional[Chat](self.callback_query.value().message.value().chat.copy())
        if self.my_chat_member is not None:
            return Optional[Chat](self.my_chat_member.value().chat.copy())
        if self.chat_member is not None:
            return Optional[Chat](self.chat_member.value().chat.copy())
        if self.chat_join_request is not None:
            return Optional[Chat](self.chat_join_request.value().chat.copy())
        if self.message_reaction is not None:
            return Optional[Chat](self.message_reaction.value().chat.copy())
        if self.message_reaction_count is not None:
            return Optional[Chat](self.message_reaction_count.value().chat.copy())
        if self.chat_boost is not None:
            return Optional[Chat](self.chat_boost.value().chat.copy())
        if self.removed_chat_boost is not None:
            return Optional[Chat](self.removed_chat_boost.value().chat.copy())
        return None
