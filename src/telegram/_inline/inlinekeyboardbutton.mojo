#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineKeyboardButton.
# LGPL-3.0-or-later; see LICENSE.

"""A Telegram inline keyboard button and its nested Bot API values."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._copytextbutton import CopyTextButton
from telegram._games.callbackgame import CallbackGame
from telegram._loginurl import LoginUrl
from telegram._switchinlinequerychosenchat import SwitchInlineQueryChosenChat
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._webappinfo import WebAppInfo


def _inline_button_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _inline_button_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _inline_button_child(data: JsonDocument, key: String) raises -> JsonDocument:
    var index = data.object_get(data.root, key)
    var child = JsonDocument()
    child.root = child.copy_subtree_from(data, index)
    return child^


struct InlineKeyboardButton(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native button value; equality follows the upstream identity attribute subset."""

    comptime MIN_CALLBACK_DATA = 1
    comptime MAX_CALLBACK_DATA = 64

    var text: String
    var url: Optional[String]
    var login_url: Optional[LoginUrl]
    var callback_data: Optional[String]
    var web_app: Optional[WebAppInfo]
    var switch_inline_query: Optional[String]
    var switch_inline_query_current_chat: Optional[String]
    var callback_game: Optional[CallbackGame]
    var pay: Optional[Bool]
    var switch_inline_query_chosen_chat: Optional[SwitchInlineQueryChosenChat]
    var copy_text: Optional[CopyTextButton]
    var style: Optional[String]
    var icon_custom_emoji_id: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        text: String,
        url: Optional[String] = None,
        callback_data: Optional[String] = None,
        switch_inline_query: Optional[String] = None,
        switch_inline_query_current_chat: Optional[String] = None,
        callback_game: Optional[CallbackGame] = None,
        pay: Optional[Bool] = None,
        login_url: Optional[LoginUrl] = None,
        web_app: Optional[WebAppInfo] = None,
        switch_inline_query_chosen_chat: Optional[SwitchInlineQueryChosenChat] = None,
        copy_text: Optional[CopyTextButton] = None,
        style: Optional[String] = None,
        icon_custom_emoji_id: Optional[String] = None,
    ):
        self.text = text.copy()
        self.url = url.copy()
        self.login_url = login_url.copy()
        self.callback_data = callback_data.copy()
        self.web_app = web_app.copy()
        self.switch_inline_query = switch_inline_query.copy()
        self.switch_inline_query_current_chat = switch_inline_query_current_chat.copy()
        self.callback_game = callback_game.copy()
        self.pay = pay
        self.switch_inline_query_chosen_chat = switch_inline_query_chosen_chat.copy()
        self.copy_text = copy_text.copy()
        self.style = style.copy()
        self.icon_custom_emoji_id = icon_custom_emoji_id.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        url: Optional[String] = None,
        callback_data: Optional[String] = None,
        switch_inline_query: Optional[String] = None,
        switch_inline_query_current_chat: Optional[String] = None,
        callback_game: Optional[CallbackGame] = None,
        pay: Optional[Bool] = None,
        login_url: Optional[LoginUrl] = None,
        web_app: Optional[WebAppInfo] = None,
        switch_inline_query_chosen_chat: Optional[SwitchInlineQueryChosenChat] = None,
        copy_text: Optional[CopyTextButton] = None,
        style: Optional[String] = None,
        icon_custom_emoji_id: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.text = text.copy()
        self.url = url.copy()
        self.login_url = login_url.copy()
        self.callback_data = callback_data.copy()
        self.web_app = web_app.copy()
        self.switch_inline_query = switch_inline_query.copy()
        self.switch_inline_query_current_chat = switch_inline_query_current_chat.copy()
        self.callback_game = callback_game.copy()
        self.pay = pay
        self.switch_inline_query_chosen_chat = switch_inline_query_chosen_chat.copy()
        self.copy_text = copy_text.copy()
        self.style = style.copy()
        self.icon_custom_emoji_id = icon_custom_emoji_id.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.url = existing.url.copy()
        self.login_url = existing.login_url.copy()
        self.callback_data = existing.callback_data.copy()
        self.web_app = existing.web_app.copy()
        self.switch_inline_query = existing.switch_inline_query.copy()
        self.switch_inline_query_current_chat = existing.switch_inline_query_current_chat.copy()
        self.callback_game = existing.callback_game.copy()
        self.pay = existing.pay
        self.switch_inline_query_chosen_chat = existing.switch_inline_query_chosen_chat.copy()
        self.copy_text = existing.copy_text.copy()
        self.style = existing.style.copy()
        self.icon_custom_emoji_id = existing.icon_custom_emoji_id.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        # Upstream _id_attrs excludes copy_text and switch_inline_query_chosen_chat.
        var same_callback_game = self.callback_game is None and other.callback_game is None
        if self.callback_game is not None and other.callback_game is not None:
            same_callback_game = True  # CallbackGame has an empty identity tuple upstream.
        return (
            self.text == other.text
            and self.url == other.url
            and self.login_url == other.login_url
            and self.callback_data == other.callback_data
            and self.web_app == other.web_app
            and self.switch_inline_query == other.switch_inline_query
            and self.switch_inline_query_current_chat == other.switch_inline_query_current_chat
            and same_callback_game
            and self.pay == other.pay
            and self.style == other.style
            and self.icon_custom_emoji_id == other.icon_custom_emoji_id
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        # Text is part of every identity tuple, so this is a valid, if collision-prone, hash.
        hasher.update(String("InlineKeyboardButton\0").as_bytes())
        hasher.update(self.text.as_bytes())

    def update_callback_data(mut self, callback_data: String):
        self.callback_data = Optional[String](callback_data.copy())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.callback_data is not None:
            result.set_string(result.root, "callback_data", self.callback_data.value())
        if self.callback_game is not None:
            var nested = self.callback_game.value().to_dict(recursive)
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "callback_game", index)
        if self.copy_text is not None:
            var nested = self.copy_text.value().to_dict(recursive)
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "copy_text", index)
        if self.icon_custom_emoji_id is not None:
            result.set_string(result.root, "icon_custom_emoji_id", self.icon_custom_emoji_id.value())
        if self.login_url is not None:
            var nested = self.login_url.value().to_dict(recursive)
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "login_url", index)
        if self.pay is not None:
            result.set_boolean(result.root, "pay", self.pay.value())
        if self.style is not None:
            result.set_string(result.root, "style", self.style.value())
        if self.switch_inline_query is not None:
            result.set_string(result.root, "switch_inline_query", self.switch_inline_query.value())
        if self.switch_inline_query_chosen_chat is not None:
            var nested = self.switch_inline_query_chosen_chat.value().to_dict(recursive)
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "switch_inline_query_chosen_chat", index)
        if self.switch_inline_query_current_chat is not None:
            result.set_string(
                result.root, "switch_inline_query_current_chat", self.switch_inline_query_current_chat.value()
            )
        result.set_string(result.root, "text", self.text)
        if self.url is not None:
            result.set_string(result.root, "url", self.url.value())
        if self.web_app is not None:
            var nested = self.web_app.value().to_dict(recursive)
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "web_app", index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineKeyboardButton JSON value must be an object")
        var text_index = data.object_get(data.root, "text")
        if text_index == -1:
            raise Error("InlineKeyboardButton JSON object is missing 'text'")
        var url = _inline_button_string(data, "url")
        var callback_data = _inline_button_string(data, "callback_data")
        var switch_inline_query = _inline_button_string(data, "switch_inline_query")
        var switch_inline_query_current_chat = _inline_button_string(
            data, "switch_inline_query_current_chat"
        )
        var pay = _inline_button_bool(data, "pay")
        var style = _inline_button_string(data, "style")
        var icon_custom_emoji_id = _inline_button_string(data, "icon_custom_emoji_id")

        var callback_game: Optional[CallbackGame] = None
        var callback_game_index = data.object_get(data.root, "callback_game")
        if callback_game_index != -1 and not data.is_null(callback_game_index):
            callback_game = Optional[CallbackGame](CallbackGame.de_json(_inline_button_child(data, "callback_game")))
        var login_url: Optional[LoginUrl] = None
        var login_url_index = data.object_get(data.root, "login_url")
        if login_url_index != -1 and not data.is_null(login_url_index):
            login_url = Optional[LoginUrl](LoginUrl.de_json(_inline_button_child(data, "login_url")))
        var web_app: Optional[WebAppInfo] = None
        var web_app_index = data.object_get(data.root, "web_app")
        if web_app_index != -1 and not data.is_null(web_app_index):
            web_app = Optional[WebAppInfo](WebAppInfo.de_json(_inline_button_child(data, "web_app")))
        var chosen_chat: Optional[SwitchInlineQueryChosenChat] = None
        var chosen_chat_index = data.object_get(data.root, "switch_inline_query_chosen_chat")
        if chosen_chat_index != -1 and not data.is_null(chosen_chat_index):
            chosen_chat = Optional[SwitchInlineQueryChosenChat](
                SwitchInlineQueryChosenChat.de_json(_inline_button_child(data, "switch_inline_query_chosen_chat"))
            )
        var copy_text: Optional[CopyTextButton] = None
        var copy_text_index = data.object_get(data.root, "copy_text")
        if copy_text_index != -1 and not data.is_null(copy_text_index):
            copy_text = Optional[CopyTextButton](CopyTextButton.de_json(_inline_button_child(data, "copy_text")))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "text" and key != "url" and key != "login_url" and
                key != "callback_data" and key != "web_app" and key != "switch_inline_query" and
                key != "switch_inline_query_current_chat" and key != "callback_game" and
                key != "pay" and key != "switch_inline_query_chosen_chat" and key != "copy_text" and
                key != "style" and key != "icon_custom_emoji_id"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return InlineKeyboardButton(
            data.string_value(text_index), url, callback_data, switch_inline_query,
            switch_inline_query_current_chat, callback_game, pay, login_url, web_app,
            chosen_chat, copy_text, style, icon_custom_emoji_id, api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineKeyboardButton.de_json(items[index].copy()))
        return result^
