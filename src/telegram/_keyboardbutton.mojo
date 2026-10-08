#!/usr/bin/env mojo
#
# Native Mojo translation of KeyboardButton from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""A reply-keyboard button and its optional Telegram request actions."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._keyboardbuttonpolltype import KeyboardButtonPollType
from telegram._keyboardbuttonrequest import (
    KeyboardButtonRequestManagedBot,
    KeyboardButtonRequestUsers,
)
from telegram._keyboardbuttonrequestchat import KeyboardButtonRequestChat
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._webappinfo import WebAppInfo


def _keyboard_button_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


struct KeyboardButton(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native representation of a reply keyboard button."""

    var text: String
    var request_contact: Optional[Bool]
    var request_location: Optional[Bool]
    var request_poll: Optional[KeyboardButtonPollType]
    var web_app: Optional[WebAppInfo]
    var request_chat: Optional[KeyboardButtonRequestChat]
    var request_users: Optional[KeyboardButtonRequestUsers]
    var style: Optional[String]
    var icon_custom_emoji_id: Optional[String]
    var request_managed_bot: Optional[KeyboardButtonRequestManagedBot]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        text: String,
        request_contact: Optional[Bool] = None,
        request_location: Optional[Bool] = None,
        request_poll: Optional[KeyboardButtonPollType] = None,
        web_app: Optional[WebAppInfo] = None,
        request_chat: Optional[KeyboardButtonRequestChat] = None,
        request_users: Optional[KeyboardButtonRequestUsers] = None,
        style: Optional[String] = None,
        icon_custom_emoji_id: Optional[String] = None,
        request_managed_bot: Optional[KeyboardButtonRequestManagedBot] = None,
    ):
        self.text = text.copy()
        self.request_contact = request_contact.copy()
        self.request_location = request_location.copy()
        self.request_poll = request_poll.copy()
        self.web_app = web_app.copy()
        self.request_chat = request_chat.copy()
        self.request_users = request_users.copy()
        self.style = style.copy()
        self.icon_custom_emoji_id = icon_custom_emoji_id.copy()
        self.request_managed_bot = request_managed_bot.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        request_contact: Optional[Bool] = None,
        request_location: Optional[Bool] = None,
        request_poll: Optional[KeyboardButtonPollType] = None,
        web_app: Optional[WebAppInfo] = None,
        request_chat: Optional[KeyboardButtonRequestChat] = None,
        request_users: Optional[KeyboardButtonRequestUsers] = None,
        style: Optional[String] = None,
        icon_custom_emoji_id: Optional[String] = None,
        request_managed_bot: Optional[KeyboardButtonRequestManagedBot] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.text = text.copy()
        self.request_contact = request_contact.copy()
        self.request_location = request_location.copy()
        self.request_poll = request_poll.copy()
        self.web_app = web_app.copy()
        self.request_chat = request_chat.copy()
        self.request_users = request_users.copy()
        self.style = style.copy()
        self.icon_custom_emoji_id = icon_custom_emoji_id.copy()
        self.request_managed_bot = request_managed_bot.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.request_contact = existing.request_contact.copy()
        self.request_location = existing.request_location.copy()
        self.request_poll = existing.request_poll.copy()
        self.web_app = existing.web_app.copy()
        self.request_chat = existing.request_chat.copy()
        self.request_users = existing.request_users.copy()
        self.style = existing.style.copy()
        self.icon_custom_emoji_id = existing.icon_custom_emoji_id.copy()
        self.request_managed_bot = existing.request_managed_bot.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        # Match upstream _id_attrs. request_managed_bot is intentionally excluded.
        return (
            self.text == other.text and
            self.request_contact == other.request_contact and
            self.request_location == other.request_location and
            self.request_poll == other.request_poll and
            self.web_app == other.web_app and
            self.request_users == other.request_users and
            self.request_chat == other.request_chat and
            self.style == other.style and
            self.icon_custom_emoji_id == other.icon_custom_emoji_id
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        # Hashing only text is intentionally coarse but remains consistent with
        # the full equality relation (and ignores non-identity API extras).
        hasher.update(self.text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.icon_custom_emoji_id is not None:
            result.set_string(result.root, "icon_custom_emoji_id", self.icon_custom_emoji_id.value())
        if self.request_contact is not None:
            result.set_boolean(result.root, "request_contact", self.request_contact.value())
        if self.request_location is not None:
            result.set_boolean(result.root, "request_location", self.request_location.value())
        if self.request_managed_bot is not None:
            var nested = self.request_managed_bot.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "request_managed_bot", nested_index)
        if self.request_chat is not None:
            var nested = self.request_chat.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "request_chat", nested_index)
        if self.request_poll is not None:
            var nested = self.request_poll.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "request_poll", nested_index)
        if self.request_users is not None:
            var nested = self.request_users.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "request_users", nested_index)
        if self.style is not None:
            result.set_string(result.root, "style", self.style.value())
        result.set_string(result.root, "text", self.text)
        if self.web_app is not None:
            var nested = self.web_app.value().to_dict(recursive)
            var nested_index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "web_app", nested_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> KeyboardButton:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("KeyboardButton JSON value must be an object")
        var text_index = data.object_get(data.root, "text")
        if text_index == -1:
            raise Error("KeyboardButton JSON object is missing text")
        var text = data.string_value(text_index)

        var request_contact: Optional[Bool] = None
        var index = data.object_get(data.root, "request_contact")
        if index != -1 and not data.is_null(index):
            request_contact = Optional[Bool](data.boolean_value(index))
        var request_location: Optional[Bool] = None
        index = data.object_get(data.root, "request_location")
        if index != -1 and not data.is_null(index):
            request_location = Optional[Bool](data.boolean_value(index))
        var request_poll: Optional[KeyboardButtonPollType] = None
        index = data.object_get(data.root, "request_poll")
        if index != -1 and not data.is_null(index):
            request_poll = Optional[KeyboardButtonPollType](
                KeyboardButtonPollType.de_json(_keyboard_button_nested(data, index))
            )
        var web_app: Optional[WebAppInfo] = None
        index = data.object_get(data.root, "web_app")
        if index != -1 and not data.is_null(index):
            web_app = Optional[WebAppInfo](WebAppInfo.de_json(_keyboard_button_nested(data, index)))
        var request_chat: Optional[KeyboardButtonRequestChat] = None
        index = data.object_get(data.root, "request_chat")
        if index != -1 and not data.is_null(index):
            request_chat = Optional[KeyboardButtonRequestChat](
                KeyboardButtonRequestChat.de_json(_keyboard_button_nested(data, index))
            )
        var request_users: Optional[KeyboardButtonRequestUsers] = None
        index = data.object_get(data.root, "request_users")
        if index != -1 and not data.is_null(index):
            request_users = Optional[KeyboardButtonRequestUsers](
                KeyboardButtonRequestUsers.de_json(_keyboard_button_nested(data, index))
            )
        var style: Optional[String] = None
        index = data.object_get(data.root, "style")
        if index != -1 and not data.is_null(index):
            style = Optional[String](data.string_value(index))
        var icon_custom_emoji_id: Optional[String] = None
        index = data.object_get(data.root, "icon_custom_emoji_id")
        if index != -1 and not data.is_null(index):
            icon_custom_emoji_id = Optional[String](data.string_value(index))
        var request_managed_bot: Optional[KeyboardButtonRequestManagedBot] = None
        index = data.object_get(data.root, "request_managed_bot")
        if index != -1 and not data.is_null(index):
            request_managed_bot = Optional[KeyboardButtonRequestManagedBot](
                KeyboardButtonRequestManagedBot.de_json(_keyboard_button_nested(data, index))
            )

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "text" or key == "request_contact" or key == "request_location" or
                key == "request_poll" or key == "web_app" or key == "request_chat" or
                key == "request_users" or key == "style" or key == "icon_custom_emoji_id" or
                key == "request_managed_bot"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return KeyboardButton(
            text,
            request_contact,
            request_location,
            request_poll,
            web_app,
            request_chat,
            request_users,
            style,
            icon_custom_emoji_id,
            request_managed_bot,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[KeyboardButton]:
        var items = data.array_documents(array_index)
        var result = List[KeyboardButton]()
        for index in range(len(items)):
            result.append(KeyboardButton.de_json(items[index].copy()))
        return result^
