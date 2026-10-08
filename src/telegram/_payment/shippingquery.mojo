#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _payment/shippingquery.py.
# LGPL-3.0-or-later; see LICENSE.

"""Incoming shipping query data."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._payment.shippingaddress import ShippingAddress
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _shipping_query_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _shipping_query_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


struct ShippingQuery(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Shipping request; equality and hashing use its unique query ID."""

    var from_user: User
    var id: String
    var invoice_payload: String
    var shipping_address: ShippingAddress
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        from_user: User,
        invoice_payload: String,
        shipping_address: ShippingAddress,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.from_user = from_user.copy()
        self.id = id.copy()
        self.invoice_payload = invoice_payload.copy()
        self.shipping_address = shipping_address.copy()
        self.api_kwargs = _shipping_query_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.from_user = existing.from_user.copy()
        self.id = existing.id.copy()
        self.invoice_payload = existing.invoice_payload.copy()
        self.shipping_address = existing.shipping_address.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ShippingQuery\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var from_data = self.from_user.to_dict(recursive=recursive)
        var from_index = result.copy_subtree_from(from_data, from_data.root)
        result.object_set(result.root, "from", from_index)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "invoice_payload", self.invoice_payload)
        var address_data = self.shipping_address.to_dict(recursive=recursive)
        var address_index = result.copy_subtree_from(address_data, address_data.root)
        result.object_set(result.root, "shipping_address", address_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ShippingQuery JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var from_index = data.object_get(data.root, "from")
        var payload_index = data.object_get(data.root, "invoice_payload")
        var address_index = data.object_get(data.root, "shipping_address")
        if id_index == -1 or from_index == -1 or payload_index == -1 or address_index == -1:
            raise Error("ShippingQuery JSON object is missing a required field")
        var id = data.string_value(id_index)
        var from_user = User.de_json(_shipping_query_nested(data, from_index))
        var payload = data.string_value(payload_index)
        var address = ShippingAddress.de_json(_shipping_query_nested(data, address_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "id" and key != "from" and key != "invoice_payload" and key != "shipping_address":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            id,
            from_user,
            payload,
            address,
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
