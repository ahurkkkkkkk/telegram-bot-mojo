#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _paidmessagepricechanged.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct PaidMessagePriceChanged(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream PaidMessagePriceChanged."""

    var paid_message_star_count: Int
    var api_kwargs: JsonDocument

    def __init__(out self, paid_message_star_count: Int):
        self.paid_message_star_count = paid_message_star_count
        self.api_kwargs = empty_json_object()

    def __init__(out self, paid_message_star_count: Int, api_kwargs: JsonDocument):
        self.paid_message_star_count = paid_message_star_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.paid_message_star_count = existing.paid_message_star_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.paid_message_star_count == other.paid_message_star_count

    def __hash__[H: Hasher](self, mut hasher: H):
        var paid_message_star_count_hash_text = String(self.paid_message_star_count)
        hasher.update(paid_message_star_count_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "paid_message_star_count", String(self.paid_message_star_count))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> PaidMessagePriceChanged:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("PaidMessagePriceChanged JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PaidMessagePriceChanged JSON value is not an object")
        var parsed_paid_message_star_count_index = data.object_get(data.root, "paid_message_star_count")
        if parsed_paid_message_star_count_index == -1:
            raise Error("PaidMessagePriceChanged JSON object is missing paid_message_star_count")
        var parsed_paid_message_star_count = data.integer_value(parsed_paid_message_star_count_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "paid_message_star_count":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return PaidMessagePriceChanged(parsed_paid_message_star_count, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[PaidMessagePriceChanged]:
        var items = data.array_documents(array_index)
        var result = List[PaidMessagePriceChanged]()
        for index in range(len(items)):
            result.append(PaidMessagePriceChanged.de_json(items[index].copy()))
        return result^
