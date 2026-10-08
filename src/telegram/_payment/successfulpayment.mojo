#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _payment/successfulpayment.py.
# LGPL-3.0-or-later; see LICENSE.

"""A successfully completed Telegram payment."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._payment.orderinfo import OrderInfo
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _successful_payment_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _successful_payment_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


struct SuccessfulPayment(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Payment record; identity is the pair of provider/Telegram charge IDs."""

    var currency: String
    var invoice_payload: String
    var is_first_recurring: Optional[Bool]
    var is_recurring: Optional[Bool]
    var order_info: Optional[OrderInfo]
    var provider_payment_charge_id: String
    var shipping_option_id: Optional[String]
    var subscription_expiration_date: Optional[TimestampDateTime]
    var telegram_payment_charge_id: String
    var total_amount: Int
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        currency: String,
        total_amount: Int,
        invoice_payload: String,
        telegram_payment_charge_id: String,
        provider_payment_charge_id: String,
        shipping_option_id: Optional[String] = None,
        order_info: Optional[OrderInfo] = None,
        subscription_expiration_date: Optional[TimestampDateTime] = None,
        is_recurring: Optional[Bool] = None,
        is_first_recurring: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.currency = currency.copy()
        self.invoice_payload = invoice_payload.copy()
        self.is_first_recurring = is_first_recurring
        self.is_recurring = is_recurring
        self.order_info = order_info.copy()
        self.provider_payment_charge_id = provider_payment_charge_id.copy()
        self.shipping_option_id = shipping_option_id.copy()
        self.subscription_expiration_date = subscription_expiration_date.copy()
        self.telegram_payment_charge_id = telegram_payment_charge_id.copy()
        self.total_amount = total_amount
        self.api_kwargs = _successful_payment_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.currency = existing.currency.copy()
        self.invoice_payload = existing.invoice_payload.copy()
        self.is_first_recurring = existing.is_first_recurring
        self.is_recurring = existing.is_recurring
        self.order_info = existing.order_info.copy()
        self.provider_payment_charge_id = existing.provider_payment_charge_id.copy()
        self.shipping_option_id = existing.shipping_option_id.copy()
        self.subscription_expiration_date = existing.subscription_expiration_date.copy()
        self.telegram_payment_charge_id = existing.telegram_payment_charge_id.copy()
        self.total_amount = existing.total_amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.telegram_payment_charge_id == other.telegram_payment_charge_id
            and self.provider_payment_charge_id == other.provider_payment_charge_id
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("SuccessfulPayment\0").as_bytes())
        hasher.update(self.telegram_payment_charge_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.provider_payment_charge_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "currency", self.currency)
        result.set_string(result.root, "invoice_payload", self.invoice_payload)
        if self.is_first_recurring is not None:
            result.set_boolean(result.root, "is_first_recurring", self.is_first_recurring.value())
        if self.is_recurring is not None:
            result.set_boolean(result.root, "is_recurring", self.is_recurring.value())
        if self.order_info is not None:
            var order_data = self.order_info.value().to_dict(recursive=recursive)
            var order_index = result.copy_subtree_from(order_data, order_data.root)
            result.object_set(result.root, "order_info", order_index)
        result.set_string(result.root, "provider_payment_charge_id", self.provider_payment_charge_id)
        if self.shipping_option_id is not None:
            result.set_string(result.root, "shipping_option_id", self.shipping_option_id.value())
        if self.subscription_expiration_date is not None:
            result.set_number(
                result.root,
                "subscription_expiration_date",
                String(to_timestamp(self.subscription_expiration_date.value())),
            )
        result.set_string(result.root, "telegram_payment_charge_id", self.telegram_payment_charge_id)
        result.set_number(result.root, "total_amount", String(self.total_amount))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("SuccessfulPayment JSON value must be an object")
        var currency_index = data.object_get(data.root, "currency")
        var amount_index = data.object_get(data.root, "total_amount")
        var payload_index = data.object_get(data.root, "invoice_payload")
        var telegram_charge_index = data.object_get(data.root, "telegram_payment_charge_id")
        var provider_charge_index = data.object_get(data.root, "provider_payment_charge_id")
        if (
            currency_index == -1 or amount_index == -1 or payload_index == -1 or
            telegram_charge_index == -1 or provider_charge_index == -1
        ):
            raise Error("SuccessfulPayment JSON object is missing a required field")
        var currency = data.string_value(currency_index)
        var amount = data.integer_value(amount_index)
        var payload = data.string_value(payload_index)
        var telegram_charge_id = data.string_value(telegram_charge_index)
        var provider_charge_id = data.string_value(provider_charge_index)
        var shipping_option_id: Optional[String] = None
        var shipping_index = data.object_get(data.root, "shipping_option_id")
        if shipping_index != -1 and not data.is_null(shipping_index):
            shipping_option_id = Optional[String](data.string_value(shipping_index))
        var order_info: Optional[OrderInfo] = None
        var order_index = data.object_get(data.root, "order_info")
        if order_index != -1 and not data.is_null(order_index):
            order_info = Optional[OrderInfo](OrderInfo.de_json(_successful_payment_nested(data, order_index)))
        var expiration_date: Optional[TimestampDateTime] = None
        var expiration_index = data.object_get(data.root, "subscription_expiration_date")
        if expiration_index != -1 and not data.is_null(expiration_index):
            expiration_date = Optional[TimestampDateTime](
                from_timestamp(data.integer_value(expiration_index))
            )
        var is_recurring: Optional[Bool] = None
        var recurring_index = data.object_get(data.root, "is_recurring")
        if recurring_index != -1 and not data.is_null(recurring_index):
            is_recurring = Optional[Bool](data.boolean_value(recurring_index))
        var is_first_recurring: Optional[Bool] = None
        var first_recurring_index = data.object_get(data.root, "is_first_recurring")
        if first_recurring_index != -1 and not data.is_null(first_recurring_index):
            is_first_recurring = Optional[Bool](data.boolean_value(first_recurring_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "currency" or key == "invoice_payload" or key == "is_first_recurring" or
                key == "is_recurring" or key == "order_info" or key == "provider_payment_charge_id" or
                key == "shipping_option_id" or key == "subscription_expiration_date" or
                key == "telegram_payment_charge_id" or key == "total_amount"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            currency,
            amount,
            payload,
            telegram_charge_id,
            provider_charge_id,
            shipping_option_id,
            order_info,
            expiration_date,
            is_recurring,
            is_first_recurring,
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^

