#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 Story data model.
# LGPL-3.0-or-later; see LICENSE.

"""A story posted by a Telegram chat."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Story(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram story; identity consists of its chat and story ID."""

    var chat: Chat
    var id: Int
    var api_kwargs: JsonDocument

    def __init__(out self, chat: Chat, id: Int):
        self.chat = chat.copy()
        self.id = id
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat: Chat, id: Int, *, api_kwargs: JsonDocument):
        self.chat = chat.copy()
        self.id = id
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.id = existing.id
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.chat == other.chat and self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("Story\0").as_bytes())
        hasher.update(String(self.chat.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var chat_document = self.chat.to_dict(recursive=recursive)
        var chat_node = result.copy_subtree_from(chat_document, chat_document.root)
        result.object_set(result.root, "chat", chat_node)
        result.set_number(result.root, "id", String(self.id))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if (
            data.root < 0
            or data.root >= len(data.nodes)
            or data.nodes[data.root].kind != JSON_OBJECT
        ):
            raise Error("Story JSON value must be an object")

        var chat_index = data.object_get(data.root, "chat")
        var id_index = data.object_get(data.root, "id")
        if chat_index == -1 or data.is_null(chat_index) or id_index == -1 or data.is_null(id_index):
            raise Error("Story JSON object is missing chat or id")

        var chat_document = JsonDocument()
        chat_document.root = chat_document.copy_subtree_from(data, chat_index)
        var chat = Chat.de_json(chat_document)

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "chat" and key != "id":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Story(chat, data.integer_value(id_index), api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Story.de_json(items[index].copy()))
        return result^
