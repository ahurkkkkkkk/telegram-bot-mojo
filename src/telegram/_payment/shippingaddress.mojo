#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _payment/shippingaddress.py."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct ShippingAddress(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream ShippingAddress."""

    var country_code: String
    var state: String
    var city: String
    var street_line1: String
    var street_line2: String
    var post_code: String
    var api_kwargs: JsonDocument

    def __init__(out self, country_code: String, state: String, city: String, street_line1: String, street_line2: String, post_code: String):
        self.country_code = country_code
        self.state = state
        self.city = city
        self.street_line1 = street_line1
        self.street_line2 = street_line2
        self.post_code = post_code
        self.api_kwargs = empty_json_object()

    def __init__(out self, country_code: String, state: String, city: String, street_line1: String, street_line2: String, post_code: String, api_kwargs: JsonDocument):
        self.country_code = country_code
        self.state = state
        self.city = city
        self.street_line1 = street_line1
        self.street_line2 = street_line2
        self.post_code = post_code
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.country_code = existing.country_code.copy()
        self.state = existing.state.copy()
        self.city = existing.city.copy()
        self.street_line1 = existing.street_line1.copy()
        self.street_line2 = existing.street_line2.copy()
        self.post_code = existing.post_code.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.country_code == other.country_code and self.state == other.state and self.city == other.city and self.street_line1 == other.street_line1 and self.street_line2 == other.street_line2 and self.post_code == other.post_code

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.country_code.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.state.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.city.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.street_line1.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.street_line2.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.post_code.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "city", self.city)
        result.set_string(result.root, "country_code", self.country_code)
        result.set_string(result.root, "post_code", self.post_code)
        result.set_string(result.root, "state", self.state)
        result.set_string(result.root, "street_line1", self.street_line1)
        result.set_string(result.root, "street_line2", self.street_line2)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ShippingAddress:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ShippingAddress JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ShippingAddress JSON value is not an object")
        var parsed_country_code_index = data.object_get(data.root, "country_code")
        if parsed_country_code_index == -1:
            raise Error("ShippingAddress JSON object is missing country_code")
        var parsed_country_code = data.string_value(parsed_country_code_index)
        var parsed_state_index = data.object_get(data.root, "state")
        if parsed_state_index == -1:
            raise Error("ShippingAddress JSON object is missing state")
        var parsed_state = data.string_value(parsed_state_index)
        var parsed_city_index = data.object_get(data.root, "city")
        if parsed_city_index == -1:
            raise Error("ShippingAddress JSON object is missing city")
        var parsed_city = data.string_value(parsed_city_index)
        var parsed_street_line1_index = data.object_get(data.root, "street_line1")
        if parsed_street_line1_index == -1:
            raise Error("ShippingAddress JSON object is missing street_line1")
        var parsed_street_line1 = data.string_value(parsed_street_line1_index)
        var parsed_street_line2_index = data.object_get(data.root, "street_line2")
        if parsed_street_line2_index == -1:
            raise Error("ShippingAddress JSON object is missing street_line2")
        var parsed_street_line2 = data.string_value(parsed_street_line2_index)
        var parsed_post_code_index = data.object_get(data.root, "post_code")
        if parsed_post_code_index == -1:
            raise Error("ShippingAddress JSON object is missing post_code")
        var parsed_post_code = data.string_value(parsed_post_code_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "country_code" and key != "state" and key != "city" and key != "street_line1" and key != "street_line2" and key != "post_code":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ShippingAddress(parsed_country_code, parsed_state, parsed_city, parsed_street_line1, parsed_street_line2, parsed_post_code, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ShippingAddress]:
        var items = data.array_documents(array_index)
        var result = List[ShippingAddress]()
        for index in range(len(items)):
            result.append(ShippingAddress.de_json(items[index].copy()))
        return result^
