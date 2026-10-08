#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 DirectMessagesTopic.
# LGPL-3.0-or-later; see LICENSE.

"""A direct-message topic identifier with optional creator information."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct DirectMessagesTopic(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A direct-message topic, equal by topic ID and optional creator."""

    var topic_id: Int
    var user: Optional[User]
    var api_kwargs: JsonDocument

    def __init__(out self, topic_id: Int, user: Optional[User] = None):
        self.topic_id = topic_id
        self.user = user.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        topic_id: Int,
        user: Optional[User] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.topic_id = topic_id
        self.user = user.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.topic_id = existing.topic_id
        self.user = existing.user.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.topic_id != other.topic_id:
            return False
        if self.user is None or other.user is None:
            return self.user is None and other.user is None
        return self.user.value() == other.user.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.topic_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.user is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(String(self.user.value().id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "topic_id", String(self.topic_id))
        if self.user is not None:
            var user = self.user.value().to_dict(recursive=recursive)
            var user_node = result.copy_subtree_from(user, user.root)
            result.object_set(result.root, "user", user_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("DirectMessagesTopic JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("DirectMessagesTopic JSON value is not an object")
        var topic_id_index = data.object_get(data.root, "topic_id")
        if topic_id_index == -1:
            raise Error("DirectMessagesTopic JSON object is missing topic_id")
        var topic_id = data.integer_value(topic_id_index)
        var user: Optional[User] = None
        var user_index = data.object_get(data.root, "user")
        if user_index != -1 and not data.is_null(user_index):
            var user_document = JsonDocument()
            user_document.root = user_document.copy_subtree_from(data, user_index)
            user = Optional[User](User.de_json(user_document))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "topic_id" and key != "user":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return DirectMessagesTopic(topic_id, user, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(DirectMessagesTopic.de_json(items[index].copy()))
        return result^
