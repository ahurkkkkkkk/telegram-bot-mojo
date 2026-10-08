#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _suggestedpost.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct SuggestedPostPrice(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream SuggestedPostPrice."""

    var currency: String
    var amount: Int
    var api_kwargs: JsonDocument

    def __init__(out self, currency: String, amount: Int):
        self.currency = currency
        self.amount = amount
        self.api_kwargs = empty_json_object()

    def __init__(out self, currency: String, amount: Int, api_kwargs: JsonDocument):
        self.currency = currency
        self.amount = amount
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.currency = existing.currency.copy()
        self.amount = existing.amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.currency == other.currency and self.amount == other.amount

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.currency.as_bytes())
        hasher.update(String("\0").as_bytes())
        var amount_hash_text = String(self.amount)
        hasher.update(amount_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "amount", String(self.amount))
        result.set_string(result.root, "currency", self.currency)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> SuggestedPostPrice:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("SuggestedPostPrice JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("SuggestedPostPrice JSON value is not an object")
        var parsed_currency_index = data.object_get(data.root, "currency")
        if parsed_currency_index == -1:
            raise Error("SuggestedPostPrice JSON object is missing currency")
        var parsed_currency = data.string_value(parsed_currency_index)
        var parsed_amount_index = data.object_get(data.root, "amount")
        if parsed_amount_index == -1:
            raise Error("SuggestedPostPrice JSON object is missing amount")
        var parsed_amount = data.integer_value(parsed_amount_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "currency" and key != "amount":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return SuggestedPostPrice(parsed_currency, parsed_amount, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[SuggestedPostPrice]:
        var items = data.array_documents(array_index)
        var result = List[SuggestedPostPrice]()
        for index in range(len(items)):
            result.append(SuggestedPostPrice.de_json(items[index].copy()))
        return result^
