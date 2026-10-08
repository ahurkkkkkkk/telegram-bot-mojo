#!/usr/bin/env mojo
#
# Native Mojo translation of KeyboardButtonRequestChat from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Criteria used by a keyboard button to request a suitable chat."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chatadministratorrights import ChatAdministratorRights
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _request_chat_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


struct KeyboardButtonRequestChat(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native representation of the Telegram chat-selection request criteria."""

    var request_id: Int
    var chat_is_channel: Bool
    var chat_is_forum: Optional[Bool]
    var chat_has_username: Optional[Bool]
    var chat_is_created: Optional[Bool]
    var user_administrator_rights: Optional[ChatAdministratorRights]
    var bot_administrator_rights: Optional[ChatAdministratorRights]
    var bot_is_member: Optional[Bool]
    var request_title: Optional[Bool]
    var request_username: Optional[Bool]
    var request_photo: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        request_id: Int,
        chat_is_channel: Bool,
        chat_is_forum: Optional[Bool] = None,
        chat_has_username: Optional[Bool] = None,
        chat_is_created: Optional[Bool] = None,
        user_administrator_rights: Optional[ChatAdministratorRights] = None,
        bot_administrator_rights: Optional[ChatAdministratorRights] = None,
        bot_is_member: Optional[Bool] = None,
        request_title: Optional[Bool] = None,
        request_username: Optional[Bool] = None,
        request_photo: Optional[Bool] = None,
    ):
        self.request_id = request_id
        self.chat_is_channel = chat_is_channel
        self.chat_is_forum = chat_is_forum.copy()
        self.chat_has_username = chat_has_username.copy()
        self.chat_is_created = chat_is_created.copy()
        self.user_administrator_rights = user_administrator_rights.copy()
        self.bot_administrator_rights = bot_administrator_rights.copy()
        self.bot_is_member = bot_is_member.copy()
        self.request_title = request_title.copy()
        self.request_username = request_username.copy()
        self.request_photo = request_photo.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        request_id: Int,
        chat_is_channel: Bool,
        chat_is_forum: Optional[Bool] = None,
        chat_has_username: Optional[Bool] = None,
        chat_is_created: Optional[Bool] = None,
        user_administrator_rights: Optional[ChatAdministratorRights] = None,
        bot_administrator_rights: Optional[ChatAdministratorRights] = None,
        bot_is_member: Optional[Bool] = None,
        request_title: Optional[Bool] = None,
        request_username: Optional[Bool] = None,
        request_photo: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.request_id = request_id
        self.chat_is_channel = chat_is_channel
        self.chat_is_forum = chat_is_forum.copy()
        self.chat_has_username = chat_has_username.copy()
        self.chat_is_created = chat_is_created.copy()
        self.user_administrator_rights = user_administrator_rights.copy()
        self.bot_administrator_rights = bot_administrator_rights.copy()
        self.bot_is_member = bot_is_member.copy()
        self.request_title = request_title.copy()
        self.request_username = request_username.copy()
        self.request_photo = request_photo.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.request_id = existing.request_id
        self.chat_is_channel = existing.chat_is_channel
        self.chat_is_forum = existing.chat_is_forum.copy()
        self.chat_has_username = existing.chat_has_username.copy()
        self.chat_is_created = existing.chat_is_created.copy()
        self.user_administrator_rights = existing.user_administrator_rights.copy()
        self.bot_administrator_rights = existing.bot_administrator_rights.copy()
        self.bot_is_member = existing.bot_is_member.copy()
        self.request_title = existing.request_title.copy()
        self.request_username = existing.request_username.copy()
        self.request_photo = existing.request_photo.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        # Upstream deliberately defines identity by request_id alone.
        return self.request_id == other.request_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.request_id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "chat_is_channel", self.chat_is_channel)
        if self.chat_has_username is not None:
            result.set_boolean(result.root, "chat_has_username", self.chat_has_username.value())
        if self.chat_is_created is not None:
            result.set_boolean(result.root, "chat_is_created", self.chat_is_created.value())
        if self.chat_is_forum is not None:
            result.set_boolean(result.root, "chat_is_forum", self.chat_is_forum.value())
        if self.bot_administrator_rights is not None:
            var nested = self.bot_administrator_rights.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "bot_administrator_rights", nested_index)
        if self.bot_is_member is not None:
            result.set_boolean(result.root, "bot_is_member", self.bot_is_member.value())
        result.set_number(result.root, "request_id", String(self.request_id))
        if self.request_photo is not None:
            result.set_boolean(result.root, "request_photo", self.request_photo.value())
        if self.request_title is not None:
            result.set_boolean(result.root, "request_title", self.request_title.value())
        if self.request_username is not None:
            result.set_boolean(result.root, "request_username", self.request_username.value())
        if self.user_administrator_rights is not None:
            var nested = self.user_administrator_rights.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "user_administrator_rights", nested_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> KeyboardButtonRequestChat:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("KeyboardButtonRequestChat JSON value must be an object")
        var request_id_index = data.object_get(data.root, "request_id")
        var chat_is_channel_index = data.object_get(data.root, "chat_is_channel")
        if request_id_index == -1 or chat_is_channel_index == -1:
            raise Error("KeyboardButtonRequestChat JSON object is missing a required field")
        var request_id = data.integer_value(request_id_index)
        var chat_is_channel = data.boolean_value(chat_is_channel_index)

        var chat_is_forum: Optional[Bool] = None
        var field_index = data.object_get(data.root, "chat_is_forum")
        if field_index != -1 and not data.is_null(field_index):
            chat_is_forum = Optional[Bool](data.boolean_value(field_index))
        var chat_has_username: Optional[Bool] = None
        field_index = data.object_get(data.root, "chat_has_username")
        if field_index != -1 and not data.is_null(field_index):
            chat_has_username = Optional[Bool](data.boolean_value(field_index))
        var chat_is_created: Optional[Bool] = None
        field_index = data.object_get(data.root, "chat_is_created")
        if field_index != -1 and not data.is_null(field_index):
            chat_is_created = Optional[Bool](data.boolean_value(field_index))
        var bot_is_member: Optional[Bool] = None
        field_index = data.object_get(data.root, "bot_is_member")
        if field_index != -1 and not data.is_null(field_index):
            bot_is_member = Optional[Bool](data.boolean_value(field_index))
        var request_title: Optional[Bool] = None
        field_index = data.object_get(data.root, "request_title")
        if field_index != -1 and not data.is_null(field_index):
            request_title = Optional[Bool](data.boolean_value(field_index))
        var request_username: Optional[Bool] = None
        field_index = data.object_get(data.root, "request_username")
        if field_index != -1 and not data.is_null(field_index):
            request_username = Optional[Bool](data.boolean_value(field_index))
        var request_photo: Optional[Bool] = None
        field_index = data.object_get(data.root, "request_photo")
        if field_index != -1 and not data.is_null(field_index):
            request_photo = Optional[Bool](data.boolean_value(field_index))

        var user_administrator_rights: Optional[ChatAdministratorRights] = None
        field_index = data.object_get(data.root, "user_administrator_rights")
        if field_index != -1 and not data.is_null(field_index):
            var nested = _request_chat_nested(data, field_index)
            user_administrator_rights = Optional[ChatAdministratorRights](ChatAdministratorRights.de_json(nested))
        var bot_administrator_rights: Optional[ChatAdministratorRights] = None
        field_index = data.object_get(data.root, "bot_administrator_rights")
        if field_index != -1 and not data.is_null(field_index):
            var nested = _request_chat_nested(data, field_index)
            bot_administrator_rights = Optional[ChatAdministratorRights](ChatAdministratorRights.de_json(nested))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "request_id" or key == "chat_is_channel" or key == "chat_is_forum" or
                key == "chat_has_username" or key == "chat_is_created" or
                key == "user_administrator_rights" or key == "bot_administrator_rights" or
                key == "bot_is_member" or key == "request_title" or key == "request_username" or
                key == "request_photo"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return KeyboardButtonRequestChat(
            request_id,
            chat_is_channel,
            chat_is_forum,
            chat_has_username,
            chat_is_created,
            user_administrator_rights,
            bot_administrator_rights,
            bot_is_member,
            request_title,
            request_username,
            request_photo,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[KeyboardButtonRequestChat]:
        var items = data.array_documents(array_index)
        var result = List[KeyboardButtonRequestChat]()
        for index in range(len(items)):
            result.append(KeyboardButtonRequestChat.de_json(items[index].copy()))
        return result^
