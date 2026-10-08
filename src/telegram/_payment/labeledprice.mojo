#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _payment/labeledprice.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct LabeledPrice(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream LabeledPrice."""

    var label: String
    var amount: Int
    var api_kwargs: JsonDocument

    def __init__(out self, label: String, amount: Int):
        self.label = label
        self.amount = amount
        self.api_kwargs = empty_json_object()

    def __init__(out self, label: String, amount: Int, api_kwargs: JsonDocument):
        self.label = label
        self.amount = amount
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.label = existing.label.copy()
        self.amount = existing.amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.label == other.label and self.amount == other.amount

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.label.as_bytes())
        hasher.update(String("\0").as_bytes())
        var amount_hash_text = String(self.amount)
        hasher.update(amount_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "amount", String(self.amount))
        result.set_string(result.root, "label", self.label)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> LabeledPrice:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("LabeledPrice JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("LabeledPrice JSON value is not an object")
        var parsed_label_index = data.object_get(data.root, "label")
        if parsed_label_index == -1:
            raise Error("LabeledPrice JSON object is missing label")
        var parsed_label = data.string_value(parsed_label_index)
        var parsed_amount_index = data.object_get(data.root, "amount")
        if parsed_amount_index == -1:
            raise Error("LabeledPrice JSON object is missing amount")
        var parsed_amount = data.integer_value(parsed_amount_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "label" and key != "amount":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return LabeledPrice(parsed_label, parsed_amount, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[LabeledPrice]:
        var items = data.array_documents(array_index)
        var result = List[LabeledPrice]()
        for index in range(len(items)):
            result.append(LabeledPrice.de_json(items[index].copy()))
        return result^
