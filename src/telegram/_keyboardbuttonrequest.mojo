#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _keyboardbuttonrequest.py."""

from telegram._telegramobject import TelegramJsonObject
from telegram._keyboardbuttonrequestchat import KeyboardButtonRequestChat
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct KeyboardButtonRequestManagedBot(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream KeyboardButtonRequestManagedBot."""

    var request_id: Int
    var suggested_name: Optional[String]
    var suggested_username: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, request_id: Int, suggested_name: Optional[String] = None, suggested_username: Optional[String] = None):
        self.request_id = request_id
        self.suggested_name = suggested_name
        self.suggested_username = suggested_username
        self.api_kwargs = empty_json_object()

    def __init__(out self, request_id: Int, suggested_name: Optional[String] = None, suggested_username: Optional[String] = None, *, api_kwargs: JsonDocument):
        self.request_id = request_id
        self.suggested_name = suggested_name
        self.suggested_username = suggested_username
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.request_id = existing.request_id
        self.suggested_name = existing.suggested_name
        self.suggested_username = existing.suggested_username
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.request_id == other.request_id

    def __hash__[H: Hasher](self, mut hasher: H):
        var request_id_hash_text = String(self.request_id)
        hasher.update(request_id_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "request_id", String(self.request_id))
        if self.suggested_name is not None:
            result.set_string(result.root, "suggested_name", self.suggested_name.value())
        if self.suggested_username is not None:
            result.set_string(result.root, "suggested_username", self.suggested_username.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> KeyboardButtonRequestManagedBot:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("KeyboardButtonRequestManagedBot JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("KeyboardButtonRequestManagedBot JSON value is not an object")
        var parsed_request_id_index = data.object_get(data.root, "request_id")
        if parsed_request_id_index == -1:
            raise Error("KeyboardButtonRequestManagedBot JSON object is missing request_id")
        var parsed_request_id = data.integer_value(parsed_request_id_index)
        var parsed_suggested_name_index = data.object_get(data.root, "suggested_name")
        var parsed_suggested_name: Optional[String] = None
        if parsed_suggested_name_index != -1 and not data.is_null(parsed_suggested_name_index):
            parsed_suggested_name = Optional[String](data.string_value(parsed_suggested_name_index))
        var parsed_suggested_username_index = data.object_get(data.root, "suggested_username")
        var parsed_suggested_username: Optional[String] = None
        if parsed_suggested_username_index != -1 and not data.is_null(parsed_suggested_username_index):
            parsed_suggested_username = Optional[String](data.string_value(parsed_suggested_username_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "request_id" and key != "suggested_name" and key != "suggested_username":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return KeyboardButtonRequestManagedBot(parsed_request_id, parsed_suggested_name, parsed_suggested_username, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[KeyboardButtonRequestManagedBot]:
        var items = data.array_documents(array_index)
        var result = List[KeyboardButtonRequestManagedBot]()
        for index in range(len(items)):
            result.append(KeyboardButtonRequestManagedBot.de_json(items[index].copy()))
        return result^
struct KeyboardButtonRequestUsers(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream KeyboardButtonRequestUsers."""

    var request_id: Int
    var user_is_bot: Optional[Bool]
    var user_is_premium: Optional[Bool]
    var max_quantity: Optional[Int]
    var request_name: Optional[Bool]
    var request_username: Optional[Bool]
    var request_photo: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, request_id: Int, user_is_bot: Optional[Bool] = None, user_is_premium: Optional[Bool] = None, max_quantity: Optional[Int] = None, request_name: Optional[Bool] = None, request_username: Optional[Bool] = None, request_photo: Optional[Bool] = None):
        self.request_id = request_id
        self.user_is_bot = user_is_bot
        self.user_is_premium = user_is_premium
        self.max_quantity = max_quantity
        self.request_name = request_name
        self.request_username = request_username
        self.request_photo = request_photo
        self.api_kwargs = empty_json_object()

    def __init__(out self, request_id: Int, user_is_bot: Optional[Bool] = None, user_is_premium: Optional[Bool] = None, max_quantity: Optional[Int] = None, request_name: Optional[Bool] = None, request_username: Optional[Bool] = None, request_photo: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.request_id = request_id
        self.user_is_bot = user_is_bot
        self.user_is_premium = user_is_premium
        self.max_quantity = max_quantity
        self.request_name = request_name
        self.request_username = request_username
        self.request_photo = request_photo
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.request_id = existing.request_id
        self.user_is_bot = existing.user_is_bot
        self.user_is_premium = existing.user_is_premium
        self.max_quantity = existing.max_quantity
        self.request_name = existing.request_name
        self.request_username = existing.request_username
        self.request_photo = existing.request_photo
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.request_id == other.request_id

    def __hash__[H: Hasher](self, mut hasher: H):
        var request_id_hash_text = String(self.request_id)
        hasher.update(request_id_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.max_quantity is not None:
            result.set_number(result.root, "max_quantity", String(self.max_quantity.value()))
        result.set_number(result.root, "request_id", String(self.request_id))
        if self.request_name is not None:
            result.set_boolean(result.root, "request_name", self.request_name.value())
        if self.request_photo is not None:
            result.set_boolean(result.root, "request_photo", self.request_photo.value())
        if self.request_username is not None:
            result.set_boolean(result.root, "request_username", self.request_username.value())
        if self.user_is_bot is not None:
            result.set_boolean(result.root, "user_is_bot", self.user_is_bot.value())
        if self.user_is_premium is not None:
            result.set_boolean(result.root, "user_is_premium", self.user_is_premium.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> KeyboardButtonRequestUsers:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("KeyboardButtonRequestUsers JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("KeyboardButtonRequestUsers JSON value is not an object")
        var parsed_request_id_index = data.object_get(data.root, "request_id")
        if parsed_request_id_index == -1:
            raise Error("KeyboardButtonRequestUsers JSON object is missing request_id")
        var parsed_request_id = data.integer_value(parsed_request_id_index)
        var parsed_user_is_bot_index = data.object_get(data.root, "user_is_bot")
        var parsed_user_is_bot: Optional[Bool] = None
        if parsed_user_is_bot_index != -1 and not data.is_null(parsed_user_is_bot_index):
            parsed_user_is_bot = Optional[Bool](data.boolean_value(parsed_user_is_bot_index))
        var parsed_user_is_premium_index = data.object_get(data.root, "user_is_premium")
        var parsed_user_is_premium: Optional[Bool] = None
        if parsed_user_is_premium_index != -1 and not data.is_null(parsed_user_is_premium_index):
            parsed_user_is_premium = Optional[Bool](data.boolean_value(parsed_user_is_premium_index))
        var parsed_max_quantity_index = data.object_get(data.root, "max_quantity")
        var parsed_max_quantity: Optional[Int] = None
        if parsed_max_quantity_index != -1 and not data.is_null(parsed_max_quantity_index):
            parsed_max_quantity = Optional[Int](data.integer_value(parsed_max_quantity_index))
        var parsed_request_name_index = data.object_get(data.root, "request_name")
        var parsed_request_name: Optional[Bool] = None
        if parsed_request_name_index != -1 and not data.is_null(parsed_request_name_index):
            parsed_request_name = Optional[Bool](data.boolean_value(parsed_request_name_index))
        var parsed_request_username_index = data.object_get(data.root, "request_username")
        var parsed_request_username: Optional[Bool] = None
        if parsed_request_username_index != -1 and not data.is_null(parsed_request_username_index):
            parsed_request_username = Optional[Bool](data.boolean_value(parsed_request_username_index))
        var parsed_request_photo_index = data.object_get(data.root, "request_photo")
        var parsed_request_photo: Optional[Bool] = None
        if parsed_request_photo_index != -1 and not data.is_null(parsed_request_photo_index):
            parsed_request_photo = Optional[Bool](data.boolean_value(parsed_request_photo_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "request_id" and key != "user_is_bot" and key != "user_is_premium" and key != "max_quantity" and key != "request_name" and key != "request_username" and key != "request_photo":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return KeyboardButtonRequestUsers(parsed_request_id, parsed_user_is_bot, parsed_user_is_premium, parsed_max_quantity, parsed_request_name, parsed_request_username, parsed_request_photo, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[KeyboardButtonRequestUsers]:
        var items = data.array_documents(array_index)
        var result = List[KeyboardButtonRequestUsers]()
        for index in range(len(items)):
            result.append(KeyboardButtonRequestUsers.de_json(items[index].copy()))
        return result^
