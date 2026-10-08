#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 OrderInfo.
# LGPL-3.0-or-later; see LICENSE.

"""Optional contact and shipping information for a payment order."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._payment.shippingaddress import ShippingAddress
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct OrderInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Order contact fields and optional shipping address."""

    var name: Optional[String]
    var phone_number: Optional[String]
    var email: Optional[String]
    var shipping_address: Optional[ShippingAddress]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        name: Optional[String] = None,
        phone_number: Optional[String] = None,
        email: Optional[String] = None,
        shipping_address: Optional[ShippingAddress] = None,
    ):
        self.name = name
        self.phone_number = phone_number
        self.email = email
        self.shipping_address = shipping_address.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        name: Optional[String] = None,
        phone_number: Optional[String] = None,
        email: Optional[String] = None,
        shipping_address: Optional[ShippingAddress] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.name = name
        self.phone_number = phone_number
        self.email = email
        self.shipping_address = shipping_address.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name
        self.phone_number = existing.phone_number
        self.email = existing.email
        self.shipping_address = existing.shipping_address.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.name != other.name or self.phone_number != other.phone_number or self.email != other.email:
            return False
        if self.shipping_address is None or other.shipping_address is None:
            return self.shipping_address is None and other.shipping_address is None
        return self.shipping_address.value() == other.shipping_address.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.name is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(self.name.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.phone_number is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(self.phone_number.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.email is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(self.email.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.shipping_address is None:
            hasher.update(String("none").as_bytes())
        else:
            var address = self.shipping_address.value().copy()
            hasher.update(address.country_code.as_bytes())
            hasher.update(address.state.as_bytes())
            hasher.update(address.city.as_bytes())
            hasher.update(address.street_line1.as_bytes())
            hasher.update(address.street_line2.as_bytes())
            hasher.update(address.post_code.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.name is not None:
            result.set_string(result.root, "name", self.name.value())
        if self.phone_number is not None:
            result.set_string(result.root, "phone_number", self.phone_number.value())
        if self.email is not None:
            result.set_string(result.root, "email", self.email.value())
        if self.shipping_address is not None:
            var address = self.shipping_address.value().to_dict(recursive=recursive)
            var address_node = result.copy_subtree_from(address, address.root)
            result.object_set(result.root, "shipping_address", address_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("OrderInfo JSON value is not an object")
        var name: Optional[String] = None
        var name_index = data.object_get(data.root, "name")
        if name_index != -1 and not data.is_null(name_index):
            name = Optional[String](data.string_value(name_index))
        var phone_number: Optional[String] = None
        var phone_index = data.object_get(data.root, "phone_number")
        if phone_index != -1 and not data.is_null(phone_index):
            phone_number = Optional[String](data.string_value(phone_index))
        var email: Optional[String] = None
        var email_index = data.object_get(data.root, "email")
        if email_index != -1 and not data.is_null(email_index):
            email = Optional[String](data.string_value(email_index))
        var shipping_address: Optional[ShippingAddress] = None
        var address_index = data.object_get(data.root, "shipping_address")
        if address_index != -1 and not data.is_null(address_index):
            var address_document = JsonDocument()
            address_document.root = address_document.copy_subtree_from(data, address_index)
            shipping_address = Optional[ShippingAddress](ShippingAddress.de_json(address_document))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "name" and key != "phone_number" and key != "email" and key != "shipping_address":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return OrderInfo(name, phone_number, email, shipping_address, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(OrderInfo.de_json(items[index].copy()))
        return result^
