#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 managed-bot events.
# LGPL-3.0-or-later; see LICENSE.

"""Managed-bot creation and update event values."""

from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _managedbot_required_user(data: JsonDocument, key: String) raises -> User:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        raise Error(String("Managed bot event is missing required ", key, " user"))
    var nested = JsonDocument()
    nested.root = nested.copy_subtree_from(data, index)
    return User.de_json(nested)


def _managedbot_api_kwargs(data: JsonDocument, excluded: String) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var is_excluded = (excluded == "bot" and key == "bot") or (
            excluded == "bot|user" and (key == "bot" or key == "user")
        )
        if not is_excluded:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct ManagedBotCreated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Event containing the User record for a newly managed bot."""

    var bot: User
    var api_kwargs: JsonDocument

    def __init__(out self, bot: User):
        self.bot = bot.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, bot: User, *, api_kwargs: JsonDocument):
        self.bot = bot.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.bot = existing.bot.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.bot == other.bot

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ManagedBotCreated\0").as_bytes())
        hasher.update(String(self.bot.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var bot_data = self.bot.to_dict(recursive)
        var bot_index = result.copy_subtree_from(bot_data, bot_data.root)
        result.object_set(result.root, "bot", bot_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ManagedBotCreated JSON value must be an object")
        var bot = _managedbot_required_user(data, "bot")
        var api_kwargs = _managedbot_api_kwargs(data, "bot")
        return Self(bot, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^


struct ManagedBotUpdated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Event containing the User records for a managed-bot ownership/update event."""

    var user: User
    var bot: User
    var api_kwargs: JsonDocument

    def __init__(out self, user: User, bot: User):
        self.user = user.copy()
        self.bot = bot.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, user: User, bot: User, *, api_kwargs: JsonDocument):
        self.user = user.copy()
        self.bot = bot.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.user = existing.user.copy()
        self.bot = existing.bot.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.user == other.user and self.bot == other.bot

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ManagedBotUpdated\0").as_bytes())
        hasher.update(String(self.user.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.bot.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var bot_data = self.bot.to_dict(recursive)
        var bot_index = result.copy_subtree_from(bot_data, bot_data.root)
        result.object_set(result.root, "bot", bot_index)
        var user_data = self.user.to_dict(recursive)
        var user_index = result.copy_subtree_from(user_data, user_data.root)
        result.object_set(result.root, "user", user_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ManagedBotUpdated JSON value must be an object")
        var user = _managedbot_required_user(data, "user")
        var bot = _managedbot_required_user(data, "bot")
        var api_kwargs = _managedbot_api_kwargs(data, "bot|user")
        return Self(user, bot, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
