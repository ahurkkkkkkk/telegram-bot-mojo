#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 ChatJoinRequest.
# LGPL-3.0-or-later; see LICENSE.

"""A request to join a chat, with nested chat/user/link values."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._chatinvitelink import ChatInviteLink
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _chat_join_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


struct ChatJoinRequest(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Join request; equality uses chat, sender, and the instant of the request."""

    var chat: Chat
    var from_user: User
    var date: TimestampDateTime
    var user_chat_id: Int
    var bio: Optional[String]
    var invite_link: Optional[ChatInviteLink]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        chat: Chat,
        from_user: User,
        date: TimestampDateTime,
        user_chat_id: Int,
        bio: Optional[String] = None,
        invite_link: Optional[ChatInviteLink] = None,
    ):
        self.chat = chat.copy()
        self.from_user = from_user.copy()
        self.date = date.copy()
        self.user_chat_id = user_chat_id
        self.bio = bio.copy()
        self.invite_link = invite_link.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        chat: Chat,
        from_user: User,
        date: TimestampDateTime,
        user_chat_id: Int,
        bio: Optional[String] = None,
        invite_link: Optional[ChatInviteLink] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.chat = chat.copy()
        self.from_user = from_user.copy()
        self.date = date.copy()
        self.user_chat_id = user_chat_id
        self.bio = bio.copy()
        self.invite_link = invite_link.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.from_user = existing.from_user.copy()
        self.date = existing.date.copy()
        self.user_chat_id = existing.user_chat_id
        self.bio = existing.bio.copy()
        self.invite_link = existing.invite_link.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.chat == other.chat and self.from_user == other.from_user and self.date == other.date

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ChatJoinRequest\0").as_bytes())
        hasher.update(String(self.chat.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.from_user.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(to_timestamp(self.date)).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.date.microsecond).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.bio is not None:
            result.set_string(result.root, "bio", self.bio.value())
        var chat_data = self.chat.to_dict(recursive)
        var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_index)
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        var from_data = self.from_user.to_dict(recursive)
        var from_index = result.copy_subtree_from(from_data, from_data.root)
        result.object_set(result.root, "from", from_index)
        if self.invite_link is not None:
            var invite_data = self.invite_link.value().to_dict(recursive)
            var invite_index = result.copy_subtree_from(invite_data, invite_data.root)
            result.object_set(result.root, "invite_link", invite_index)
        result.set_number(result.root, "user_chat_id", String(self.user_chat_id))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatJoinRequest JSON value must be an object")
        var chat_index = data.object_get(data.root, "chat")
        var from_index = data.object_get(data.root, "from")
        var date_index = data.object_get(data.root, "date")
        var user_chat_id_index = data.object_get(data.root, "user_chat_id")
        if chat_index == -1 or from_index == -1 or date_index == -1 or user_chat_id_index == -1:
            raise Error("ChatJoinRequest JSON object is missing a required field")
        var chat_data = _chat_join_nested(data, chat_index)
        var from_data = _chat_join_nested(data, from_index)
        var chat = Chat.de_json(chat_data)
        var from_user = User.de_json(from_data)
        var date = from_timestamp(data.integer_value(date_index))
        var user_chat_id = data.integer_value(user_chat_id_index)
        var bio_index = data.object_get(data.root, "bio")
        var bio: Optional[String] = None
        if bio_index != -1 and not data.is_null(bio_index):
            bio = Optional[String](data.string_value(bio_index))
        var invite_link: Optional[ChatInviteLink] = None
        var invite_index = data.object_get(data.root, "invite_link")
        if invite_index != -1 and not data.is_null(invite_index):
            var invite_data = _chat_join_nested(data, invite_index)
            invite_link = Optional[ChatInviteLink](ChatInviteLink.de_json(invite_data))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "bio" or key == "chat" or key == "date" or key == "from" or
                key == "invite_link" or key == "user_chat_id"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            chat,
            from_user,
            date,
            user_chat_id,
            bio,
            invite_link,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
