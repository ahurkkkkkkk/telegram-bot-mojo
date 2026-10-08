#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ShippingOption.
# LGPL-3.0-or-later; see LICENSE.

"""One Telegram shipping option with its itemized prices."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._payment.labeledprice import LabeledPrice
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ShippingOption(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A shipping option; equality is based on its unique ``id``."""

    var id: String
    var prices: List[LabeledPrice]
    var title: String
    var api_kwargs: JsonDocument

    def __init__(out self, id: String, title: String, prices: List[LabeledPrice]):
        self.id = id.copy()
        self.prices = List[LabeledPrice](copy=prices)
        self.title = title.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        title: String,
        prices: List[LabeledPrice],
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id.copy()
        self.prices = List[LabeledPrice](copy=prices)
        self.title = title.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.prices = List[LabeledPrice](copy=existing.prices)
        self.title = existing.title.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "id", self.id)
        if len(self.prices) > 0:
            var array = result.add_array()
            for price in self.prices:
                var item = price.to_dict(recursive=recursive)
                var copied = result.copy_subtree_from(item, item.root)
                result.append_child(array, copied)
            result.object_set(result.root, "prices", array)
        result.set_string(result.root, "title", self.title)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ShippingOption JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ShippingOption JSON value is not an object")
        var id_index = data.object_get(data.root, "id")
        var title_index = data.object_get(data.root, "title")
        var prices_index = data.object_get(data.root, "prices")
        if id_index == -1 or title_index == -1 or prices_index == -1:
            raise Error("ShippingOption JSON object is missing a required field")
        if data.nodes[prices_index].kind != JSON_ARRAY:
            raise Error("ShippingOption prices field is not an array")

        var id = data.string_value(id_index)
        var title = data.string_value(title_index)
        var price_documents = data.array_documents(prices_index)
        var prices = List[LabeledPrice]()
        for index in range(len(price_documents)):
            prices.append(LabeledPrice.de_json(price_documents[index].copy()))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "id" and key != "title" and key != "prices":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return ShippingOption(id, title, prices, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ShippingOption.de_json(items[index].copy()))
        return result^
