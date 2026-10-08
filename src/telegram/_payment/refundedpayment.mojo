#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from refundedpayment.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct RefundedPayment(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream RefundedPayment."""

    var currency: String
    var total_amount: Int
    var invoice_payload: String
    var telegram_payment_charge_id: String
    var provider_payment_charge_id: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, currency: String, total_amount: Int, invoice_payload: String, telegram_payment_charge_id: String, provider_payment_charge_id: Optional[String] = None):
        self.currency = currency
        self.total_amount = total_amount
        self.invoice_payload = invoice_payload
        self.telegram_payment_charge_id = telegram_payment_charge_id
        self.provider_payment_charge_id = provider_payment_charge_id
        self.api_kwargs = empty_json_object()

    def __init__(out self, currency: String, total_amount: Int, invoice_payload: String, telegram_payment_charge_id: String, provider_payment_charge_id: Optional[String] = None, *, api_kwargs: JsonDocument):
        self.currency = currency
        self.total_amount = total_amount
        self.invoice_payload = invoice_payload
        self.telegram_payment_charge_id = telegram_payment_charge_id
        self.provider_payment_charge_id = provider_payment_charge_id
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.currency = existing.currency.copy()
        self.total_amount = existing.total_amount
        self.invoice_payload = existing.invoice_payload.copy()
        self.telegram_payment_charge_id = existing.telegram_payment_charge_id.copy()
        self.provider_payment_charge_id = existing.provider_payment_charge_id
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.telegram_payment_charge_id == other.telegram_payment_charge_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.telegram_payment_charge_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "currency", self.currency)
        result.set_string(result.root, "invoice_payload", self.invoice_payload)
        if self.provider_payment_charge_id is not None:
            result.set_string(result.root, "provider_payment_charge_id", self.provider_payment_charge_id.value())
        result.set_string(result.root, "telegram_payment_charge_id", self.telegram_payment_charge_id)
        result.set_number(result.root, "total_amount", String(self.total_amount))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> RefundedPayment:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("RefundedPayment JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("RefundedPayment JSON value is not an object")
        var parsed_currency_index = data.object_get(data.root, "currency")
        if parsed_currency_index == -1:
            raise Error("RefundedPayment JSON object is missing currency")
        var parsed_currency = data.string_value(parsed_currency_index)
        var parsed_total_amount_index = data.object_get(data.root, "total_amount")
        if parsed_total_amount_index == -1:
            raise Error("RefundedPayment JSON object is missing total_amount")
        var parsed_total_amount = data.integer_value(parsed_total_amount_index)
        var parsed_invoice_payload_index = data.object_get(data.root, "invoice_payload")
        if parsed_invoice_payload_index == -1:
            raise Error("RefundedPayment JSON object is missing invoice_payload")
        var parsed_invoice_payload = data.string_value(parsed_invoice_payload_index)
        var parsed_telegram_payment_charge_id_index = data.object_get(data.root, "telegram_payment_charge_id")
        if parsed_telegram_payment_charge_id_index == -1:
            raise Error("RefundedPayment JSON object is missing telegram_payment_charge_id")
        var parsed_telegram_payment_charge_id = data.string_value(parsed_telegram_payment_charge_id_index)
        var parsed_provider_payment_charge_id_index = data.object_get(data.root, "provider_payment_charge_id")
        var parsed_provider_payment_charge_id: Optional[String] = None
        if parsed_provider_payment_charge_id_index != -1 and not data.is_null(parsed_provider_payment_charge_id_index):
            parsed_provider_payment_charge_id = Optional[String](data.string_value(parsed_provider_payment_charge_id_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "currency" and key != "total_amount" and key != "invoice_payload" and key != "telegram_payment_charge_id" and key != "provider_payment_charge_id":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return RefundedPayment(parsed_currency, parsed_total_amount, parsed_invoice_payload, parsed_telegram_payment_charge_id, parsed_provider_payment_charge_id, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[RefundedPayment]:
        var items = data.array_documents(array_index)
        var result = List[RefundedPayment]()
        for index in range(len(items)):
            result.append(RefundedPayment.de_json(items[index].copy()))
        return result^
