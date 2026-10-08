#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8
# _messagereactionupdated.py. LGPL-3.0-or-later; see LICENSE.

"""Telegram message reaction update values."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._reaction import ReactionCount, ReactionType
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _mru_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _mru_api_kwargs(
    data: JsonDocument, first: String, second: String = String(), third: String = String(),
    fourth: String = String(), fifth: String = String(), sixth: String = String(),
    seventh: String = String(),
) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if (
            key != first and (second.byte_length() == 0 or key != second)
            and (third.byte_length() == 0 or key != third)
            and (fourth.byte_length() == 0 or key != fourth)
            and (fifth.byte_length() == 0 or key != fifth)
            and (sixth.byte_length() == 0 or key != sixth)
            and (seventh.byte_length() == 0 or key != seventh)
        ):
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _mru_parse_reaction_types(data: JsonDocument, key: String) raises -> List[ReactionType]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.nodes[index].kind != JSON_ARRAY:
        raise Error(String("MessageReactionUpdated JSON object is missing array ", key))
    return ReactionType.de_list(data, index)


def _mru_parse_reaction_counts(data: JsonDocument) raises -> List[ReactionCount]:
    var index = data.object_get(data.root, "reactions")
    if index == -1 or data.nodes[index].kind != JSON_ARRAY:
        raise Error("MessageReactionCountUpdated JSON object is missing reactions array")
    return ReactionCount.de_list(data, index)


def _mru_write_reaction_types(
    mut result: JsonDocument, key: String, reactions: List[ReactionType]
) raises:
    if len(reactions) == 0:
        return
    var array = result.add_array()
    result.object_set(result.root, key, array)
    for reaction in reactions:
        var value = reaction.to_dict()
        var child = result.copy_subtree_from(value, value.root)
        result.append_child(array, child)


def _mru_write_reaction_counts(
    mut result: JsonDocument, reactions: List[ReactionCount]
) raises:
    if len(reactions) == 0:
        return
    var array = result.add_array()
    result.object_set(result.root, "reactions", array)
    for reaction in reactions:
        var value = reaction.to_dict()
        var child = result.copy_subtree_from(value, value.root)
        result.append_child(array, child)


struct MessageReactionCountUpdated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Counts for the anonymous reactions present on a message."""

    var chat: Chat
    var message_id: Int
    var date: TimestampDateTime
    var reactions: List[ReactionCount]
    var api_kwargs: JsonDocument

    def __init__(out self, chat: Chat, message_id: Int, date: TimestampDateTime, reactions: List[ReactionCount]):
        self.chat = chat.copy()
        self.message_id = message_id
        self.date = date.copy()
        self.reactions = reactions.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, chat: Chat, message_id: Int, date: TimestampDateTime,
        reactions: List[ReactionCount], *, api_kwargs: JsonDocument,
    ):
        self.chat = chat.copy()
        self.message_id = message_id
        self.date = date.copy()
        self.reactions = reactions.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.message_id = existing.message_id
        self.date = existing.date.copy()
        self.reactions = existing.reactions.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.chat == other.chat and self.message_id == other.message_id
            and self.date == other.date and self.reactions == other.reactions
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.chat.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.message_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.date)).as_bytes())
        for reaction in self.reactions:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(reaction.type.type).as_bytes())
            hasher.update(String("\0").as_bytes())
            if reaction.type.type == ReactionType.EMOJI:
                hasher.update(reaction.type.emoji.as_bytes())
            elif reaction.type.type == ReactionType.CUSTOM_EMOJI:
                hasher.update(reaction.type.custom_emoji_id.as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(String(reaction.total_count).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var chat_data = self.chat.to_dict(recursive)
        var chat_node = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_node)
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        result.set_number(result.root, "message_id", String(self.message_id))
        _mru_write_reaction_counts(result, self.reactions)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MessageReactionCountUpdated JSON value must be an object")
        var chat_index = data.object_get(data.root, "chat")
        var id_index = data.object_get(data.root, "message_id")
        var date_index = data.object_get(data.root, "date")
        if chat_index == -1 or id_index == -1 or date_index == -1:
            raise Error("MessageReactionCountUpdated JSON object is missing a required field")
        var chat = Chat.de_json(_mru_nested(data, chat_index))
        var message_id = data.integer_value(id_index)
        var date = from_timestamp(data.integer_value(date_index))
        var reactions = _mru_parse_reaction_counts(data)
        var api_kwargs = _mru_api_kwargs(data, "chat", "date", "message_id", "reactions")
        return Self(chat, message_id, date, reactions, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


struct MessageReactionUpdated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A user's old and new reaction lists for a message."""

    var chat: Chat
    var message_id: Int
    var date: TimestampDateTime
    var old_reaction: List[ReactionType]
    var new_reaction: List[ReactionType]
    var user: Optional[User]
    var actor_chat: Optional[Chat]
    var api_kwargs: JsonDocument

    def __init__(
        out self, chat: Chat, message_id: Int, date: TimestampDateTime,
        old_reaction: List[ReactionType], new_reaction: List[ReactionType],
        user: Optional[User] = None, actor_chat: Optional[Chat] = None,
    ):
        self.chat = chat.copy()
        self.message_id = message_id
        self.date = date.copy()
        self.old_reaction = old_reaction.copy()
        self.new_reaction = new_reaction.copy()
        self.user = user.copy()
        self.actor_chat = actor_chat.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, chat: Chat, message_id: Int, date: TimestampDateTime,
        old_reaction: List[ReactionType], new_reaction: List[ReactionType],
        user: Optional[User] = None, actor_chat: Optional[Chat] = None,
        *, api_kwargs: JsonDocument,
    ):
        self.chat = chat.copy()
        self.message_id = message_id
        self.date = date.copy()
        self.old_reaction = old_reaction.copy()
        self.new_reaction = new_reaction.copy()
        self.user = user.copy()
        self.actor_chat = actor_chat.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.message_id = existing.message_id
        self.date = existing.date.copy()
        self.old_reaction = existing.old_reaction.copy()
        self.new_reaction = existing.new_reaction.copy()
        self.user = existing.user.copy()
        self.actor_chat = existing.actor_chat.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.chat == other.chat and self.message_id == other.message_id
            and self.date == other.date and self.old_reaction == other.old_reaction
            and self.new_reaction == other.new_reaction
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.chat.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.message_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.date)).as_bytes())
        for reaction in self.old_reaction:
            hasher.update(String("old\0").as_bytes())
            hasher.update(reaction.type.as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(reaction.emoji.as_bytes())
            hasher.update(reaction.custom_emoji_id.as_bytes())
        for reaction in self.new_reaction:
            hasher.update(String("new\0").as_bytes())
            hasher.update(reaction.type.as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(reaction.emoji.as_bytes())
            hasher.update(reaction.custom_emoji_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.actor_chat is not None:
            var actor_data = self.actor_chat.value().to_dict(recursive)
            var actor_node = result.copy_subtree_from(actor_data, actor_data.root)
            result.object_set(result.root, "actor_chat", actor_node)
        var chat_data = self.chat.to_dict(recursive)
        var chat_node = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_node)
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        result.set_number(result.root, "message_id", String(self.message_id))
        _mru_write_reaction_types(result, "new_reaction", self.new_reaction)
        _mru_write_reaction_types(result, "old_reaction", self.old_reaction)
        if self.user is not None:
            var user_data = self.user.value().to_dict(recursive)
            var user_node = result.copy_subtree_from(user_data, user_data.root)
            result.object_set(result.root, "user", user_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MessageReactionUpdated JSON value must be an object")
        var chat_index = data.object_get(data.root, "chat")
        var id_index = data.object_get(data.root, "message_id")
        var date_index = data.object_get(data.root, "date")
        if chat_index == -1 or id_index == -1 or date_index == -1:
            raise Error("MessageReactionUpdated JSON object is missing a required field")
        var chat = Chat.de_json(_mru_nested(data, chat_index))
        var message_id = data.integer_value(id_index)
        var date = from_timestamp(data.integer_value(date_index))
        var old_reaction = _mru_parse_reaction_types(data, "old_reaction")
        var new_reaction = _mru_parse_reaction_types(data, "new_reaction")
        var user: Optional[User] = None
        var user_index = data.object_get(data.root, "user")
        if user_index != -1 and not data.is_null(user_index):
            user = Optional[User](User.de_json(_mru_nested(data, user_index)))
        var actor_chat: Optional[Chat] = None
        var actor_index = data.object_get(data.root, "actor_chat")
        if actor_index != -1 and not data.is_null(actor_index):
            actor_chat = Optional[Chat](Chat.de_json(_mru_nested(data, actor_index)))
        var api_kwargs = _mru_api_kwargs(
            data, "actor_chat", "chat", "date", "message_id", "new_reaction",
            "old_reaction", "user",
        )
        return Self(
            chat, message_id, date, old_reaction, new_reaction, user, actor_chat,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^
