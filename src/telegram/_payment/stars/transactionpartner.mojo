#!/usr/bin/env mojo
#
# Native scalar Telegram Stars transaction partner model.
# LGPL-3.0-or-later; see LICENSE.

"""Transaction partner values from Telegram Stars transactions."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._gifts import Gift
from telegram._paidmedia import PaidMedia
from telegram._payment.stars.affiliateinfo import AffiliateInfo
from telegram._payment.stars.revenuewithdrawalstate import RevenueWithdrawalState
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _transaction_partner_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _transaction_partner_identity(data: JsonDocument, type: String) raises -> String:
    if type == "affiliate_program":
        var index = data.object_get(data.root, "commission_per_mille")
        if index == -1:
            raise Error("affiliate_program partner is missing commission_per_mille")
        return String(type, ":", String(data.integer_value(index)))
    if type == "chat":
        var chat_index = data.object_get(data.root, "chat")
        if chat_index == -1 or data.is_null(chat_index):
            raise Error("chat partner is missing chat")
        var chat = _transaction_partner_nested(data, chat_index)
        var chat_id = chat.object_get(chat.root, "id")
        if chat_id == -1:
            raise Error("chat partner chat is missing id")
        return String(type, ":", String(chat.integer_value(chat_id)))
    if type == "user":
        var user_index = data.object_get(data.root, "user")
        var transaction_type_index = data.object_get(data.root, "transaction_type")
        if user_index == -1 or data.is_null(user_index):
            raise Error("user partner is missing user")
        if transaction_type_index == -1 or data.is_null(transaction_type_index):
            raise Error("user partner is missing transaction_type")
        var user = _transaction_partner_nested(data, user_index)
        var user_id = user.object_get(user.root, "id")
        if user_id == -1:
            raise Error("user partner user is missing id")
        return String(
            type,
            ":",
            String(user.integer_value(user_id)),
            ":",
            data.string_value(transaction_type_index),
        )
    if type == "telegram_api":
        var count_index = data.object_get(data.root, "request_count")
        if count_index == -1:
            raise Error("telegram_api partner is missing request_count")
        return String(type, ":", String(data.integer_value(count_index)))
    return type.copy()


def _transaction_partner_validate(data: JsonDocument, type: String) raises:
    if type == "affiliate_program":
        var commission = data.object_get(data.root, "commission_per_mille")
        if commission == -1:
            raise Error("affiliate_program partner is missing commission_per_mille")
        _ = data.integer_value(commission)
        var sponsor = data.object_get(data.root, "sponsor_user")
        if sponsor != -1 and not data.is_null(sponsor):
            _ = User.de_json(_transaction_partner_nested(data, sponsor))
    elif type == "chat":
        var index = data.object_get(data.root, "chat")
        if index == -1 or data.is_null(index):
            raise Error("chat partner is missing chat")
        _ = Chat.de_json(_transaction_partner_nested(data, index))
        var gift = data.object_get(data.root, "gift")
        if gift != -1 and not data.is_null(gift):
            _ = Gift.de_json(_transaction_partner_nested(data, gift))
    elif type == "fragment":
        var index = data.object_get(data.root, "withdrawal_state")
        if index != -1 and not data.is_null(index):
            _ = RevenueWithdrawalState.de_json(_transaction_partner_nested(data, index))
    elif type == "user":
        var transaction_type_index = data.object_get(data.root, "transaction_type")
        if transaction_type_index == -1 or data.is_null(transaction_type_index):
            raise Error("user partner is missing transaction_type")
        _ = data.string_value(transaction_type_index)
        var user = data.object_get(data.root, "user")
        if user == -1 or data.is_null(user):
            raise Error("user partner is missing user")
        _ = User.de_json(_transaction_partner_nested(data, user))
        var paid_media = data.object_get(data.root, "paid_media")
        if paid_media != -1 and not data.is_null(paid_media):
            var media_items = data.array_documents(paid_media)
            for media in media_items:
                _ = PaidMedia.de_json(media)
        var gift = data.object_get(data.root, "gift")
        if gift != -1 and not data.is_null(gift):
            _ = Gift.de_json(_transaction_partner_nested(data, gift))
        var affiliate = data.object_get(data.root, "affiliate")
        if affiliate != -1 and not data.is_null(affiliate):
            _ = AffiliateInfo.de_json(_transaction_partner_nested(data, affiliate))
    elif type == "telegram_api":
        var count = data.object_get(data.root, "request_count")
        if count == -1:
            raise Error("telegram_api partner is missing request_count")
        _ = data.integer_value(count)


struct TransactionPartner(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native tagged representation of every Telegram Stars transaction partner.

    The source library exposes a base class with seven runtime subclasses. Mojo
    represents that closed set as one value carrying its discriminator and the
    complete JSON fields. Constructors below cover each upstream variant;
    ``de_json`` validates typed nested objects and preserves unknown future
    fields so adding a Bot API partner never discards wire data.
    """

    comptime AFFILIATE_PROGRAM = "affiliate_program"
    comptime CHAT = "chat"
    comptime FRAGMENT = "fragment"
    comptime OTHER = "other"
    comptime TELEGRAM_ADS = "telegram_ads"
    comptime TELEGRAM_API = "telegram_api"
    comptime USER = "user"

    var type: String
    var fields: JsonDocument
    var identity: String

    def __init__(out self, data: JsonDocument) raises:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("TransactionPartner JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1 or data.is_null(type_index):
            raise Error("TransactionPartner JSON object is missing type")
        var partner_type = data.string_value(type_index)
        _transaction_partner_validate(data, partner_type)
        self.type = partner_type.copy()
        self.fields = data.copy()
        self.identity = _transaction_partner_identity(data, partner_type)

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.fields = existing.fields.copy()
        self.identity = existing.identity.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.identity == other.identity

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.identity.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.fields.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def field(self, name: String) raises -> Optional[JsonDocument]:
        var index = self.fields.object_get(self.fields.root, name)
        if index == -1 or self.fields.is_null(index):
            return None
        return Optional[JsonDocument](_transaction_partner_nested(self.fields, index))

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return Self(data)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^

    @staticmethod
    def affiliate_program(
        commission_per_mille: Int,
        sponsor_user: Optional[User] = None,
    ) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.AFFILIATE_PROGRAM)
        if sponsor_user is not None:
            var nested = sponsor_user.value().to_dict()
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "sponsor_user", index)
        result.set_number(result.root, "commission_per_mille", String(commission_per_mille))
        return Self(result)

    @staticmethod
    def chat(chat: Chat, gift: Optional[Gift] = None) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.CHAT)
        var nested = chat.to_dict()
        var index = result.copy_subtree_from(nested, nested.root)
        result.object_set(result.root, "chat", index)
        if gift is not None:
            var gift_document = gift.value().to_dict()
            var gift_index = result.copy_subtree_from(gift_document, gift_document.root)
            result.object_set(result.root, "gift", gift_index)
        return Self(result)

    @staticmethod
    def fragment(withdrawal_state: Optional[RevenueWithdrawalState] = None) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.FRAGMENT)
        if withdrawal_state is not None:
            var nested = withdrawal_state.value().to_dict()
            var index = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "withdrawal_state", index)
        return Self(result)

    @staticmethod
    def user(
        transaction_type: String,
        user: User,
        invoice_payload: Optional[String] = None,
        paid_media: Optional[List[PaidMedia]] = None,
        paid_media_payload: Optional[String] = None,
        subscription_period: Optional[TimeDelta] = None,
        gift: Optional[Gift] = None,
        affiliate: Optional[AffiliateInfo] = None,
        premium_subscription_duration: Optional[Int] = None,
    ) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.USER)
        result.set_string(result.root, "transaction_type", transaction_type)
        var user_document = user.to_dict()
        var user_index = result.copy_subtree_from(user_document, user_document.root)
        result.object_set(result.root, "user", user_index)
        if invoice_payload is not None:
            result.set_string(result.root, "invoice_payload", invoice_payload.value())
        if paid_media is not None:
            var media_array = result.add_array()
            for media in paid_media.value():
                var media_document = media.to_dict()
                var item_index = result.copy_subtree_from(media_document, media_document.root)
                result.append_child(media_array, item_index)
            var media_index = media_array
            result.object_set(result.root, "paid_media", media_index)
        if paid_media_payload is not None:
            result.set_string(result.root, "paid_media_payload", paid_media_payload.value())
        if subscription_period is not None:
            result.set_number(
                result.root,
                "subscription_period",
                subscription_period.value().seconds_json_number(),
            )
        if gift is not None:
            var gift_document = gift.value().to_dict()
            var gift_index = result.copy_subtree_from(gift_document, gift_document.root)
            result.object_set(result.root, "gift", gift_index)
        if affiliate is not None:
            var affiliate_document = affiliate.value().to_dict()
            var affiliate_index = result.copy_subtree_from(
                affiliate_document, affiliate_document.root
            )
            result.object_set(result.root, "affiliate", affiliate_index)
        if premium_subscription_duration is not None:
            result.set_number(
                result.root,
                "premium_subscription_duration",
                String(premium_subscription_duration.value()),
            )
        return Self(result)

    @staticmethod
    def other() raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.OTHER)
        return Self(result)

    @staticmethod
    def telegram_ads() raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.TELEGRAM_ADS)
        return Self(result)

    @staticmethod
    def telegram_api(request_count: Int) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.TELEGRAM_API)
        result.set_number(result.root, "request_count", String(request_count))
        return Self(result)


struct TransactionPartnerTelegramApi(
    Equatable, Hashable, Copyable, TelegramJsonObject
):
    """Payment for successful API requests beyond regular limits."""

    var request_count: Int
    var api_kwargs: JsonDocument

    comptime TYPE = "telegram_api"

    def __init__(out self, request_count: Int):
        self.request_count = request_count
        self.api_kwargs = empty_json_object()

    def __init__(out self, request_count: Int, api_kwargs: JsonDocument):
        self.request_count = request_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.request_count = existing.request_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        # Upstream identity is (request_count,), not the fixed discriminator.
        return self.request_count == other.request_count

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.request_count).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.TYPE)
        result.set_number(result.root, "request_count", String(self.request_count))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("TransactionPartnerTelegramApi JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("TransactionPartnerTelegramApi JSON value is not an object")
        var count_index = data.object_get(data.root, "request_count")
        if count_index == -1:
            raise Error("TransactionPartnerTelegramApi JSON object is missing request_count")
        var request_count = data.integer_value(count_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type" and key != "request_count":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(request_count, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
