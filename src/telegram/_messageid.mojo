#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""A unique Telegram message identifier and its JSON conversion helpers."""

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JsonDocument, dumps_json
from std.hashlib.hasher import Hasher


def _empty_object() -> JsonDocument:
    var document = JsonDocument()
    var root = document.add_object()
    document.root = root
    return document^


struct MessageId(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a unique Telegram message identifier.

    Equality depends on ``message_id``, matching the upstream TelegramObject identity rule.
    """

    var message_id: Int
    var api_kwargs: JsonDocument

    def __init__(out self, message_id: Int):
        self.message_id = message_id
        self.api_kwargs = _empty_object()

    def __init__(out self, message_id: Int, api_kwargs: JsonDocument):
        self.message_id = message_id
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.message_id = existing.message_id
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_id == other.message_id

    def __hash__[H: Hasher](self, mut hasher: H):
        var message_id_text = String(self.message_id)
        hasher.update(message_id_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = _empty_object()
        result.set_number(result.root, "message_id", String(self.message_id))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("MessageId JSON document has no root")
        var message_id_node = data.object_get(data.root, "message_id")
        if message_id_node == -1:
            raise Error("MessageId JSON object is missing 'message_id'")
        var message_id = data.integer_value(message_id_node)
        var api_kwargs = _empty_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            if data.nodes[child].name != "message_id":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, data.nodes[child].name.copy(), copied)
            child = data.nodes[child].next_sibling
        return MessageId(message_id, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MessageId.de_json(items[index].copy()))
        return result^
