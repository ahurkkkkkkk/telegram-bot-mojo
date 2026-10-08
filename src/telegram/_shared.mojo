#!/usr/bin/env mojo
#
# Native Mojo translations of the shared-chat/user service models from PTB v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Values returned when a user shares selected users or a chat with the bot."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.photosize import PhotoSize
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._utils.usernames import get_full_name, get_link, get_name


def _shared_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _shared_photos_to_json(
    key: String, photos: Optional[List[PhotoSize]], mut result: JsonDocument
) raises:
    if photos is None:
        return
    var array = result.add_array()
    var items = photos.value().copy()
    for index in range(len(items)):
        var photo_data = items[index].to_dict()
        var photo = result.copy_subtree_from(photo_data, photo_data.root)
        result.append_child(array, photo)
    result.object_set(result.root, key, array)


def _shared_photos_from_json(data: JsonDocument, key: String) raises -> Optional[List[PhotoSize]]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    var items = data.array_documents(index)
    var result = List[PhotoSize]()
    for photo_data in items:
        result.append(PhotoSize.de_json(photo_data))
    return Optional[List[PhotoSize]](result^)


def _shared_photos_copy(photos: Optional[List[PhotoSize]]) -> Optional[List[PhotoSize]]:
    if photos is None:
        return None
    var result = List[PhotoSize]()
    var items = photos.value().copy()
    for index in range(len(items)):
        result.append(items[index].copy())
    return Optional[List[PhotoSize]](result^)


def _shared_photo_lists_equal(left: Optional[List[PhotoSize]], right: Optional[List[PhotoSize]]) -> Bool:
    if left is None or right is None:
        return left is None and right is None
    var left_items = left.value().copy()
    var right_items = right.value().copy()
    if len(left_items) != len(right_items):
        return False
    for index in range(len(left_items)):
        if left_items[index] != right_items[index]:
            return False
    return True


struct SharedUser(Equatable, Hashable, Copyable, TelegramJsonObject):
    """User identity and any name, username, and photo data shared with the bot."""

    var user_id: Int
    var first_name: Optional[String]
    var last_name: Optional[String]
    var username: Optional[String]
    var photo: Optional[List[PhotoSize]]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        user_id: Int,
        first_name: Optional[String] = None,
        last_name: Optional[String] = None,
        username: Optional[String] = None,
        photo: Optional[List[PhotoSize]] = None,
    ):
        self.user_id = user_id
        self.first_name = first_name.copy()
        self.last_name = last_name.copy()
        self.username = username.copy()
        self.photo = _shared_photos_copy(photo)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        user_id: Int,
        first_name: Optional[String] = None,
        last_name: Optional[String] = None,
        username: Optional[String] = None,
        photo: Optional[List[PhotoSize]] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.user_id = user_id
        self.first_name = first_name.copy()
        self.last_name = last_name.copy()
        self.username = username.copy()
        self.photo = _shared_photos_copy(photo)
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.user_id = existing.user_id
        self.first_name = existing.first_name.copy()
        self.last_name = existing.last_name.copy()
        self.username = existing.username.copy()
        self.photo = _shared_photos_copy(existing.photo)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.user_id == other.user_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.user_id).as_bytes())

    def name(self) -> Optional[String]:
        return get_name(self.username, self.first_name, self.last_name)

    def full_name(self) -> Optional[String]:
        return get_full_name(self.first_name, self.last_name)

    def link(self) -> Optional[String]:
        return get_link(self.username)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.first_name is not None:
            result.set_string(result.root, "first_name", self.first_name.value())
        if self.last_name is not None:
            result.set_string(result.root, "last_name", self.last_name.value())
        _shared_photos_to_json("photo", self.photo, result)
        if self.username is not None:
            result.set_string(result.root, "username", self.username.value())
        result.set_number(result.root, "user_id", String(self.user_id))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> SharedUser:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("SharedUser JSON value must be an object")
        var user_id_index = data.object_get(data.root, "user_id")
        if user_id_index == -1:
            raise Error("SharedUser JSON object is missing user_id")
        var user_id = data.integer_value(user_id_index)
        var first_name: Optional[String] = None
        var index = data.object_get(data.root, "first_name")
        if index != -1 and not data.is_null(index):
            first_name = Optional[String](data.string_value(index))
        var last_name: Optional[String] = None
        index = data.object_get(data.root, "last_name")
        if index != -1 and not data.is_null(index):
            last_name = Optional[String](data.string_value(index))
        var username: Optional[String] = None
        index = data.object_get(data.root, "username")
        if index != -1 and not data.is_null(index):
            username = Optional[String](data.string_value(index))
        var photo = _shared_photos_from_json(data, "photo")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "user_id" and key != "first_name" and key != "last_name" and key != "username" and key != "photo":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return SharedUser(user_id, first_name, last_name, username, photo, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[SharedUser]:
        var items = data.array_documents(array_index)
        var result = List[SharedUser]()
        for item in items:
            result.append(SharedUser.de_json(item))
        return result^


struct ChatShared(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Chat identity and optional metadata shared with the bot."""

    var request_id: Int
    var chat_id: Int
    var title: Optional[String]
    var username: Optional[String]
    var photo: Optional[List[PhotoSize]]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        request_id: Int,
        chat_id: Int,
        title: Optional[String] = None,
        username: Optional[String] = None,
        photo: Optional[List[PhotoSize]] = None,
    ):
        self.request_id = request_id
        self.chat_id = chat_id
        self.title = title.copy()
        self.username = username.copy()
        self.photo = _shared_photos_copy(photo)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        request_id: Int,
        chat_id: Int,
        title: Optional[String] = None,
        username: Optional[String] = None,
        photo: Optional[List[PhotoSize]] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.request_id = request_id
        self.chat_id = chat_id
        self.title = title.copy()
        self.username = username.copy()
        self.photo = _shared_photos_copy(photo)
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.request_id = existing.request_id
        self.chat_id = existing.chat_id
        self.title = existing.title.copy()
        self.username = existing.username.copy()
        self.photo = _shared_photos_copy(existing.photo)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.request_id == other.request_id and self.chat_id == other.chat_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.request_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.chat_id).as_bytes())

    def link(self) -> Optional[String]:
        return get_link(self.username)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "chat_id", String(self.chat_id))
        _shared_photos_to_json("photo", self.photo, result)
        result.set_number(result.root, "request_id", String(self.request_id))
        if self.title is not None:
            result.set_string(result.root, "title", self.title.value())
        if self.username is not None:
            result.set_string(result.root, "username", self.username.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatShared:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatShared JSON value must be an object")
        var request_id_index = data.object_get(data.root, "request_id")
        var chat_id_index = data.object_get(data.root, "chat_id")
        if request_id_index == -1 or chat_id_index == -1:
            raise Error("ChatShared JSON object is missing required fields")
        var request_id = data.integer_value(request_id_index)
        var chat_id = data.integer_value(chat_id_index)
        var title: Optional[String] = None
        var index = data.object_get(data.root, "title")
        if index != -1 and not data.is_null(index):
            title = Optional[String](data.string_value(index))
        var username: Optional[String] = None
        index = data.object_get(data.root, "username")
        if index != -1 and not data.is_null(index):
            username = Optional[String](data.string_value(index))
        var photo = _shared_photos_from_json(data, "photo")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "request_id" and key != "chat_id" and key != "title" and key != "username" and key != "photo":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatShared(request_id, chat_id, title, username, photo, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatShared]:
        var items = data.array_documents(array_index)
        var result = List[ChatShared]()
        for item in items:
            result.append(ChatShared.de_json(item))
        return result^


struct UsersShared(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The requested users shared from a Telegram keyboard."""

    var request_id: Int
    var users: List[SharedUser]
    var api_kwargs: JsonDocument

    def __init__(out self, request_id: Int, users: List[SharedUser]):
        self.request_id = request_id
        self.users = List[SharedUser](copy=users)
        self.api_kwargs = empty_json_object()

    def __init__(out self, request_id: Int, users: List[SharedUser], *, api_kwargs: JsonDocument):
        self.request_id = request_id
        self.users = List[SharedUser](copy=users)
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.request_id = existing.request_id
        self.users = List[SharedUser](copy=existing.users)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.request_id != other.request_id or len(self.users) != len(other.users):
            return False
        var left = self.users.copy()
        var right = other.users.copy()
        for index in range(len(left)):
            if left[index] != right[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.request_id).as_bytes())
        for user in self.users:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(user.user_id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "request_id", String(self.request_id))
        var array = result.add_array()
        var users = self.users.copy()
        for index in range(len(users)):
            var user_data = users[index].to_dict(recursive)
            var user = result.copy_subtree_from(user_data, user_data.root)
            result.append_child(array, user)
        result.object_set(result.root, "users", array)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> UsersShared:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UsersShared JSON value must be an object")
        var request_id_index = data.object_get(data.root, "request_id")
        var users_index = data.object_get(data.root, "users")
        if request_id_index == -1 or users_index == -1:
            raise Error("UsersShared JSON object is missing required fields")
        var request_id = data.integer_value(request_id_index)
        var users = List[SharedUser]()
        var user_documents = data.array_documents(users_index)
        for user_data in user_documents:
            users.append(SharedUser.de_json(user_data))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            # Preserve the removed legacy field user_ids as an API extension.
            if key != "request_id" and key != "users":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return UsersShared(request_id, users, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[UsersShared]:
        var items = data.array_documents(array_index)
        var result = List[UsersShared]()
        for item in items:
            result.append(UsersShared.de_json(item))
        return result^
