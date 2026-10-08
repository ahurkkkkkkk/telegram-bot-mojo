#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _loginurl.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct LoginUrl(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream LoginUrl."""

    var url: String
    var forward_text: Optional[String]
    var bot_username: Optional[String]
    var request_write_access: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, url: String, forward_text: Optional[String] = None, bot_username: Optional[String] = None, request_write_access: Optional[Bool] = None):
        self.url = url
        self.forward_text = forward_text
        self.bot_username = bot_username
        self.request_write_access = request_write_access
        self.api_kwargs = empty_json_object()

    def __init__(out self, url: String, forward_text: Optional[String] = None, bot_username: Optional[String] = None, request_write_access: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.url = url
        self.forward_text = forward_text
        self.bot_username = bot_username
        self.request_write_access = request_write_access
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.url = existing.url.copy()
        self.forward_text = existing.forward_text
        self.bot_username = existing.bot_username
        self.request_write_access = existing.request_write_access
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.url == other.url

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.url.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.bot_username is not None:
            result.set_string(result.root, "bot_username", self.bot_username.value())
        if self.forward_text is not None:
            result.set_string(result.root, "forward_text", self.forward_text.value())
        if self.request_write_access is not None:
            result.set_boolean(result.root, "request_write_access", self.request_write_access.value())
        result.set_string(result.root, "url", self.url)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> LoginUrl:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("LoginUrl JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("LoginUrl JSON value is not an object")
        var parsed_url_index = data.object_get(data.root, "url")
        if parsed_url_index == -1:
            raise Error("LoginUrl JSON object is missing url")
        var parsed_url = data.string_value(parsed_url_index)
        var parsed_forward_text_index = data.object_get(data.root, "forward_text")
        var parsed_forward_text: Optional[String] = None
        if parsed_forward_text_index != -1 and not data.is_null(parsed_forward_text_index):
            parsed_forward_text = Optional[String](data.string_value(parsed_forward_text_index))
        var parsed_bot_username_index = data.object_get(data.root, "bot_username")
        var parsed_bot_username: Optional[String] = None
        if parsed_bot_username_index != -1 and not data.is_null(parsed_bot_username_index):
            parsed_bot_username = Optional[String](data.string_value(parsed_bot_username_index))
        var parsed_request_write_access_index = data.object_get(data.root, "request_write_access")
        var parsed_request_write_access: Optional[Bool] = None
        if parsed_request_write_access_index != -1 and not data.is_null(parsed_request_write_access_index):
            parsed_request_write_access = Optional[Bool](data.boolean_value(parsed_request_write_access_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "url" and key != "forward_text" and key != "bot_username" and key != "request_write_access":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return LoginUrl(parsed_url, parsed_forward_text, parsed_bot_username, parsed_request_write_access, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[LoginUrl]:
        var items = data.array_documents(array_index)
        var result = List[LoginUrl]()
        for index in range(len(items)):
            result.append(LoginUrl.de_json(items[index].copy()))
        return result^
