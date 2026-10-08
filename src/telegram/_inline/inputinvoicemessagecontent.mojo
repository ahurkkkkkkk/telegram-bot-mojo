#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InputInvoiceMessageContent.
# LGPL-3.0-or-later; see LICENSE.

"""Inline-query content that creates an invoice message."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._payment.labeledprice import LabeledPrice
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct InputInvoiceMessageContent(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Invoice content; equality follows title, description, payload, currency, and prices."""

    var title: String
    var description: String
    var payload: String
    var currency: String
    var prices: List[LabeledPrice]
    var provider_token: Optional[String]
    var max_tip_amount: Optional[Int]
    var suggested_tip_amounts: List[Int]
    var provider_data: Optional[String]
    var photo_url: Optional[String]
    var photo_size: Optional[Int]
    var photo_width: Optional[Int]
    var photo_height: Optional[Int]
    var need_name: Optional[Bool]
    var need_phone_number: Optional[Bool]
    var need_email: Optional[Bool]
    var need_shipping_address: Optional[Bool]
    var send_phone_number_to_provider: Optional[Bool]
    var send_email_to_provider: Optional[Bool]
    var is_flexible: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        title: String,
        description: String,
        payload: String,
        currency: String,
        prices: List[LabeledPrice],
        provider_token: Optional[String] = None,
        max_tip_amount: Optional[Int] = None,
        suggested_tip_amounts: Optional[List[Int]] = None,
        provider_data: Optional[String] = None,
        photo_url: Optional[String] = None,
        photo_size: Optional[Int] = None,
        photo_width: Optional[Int] = None,
        photo_height: Optional[Int] = None,
        need_name: Optional[Bool] = None,
        need_phone_number: Optional[Bool] = None,
        need_email: Optional[Bool] = None,
        need_shipping_address: Optional[Bool] = None,
        send_phone_number_to_provider: Optional[Bool] = None,
        send_email_to_provider: Optional[Bool] = None,
        is_flexible: Optional[Bool] = None,
    ):
        self.title = title.copy()
        self.description = description.copy()
        self.payload = payload.copy()
        self.currency = currency.copy()
        self.prices = List[LabeledPrice](copy=prices)
        self.provider_token = provider_token
        self.max_tip_amount = max_tip_amount
        self.suggested_tip_amounts = List[Int]()
        if suggested_tip_amounts is not None:
            self.suggested_tip_amounts = List[Int](copy=suggested_tip_amounts.value())
        self.provider_data = provider_data
        self.photo_url = photo_url
        self.photo_size = photo_size
        self.photo_width = photo_width
        self.photo_height = photo_height
        self.need_name = need_name
        self.need_phone_number = need_phone_number
        self.need_email = need_email
        self.need_shipping_address = need_shipping_address
        self.send_phone_number_to_provider = send_phone_number_to_provider
        self.send_email_to_provider = send_email_to_provider
        self.is_flexible = is_flexible
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        description: String,
        payload: String,
        currency: String,
        prices: List[LabeledPrice],
        provider_token: Optional[String] = None,
        max_tip_amount: Optional[Int] = None,
        suggested_tip_amounts: Optional[List[Int]] = None,
        provider_data: Optional[String] = None,
        photo_url: Optional[String] = None,
        photo_size: Optional[Int] = None,
        photo_width: Optional[Int] = None,
        photo_height: Optional[Int] = None,
        need_name: Optional[Bool] = None,
        need_phone_number: Optional[Bool] = None,
        need_email: Optional[Bool] = None,
        need_shipping_address: Optional[Bool] = None,
        send_phone_number_to_provider: Optional[Bool] = None,
        send_email_to_provider: Optional[Bool] = None,
        is_flexible: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.title = title.copy()
        self.description = description.copy()
        self.payload = payload.copy()
        self.currency = currency.copy()
        self.prices = List[LabeledPrice](copy=prices)
        self.provider_token = provider_token
        self.max_tip_amount = max_tip_amount
        self.suggested_tip_amounts = List[Int]()
        if suggested_tip_amounts is not None:
            self.suggested_tip_amounts = List[Int](copy=suggested_tip_amounts.value())
        self.provider_data = provider_data
        self.photo_url = photo_url
        self.photo_size = photo_size
        self.photo_width = photo_width
        self.photo_height = photo_height
        self.need_name = need_name
        self.need_phone_number = need_phone_number
        self.need_email = need_email
        self.need_shipping_address = need_shipping_address
        self.send_phone_number_to_provider = send_phone_number_to_provider
        self.send_email_to_provider = send_email_to_provider
        self.is_flexible = is_flexible
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.title = existing.title.copy()
        self.description = existing.description.copy()
        self.payload = existing.payload.copy()
        self.currency = existing.currency.copy()
        self.prices = List[LabeledPrice](copy=existing.prices)
        self.provider_token = existing.provider_token
        self.max_tip_amount = existing.max_tip_amount
        self.suggested_tip_amounts = List[Int](copy=existing.suggested_tip_amounts)
        self.provider_data = existing.provider_data
        self.photo_url = existing.photo_url
        self.photo_size = existing.photo_size
        self.photo_width = existing.photo_width
        self.photo_height = existing.photo_height
        self.need_name = existing.need_name
        self.need_phone_number = existing.need_phone_number
        self.need_email = existing.need_email
        self.need_shipping_address = existing.need_shipping_address
        self.send_phone_number_to_provider = existing.send_phone_number_to_provider
        self.send_email_to_provider = existing.send_email_to_provider
        self.is_flexible = existing.is_flexible
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if (
            self.title != other.title
            or self.description != other.description
            or self.payload != other.payload
            or self.currency != other.currency
            or len(self.prices) != len(other.prices)
        ):
            return False
        for index in range(len(self.prices)):
            if self.prices[index] != other.prices[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.title.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.description.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.payload.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.currency.as_bytes())
        for price in self.prices:
            hasher.update(String("\0").as_bytes())
            hasher.update(price.label.as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(String(price.amount).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "currency", self.currency)
        result.set_string(result.root, "description", self.description)
        if self.is_flexible is not None:
            result.set_boolean(result.root, "is_flexible", self.is_flexible.value())
        if self.max_tip_amount is not None:
            result.set_number(result.root, "max_tip_amount", String(self.max_tip_amount.value()))
        if self.need_email is not None:
            result.set_boolean(result.root, "need_email", self.need_email.value())
        if self.need_name is not None:
            result.set_boolean(result.root, "need_name", self.need_name.value())
        if self.need_phone_number is not None:
            result.set_boolean(result.root, "need_phone_number", self.need_phone_number.value())
        if self.need_shipping_address is not None:
            result.set_boolean(result.root, "need_shipping_address", self.need_shipping_address.value())
        result.set_string(result.root, "payload", self.payload)
        if self.photo_height is not None:
            result.set_number(result.root, "photo_height", String(self.photo_height.value()))
        if self.photo_size is not None:
            result.set_number(result.root, "photo_size", String(self.photo_size.value()))
        if self.photo_url is not None:
            result.set_string(result.root, "photo_url", self.photo_url.value())
        if self.photo_width is not None:
            result.set_number(result.root, "photo_width", String(self.photo_width.value()))
        if len(self.prices) > 0:
            var price_array = result.add_array()
            for price in self.prices:
                var price_document = price.to_dict(recursive=recursive)
                var copied_price = result.copy_subtree_from(price_document, price_document.root)
                result.append_child(price_array, copied_price)
            result.object_set(result.root, "prices", price_array)
        if self.provider_data is not None:
            result.set_string(result.root, "provider_data", self.provider_data.value())
        if self.provider_token is not None:
            result.set_string(result.root, "provider_token", self.provider_token.value())
        if self.send_email_to_provider is not None:
            result.set_boolean(result.root, "send_email_to_provider", self.send_email_to_provider.value())
        if self.send_phone_number_to_provider is not None:
            result.set_boolean(result.root, "send_phone_number_to_provider", self.send_phone_number_to_provider.value())
        if len(self.suggested_tip_amounts) > 0:
            var tips_array = result.add_array()
            for tip in self.suggested_tip_amounts:
                var tip_node = result.add_number(String(tip))
                result.append_child(tips_array, tip_node)
            result.object_set(result.root, "suggested_tip_amounts", tips_array)
        result.set_string(result.root, "title", self.title)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("InputInvoiceMessageContent JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InputInvoiceMessageContent JSON value is not an object")

        var title_index = data.object_get(data.root, "title")
        var description_index = data.object_get(data.root, "description")
        var payload_index = data.object_get(data.root, "payload")
        var currency_index = data.object_get(data.root, "currency")
        var prices_index = data.object_get(data.root, "prices")
        if (
            title_index == -1
            or description_index == -1
            or payload_index == -1
            or currency_index == -1
            or prices_index == -1
        ):
            raise Error("InputInvoiceMessageContent JSON object is missing a required field")
        if data.nodes[prices_index].kind != JSON_ARRAY:
            raise Error("InputInvoiceMessageContent prices field is not an array")
        var title = data.string_value(title_index)
        var description = data.string_value(description_index)
        var payload = data.string_value(payload_index)
        var currency = data.string_value(currency_index)
        var prices = List[LabeledPrice]()
        var price_documents = data.array_documents(prices_index)
        for index in range(len(price_documents)):
            prices.append(LabeledPrice.de_json(price_documents[index].copy()))

        var provider_token: Optional[String] = None
        var provider_token_index = data.object_get(data.root, "provider_token")
        if provider_token_index != -1 and not data.is_null(provider_token_index):
            provider_token = Optional[String](data.string_value(provider_token_index))
        var max_tip_amount: Optional[Int] = None
        var max_tip_amount_index = data.object_get(data.root, "max_tip_amount")
        if max_tip_amount_index != -1 and not data.is_null(max_tip_amount_index):
            max_tip_amount = Optional[Int](data.integer_value(max_tip_amount_index))
        var suggested_tip_amounts = List[Int]()
        var suggested_tip_amounts_index = data.object_get(data.root, "suggested_tip_amounts")
        if suggested_tip_amounts_index != -1 and not data.is_null(suggested_tip_amounts_index):
            if data.nodes[suggested_tip_amounts_index].kind != JSON_ARRAY:
                raise Error("InputInvoiceMessageContent suggested tips field is not an array")
            var tip_child = data.nodes[suggested_tip_amounts_index].first_child
            while tip_child != -1:
                suggested_tip_amounts.append(data.integer_value(tip_child))
                tip_child = data.nodes[tip_child].next_sibling
        var provider_data: Optional[String] = None
        var provider_data_index = data.object_get(data.root, "provider_data")
        if provider_data_index != -1 and not data.is_null(provider_data_index):
            provider_data = Optional[String](data.string_value(provider_data_index))
        var photo_url: Optional[String] = None
        var photo_url_index = data.object_get(data.root, "photo_url")
        if photo_url_index != -1 and not data.is_null(photo_url_index):
            photo_url = Optional[String](data.string_value(photo_url_index))
        var photo_size: Optional[Int] = None
        var photo_size_index = data.object_get(data.root, "photo_size")
        if photo_size_index != -1 and not data.is_null(photo_size_index):
            photo_size = Optional[Int](data.integer_value(photo_size_index))
        var photo_width: Optional[Int] = None
        var photo_width_index = data.object_get(data.root, "photo_width")
        if photo_width_index != -1 and not data.is_null(photo_width_index):
            photo_width = Optional[Int](data.integer_value(photo_width_index))
        var photo_height: Optional[Int] = None
        var photo_height_index = data.object_get(data.root, "photo_height")
        if photo_height_index != -1 and not data.is_null(photo_height_index):
            photo_height = Optional[Int](data.integer_value(photo_height_index))
        var need_name: Optional[Bool] = None
        var need_name_index = data.object_get(data.root, "need_name")
        if need_name_index != -1 and not data.is_null(need_name_index):
            need_name = Optional[Bool](data.boolean_value(need_name_index))
        var need_phone_number: Optional[Bool] = None
        var need_phone_number_index = data.object_get(data.root, "need_phone_number")
        if need_phone_number_index != -1 and not data.is_null(need_phone_number_index):
            need_phone_number = Optional[Bool](data.boolean_value(need_phone_number_index))
        var need_email: Optional[Bool] = None
        var need_email_index = data.object_get(data.root, "need_email")
        if need_email_index != -1 and not data.is_null(need_email_index):
            need_email = Optional[Bool](data.boolean_value(need_email_index))
        var need_shipping_address: Optional[Bool] = None
        var need_shipping_address_index = data.object_get(data.root, "need_shipping_address")
        if need_shipping_address_index != -1 and not data.is_null(need_shipping_address_index):
            need_shipping_address = Optional[Bool](data.boolean_value(need_shipping_address_index))
        var send_phone_number_to_provider: Optional[Bool] = None
        var send_phone_number_to_provider_index = data.object_get(data.root, "send_phone_number_to_provider")
        if send_phone_number_to_provider_index != -1 and not data.is_null(send_phone_number_to_provider_index):
            send_phone_number_to_provider = Optional[Bool](data.boolean_value(send_phone_number_to_provider_index))
        var send_email_to_provider: Optional[Bool] = None
        var send_email_to_provider_index = data.object_get(data.root, "send_email_to_provider")
        if send_email_to_provider_index != -1 and not data.is_null(send_email_to_provider_index):
            send_email_to_provider = Optional[Bool](data.boolean_value(send_email_to_provider_index))
        var is_flexible: Optional[Bool] = None
        var is_flexible_index = data.object_get(data.root, "is_flexible")
        if is_flexible_index != -1 and not data.is_null(is_flexible_index):
            is_flexible = Optional[Bool](data.boolean_value(is_flexible_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "title"
                and key != "description"
                and key != "payload"
                and key != "currency"
                and key != "prices"
                and key != "provider_token"
                and key != "max_tip_amount"
                and key != "suggested_tip_amounts"
                and key != "provider_data"
                and key != "photo_url"
                and key != "photo_size"
                and key != "photo_width"
                and key != "photo_height"
                and key != "need_name"
                and key != "need_phone_number"
                and key != "need_email"
                and key != "need_shipping_address"
                and key != "send_phone_number_to_provider"
                and key != "send_email_to_provider"
                and key != "is_flexible"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        var suggested_tip_amounts_value = Optional[List[Int]](suggested_tip_amounts^)
        return InputInvoiceMessageContent(
            title,
            description,
            payload,
            currency,
            prices,
            provider_token,
            max_tip_amount,
            suggested_tip_amounts_value,
            provider_data,
            photo_url,
            photo_size,
            photo_width,
            photo_height,
            need_name,
            need_phone_number,
            need_email,
            need_shipping_address,
            send_phone_number_to_provider,
            send_email_to_provider,
            is_flexible,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InputInvoiceMessageContent.de_json(items[index].copy()))
        return result^
