#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from staramount.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct StarAmount(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream StarAmount."""

    var amount: Int
    var nanostar_amount: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, amount: Int, nanostar_amount: Optional[Int] = None):
        self.amount = amount
        self.nanostar_amount = nanostar_amount
        self.api_kwargs = empty_json_object()

    def __init__(out self, amount: Int, nanostar_amount: Optional[Int] = None, *, api_kwargs: JsonDocument):
        self.amount = amount
        self.nanostar_amount = nanostar_amount
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.amount = existing.amount
        self.nanostar_amount = existing.nanostar_amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.amount == other.amount and self.nanostar_amount == other.nanostar_amount

    def __hash__[H: Hasher](self, mut hasher: H):
        var amount_hash_text = String(self.amount)
        hasher.update(amount_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.nanostar_amount is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            var nanostar_amount_hash_text = String(self.nanostar_amount.value())
            hasher.update(nanostar_amount_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "amount", String(self.amount))
        if self.nanostar_amount is not None:
            result.set_number(result.root, "nanostar_amount", String(self.nanostar_amount.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> StarAmount:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("StarAmount JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("StarAmount JSON value is not an object")
        var parsed_amount_index = data.object_get(data.root, "amount")
        if parsed_amount_index == -1:
            raise Error("StarAmount JSON object is missing amount")
        var parsed_amount = data.integer_value(parsed_amount_index)
        var parsed_nanostar_amount_index = data.object_get(data.root, "nanostar_amount")
        var parsed_nanostar_amount: Optional[Int] = None
        if parsed_nanostar_amount_index != -1 and not data.is_null(parsed_nanostar_amount_index):
            parsed_nanostar_amount = Optional[Int](data.integer_value(parsed_nanostar_amount_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "amount" and key != "nanostar_amount":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return StarAmount(parsed_amount, parsed_nanostar_amount, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[StarAmount]:
        var items = data.array_documents(array_index)
        var result = List[StarAmount]()
        for index in range(len(items)):
            result.append(StarAmount.de_json(items[index].copy()))
        return result^
