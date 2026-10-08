#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 chat-owner service values.
# LGPL-3.0-or-later; see LICENSE.

"""Service-message models for chat ownership changes."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ChatOwnerChanged(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A service event naming the new chat owner."""

    var new_owner: User
    var api_kwargs: JsonDocument

    def __init__(out self, new_owner: User):
        self.new_owner = new_owner.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, new_owner: User, *, api_kwargs: JsonDocument):
        self.new_owner = new_owner.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.new_owner = existing.new_owner.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.new_owner == other.new_owner

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.new_owner.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var owner = self.new_owner.to_dict(recursive=recursive)
        var owner_node = result.copy_subtree_from(owner, owner.root)
        result.object_set(result.root, "new_owner", owner_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatOwnerChanged JSON value is not an object")
        var owner_index = data.object_get(data.root, "new_owner")
        if owner_index == -1 or data.is_null(owner_index):
            raise Error("ChatOwnerChanged JSON object is missing new_owner")
        var owner_document = JsonDocument()
        owner_document.root = owner_document.copy_subtree_from(data, owner_index)
        var owner = User.de_json(owner_document)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "new_owner":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatOwnerChanged(owner, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ChatOwnerChanged.de_json(items[index].copy()))
        return result^


struct ChatOwnerLeft(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A service event that may identify a replacement chat owner."""

    var new_owner: Optional[User]
    var api_kwargs: JsonDocument

    def __init__(out self, new_owner: Optional[User] = None):
        self.new_owner = new_owner.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, new_owner: Optional[User] = None, *, api_kwargs: JsonDocument):
        self.new_owner = new_owner.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.new_owner = existing.new_owner.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.new_owner is None or other.new_owner is None:
            return self.new_owner is None and other.new_owner is None
        return self.new_owner.value() == other.new_owner.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.new_owner is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(String(self.new_owner.value().id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.new_owner is not None:
            var owner = self.new_owner.value().to_dict(recursive=recursive)
            var owner_node = result.copy_subtree_from(owner, owner.root)
            result.object_set(result.root, "new_owner", owner_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatOwnerLeft JSON value is not an object")
        var new_owner: Optional[User] = None
        var owner_index = data.object_get(data.root, "new_owner")
        if owner_index != -1 and not data.is_null(owner_index):
            var owner_document = JsonDocument()
            owner_document.root = owner_document.copy_subtree_from(data, owner_index)
            new_owner = Optional[User](User.de_json(owner_document))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "new_owner":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatOwnerLeft(new_owner, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ChatOwnerLeft.de_json(items[index].copy()))
        return result^
