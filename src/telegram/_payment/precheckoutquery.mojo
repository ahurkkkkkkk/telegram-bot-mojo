#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _payment/precheckoutquery.py.
# LGPL-3.0-or-later; see LICENSE.

"""Incoming pre-checkout query data."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._payment.orderinfo import OrderInfo
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _precheckout_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _precheckout_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


struct PreCheckoutQuery(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Payment confirmation request; equality and hashing use the query ID."""

    var currency: String
    var from_user: User
    var id: String
    var invoice_payload: String
    var order_info: Optional[OrderInfo]
    var shipping_option_id: Optional[String]
    var total_amount: Int
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        from_user: User,
        currency: String,
        total_amount: Int,
        invoice_payload: String,
        shipping_option_id: Optional[String] = None,
        order_info: Optional[OrderInfo] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.currency = currency.copy()
        self.from_user = from_user.copy()
        self.id = id.copy()
        self.invoice_payload = invoice_payload.copy()
        self.order_info = order_info.copy()
        self.shipping_option_id = shipping_option_id.copy()
        self.total_amount = total_amount
        self.api_kwargs = _precheckout_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.currency = existing.currency.copy()
        self.from_user = existing.from_user.copy()
        self.id = existing.id.copy()
        self.invoice_payload = existing.invoice_payload.copy()
        self.order_info = existing.order_info.copy()
        self.shipping_option_id = existing.shipping_option_id.copy()
        self.total_amount = existing.total_amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("PreCheckoutQuery\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "currency", self.currency)
        var from_data = self.from_user.to_dict(recursive=recursive)
        var from_index = result.copy_subtree_from(from_data, from_data.root)
        result.object_set(result.root, "from", from_index)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "invoice_payload", self.invoice_payload)
        if self.order_info is not None:
            var order_data = self.order_info.value().to_dict(recursive=recursive)
            var order_index = result.copy_subtree_from(order_data, order_data.root)
            result.object_set(result.root, "order_info", order_index)
        if self.shipping_option_id is not None:
            result.set_string(result.root, "shipping_option_id", self.shipping_option_id.value())
        result.set_number(result.root, "total_amount", String(self.total_amount))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PreCheckoutQuery JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var from_index = data.object_get(data.root, "from")
        var currency_index = data.object_get(data.root, "currency")
        var amount_index = data.object_get(data.root, "total_amount")
        var payload_index = data.object_get(data.root, "invoice_payload")
        if id_index == -1 or from_index == -1 or currency_index == -1 or amount_index == -1 or payload_index == -1:
            raise Error("PreCheckoutQuery JSON object is missing a required field")
        var id = data.string_value(id_index)
        var from_user = User.de_json(_precheckout_nested(data, from_index))
        var currency = data.string_value(currency_index)
        var amount = data.integer_value(amount_index)
        var payload = data.string_value(payload_index)
        var shipping_option_id: Optional[String] = None
        var shipping_index = data.object_get(data.root, "shipping_option_id")
        if shipping_index != -1 and not data.is_null(shipping_index):
            shipping_option_id = Optional[String](data.string_value(shipping_index))
        var order_info: Optional[OrderInfo] = None
        var order_index = data.object_get(data.root, "order_info")
        if order_index != -1 and not data.is_null(order_index):
            order_info = Optional[OrderInfo](OrderInfo.de_json(_precheckout_nested(data, order_index)))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "currency" or key == "from" or key == "id" or
                key == "invoice_payload" or key == "order_info" or
                key == "shipping_option_id" or key == "total_amount"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            id,
            from_user,
            currency,
            amount,
            payload,
            shipping_option_id,
            order_info,
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
