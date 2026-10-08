#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 BotAccessSettings.
# LGPL-3.0-or-later; see LICENSE.

"""The user allow-list settings of a managed bot."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _users_equal(left: List[User], right: List[User]) -> Bool:
    if len(left) != len(right):
        return False
    for index in range(len(left)):
        if left[index] != right[index]:
            return False
    return True


struct BotAccessSettings(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Restricts access to a bot and lists the additional users who may access it."""

    var is_access_restricted: Bool
    var added_users: List[User]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        is_access_restricted: Bool,
        added_users: Optional[List[User]] = None,
    ):
        self.is_access_restricted = is_access_restricted
        self.added_users = List[User]()
        if added_users is not None:
            self.added_users = List[User](copy=added_users.value())
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        is_access_restricted: Bool,
        added_users: Optional[List[User]] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.is_access_restricted = is_access_restricted
        self.added_users = List[User]()
        if added_users is not None:
            self.added_users = List[User](copy=added_users.value())
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.is_access_restricted = existing.is_access_restricted
        self.added_users = List[User](copy=existing.added_users)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.is_access_restricted == other.is_access_restricted
            and _users_equal(self.added_users, other.added_users)
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.is_access_restricted:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        for user in self.added_users:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(user.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "is_access_restricted", self.is_access_restricted)
        if len(self.added_users) > 0:
            var users_array = result.add_array()
            for user in self.added_users:
                var item = user.to_dict(recursive=recursive)
                var copied = result.copy_subtree_from(item, item.root)
                result.append_child(users_array, copied)
            result.object_set(result.root, "added_users", users_array)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BotAccessSettings JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BotAccessSettings JSON value is not an object")
        var restricted_index = data.object_get(data.root, "is_access_restricted")
        if restricted_index == -1:
            raise Error("BotAccessSettings JSON object is missing is_access_restricted")
        var is_access_restricted = data.boolean_value(restricted_index)
        var added_users = List[User]()
        var users_index = data.object_get(data.root, "added_users")
        if users_index != -1 and not data.is_null(users_index):
            var user_documents = data.array_documents(users_index)
            for index in range(len(user_documents)):
                added_users.append(User.de_json(user_documents[index].copy()))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "is_access_restricted" and key != "added_users":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        var added_users_value = Optional[List[User]](added_users^)
        return BotAccessSettings(
            is_access_restricted,
            added_users_value,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotAccessSettings.de_json(items[index].copy()))
        return result^
