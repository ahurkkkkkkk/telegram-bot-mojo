#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _payment/invoice.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct Invoice(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream Invoice."""

    var title: String
    var description: String
    var start_parameter: String
    var currency: String
    var total_amount: Int
    var api_kwargs: JsonDocument

    def __init__(out self, title: String, description: String, start_parameter: String, currency: String, total_amount: Int):
        self.title = title
        self.description = description
        self.start_parameter = start_parameter
        self.currency = currency
        self.total_amount = total_amount
        self.api_kwargs = empty_json_object()

    def __init__(out self, title: String, description: String, start_parameter: String, currency: String, total_amount: Int, api_kwargs: JsonDocument):
        self.title = title
        self.description = description
        self.start_parameter = start_parameter
        self.currency = currency
        self.total_amount = total_amount
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.title = existing.title.copy()
        self.description = existing.description.copy()
        self.start_parameter = existing.start_parameter.copy()
        self.currency = existing.currency.copy()
        self.total_amount = existing.total_amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.title == other.title and self.description == other.description and self.start_parameter == other.start_parameter and self.currency == other.currency and self.total_amount == other.total_amount

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.title.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.description.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.start_parameter.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.currency.as_bytes())
        hasher.update(String("\0").as_bytes())
        var total_amount_hash_text = String(self.total_amount)
        hasher.update(total_amount_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "currency", self.currency)
        result.set_string(result.root, "description", self.description)
        result.set_string(result.root, "start_parameter", self.start_parameter)
        result.set_string(result.root, "title", self.title)
        result.set_number(result.root, "total_amount", String(self.total_amount))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Invoice:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Invoice JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Invoice JSON value is not an object")
        var parsed_title_index = data.object_get(data.root, "title")
        if parsed_title_index == -1:
            raise Error("Invoice JSON object is missing title")
        var parsed_title = data.string_value(parsed_title_index)
        var parsed_description_index = data.object_get(data.root, "description")
        if parsed_description_index == -1:
            raise Error("Invoice JSON object is missing description")
        var parsed_description = data.string_value(parsed_description_index)
        var parsed_start_parameter_index = data.object_get(data.root, "start_parameter")
        if parsed_start_parameter_index == -1:
            raise Error("Invoice JSON object is missing start_parameter")
        var parsed_start_parameter = data.string_value(parsed_start_parameter_index)
        var parsed_currency_index = data.object_get(data.root, "currency")
        if parsed_currency_index == -1:
            raise Error("Invoice JSON object is missing currency")
        var parsed_currency = data.string_value(parsed_currency_index)
        var parsed_total_amount_index = data.object_get(data.root, "total_amount")
        if parsed_total_amount_index == -1:
            raise Error("Invoice JSON object is missing total_amount")
        var parsed_total_amount = data.integer_value(parsed_total_amount_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "title" and key != "description" and key != "start_parameter" and key != "currency" and key != "total_amount":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Invoice(parsed_title, parsed_description, parsed_start_parameter, parsed_currency, parsed_total_amount, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Invoice]:
        var items = data.array_documents(array_index)
        var result = List[Invoice]()
        for index in range(len(items)):
            result.append(Invoice.de_json(items[index].copy()))
        return result^
