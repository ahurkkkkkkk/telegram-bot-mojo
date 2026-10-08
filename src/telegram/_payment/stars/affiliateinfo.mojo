#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 AffiliateInfo.
# LGPL-3.0-or-later; see LICENSE.

"""Affiliate commission data attached to a Telegram Stars transaction."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _affiliate_optional_user(data: JsonDocument, key: String) raises -> Optional[User]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    var nested = JsonDocument()
    nested.root = nested.copy_subtree_from(data, index)
    return Optional[User](User.de_json(nested))


def _affiliate_optional_chat(data: JsonDocument, key: String) raises -> Optional[Chat]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    var nested = JsonDocument()
    nested.root = nested.copy_subtree_from(data, index)
    return Optional[Chat](Chat.de_json(nested))


struct AffiliateInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Affiliate recipient and commission; equality follows upstream identity fields."""

    var affiliate_user: Optional[User]
    var affiliate_chat: Optional[Chat]
    var commission_per_mille: Int
    var amount: Int
    var nanostar_amount: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        commission_per_mille: Int,
        amount: Int,
        affiliate_user: Optional[User] = None,
        affiliate_chat: Optional[Chat] = None,
        nanostar_amount: Optional[Int] = None,
    ):
        self.affiliate_user = affiliate_user.copy()
        self.affiliate_chat = affiliate_chat.copy()
        self.commission_per_mille = commission_per_mille
        self.amount = amount
        self.nanostar_amount = nanostar_amount
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        commission_per_mille: Int,
        amount: Int,
        affiliate_user: Optional[User] = None,
        affiliate_chat: Optional[Chat] = None,
        nanostar_amount: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.affiliate_user = affiliate_user.copy()
        self.affiliate_chat = affiliate_chat.copy()
        self.commission_per_mille = commission_per_mille
        self.amount = amount
        self.nanostar_amount = nanostar_amount
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.affiliate_user = existing.affiliate_user.copy()
        self.affiliate_chat = existing.affiliate_chat.copy()
        self.commission_per_mille = existing.commission_per_mille
        self.amount = existing.amount
        self.nanostar_amount = existing.nanostar_amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.affiliate_user == other.affiliate_user
            and self.affiliate_chat == other.affiliate_chat
            and self.commission_per_mille == other.commission_per_mille
            and self.amount == other.amount
            and self.nanostar_amount == other.nanostar_amount
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("AffiliateInfo\0").as_bytes())
        if self.affiliate_user is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(String(self.affiliate_user.value().id).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.affiliate_chat is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(String(self.affiliate_chat.value().id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.commission_per_mille).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.amount).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.nanostar_amount is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(String(self.nanostar_amount.value()).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.affiliate_chat is not None:
            var chat_data = self.affiliate_chat.value().to_dict(recursive)
            var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
            result.object_set(result.root, "affiliate_chat", chat_index)
        if self.affiliate_user is not None:
            var user_data = self.affiliate_user.value().to_dict(recursive)
            var user_index = result.copy_subtree_from(user_data, user_data.root)
            result.object_set(result.root, "affiliate_user", user_index)
        result.set_number(result.root, "amount", String(self.amount))
        result.set_number(result.root, "commission_per_mille", String(self.commission_per_mille))
        if self.nanostar_amount is not None:
            result.set_number(result.root, "nanostar_amount", String(self.nanostar_amount.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("AffiliateInfo JSON value must be an object")
        var commission_index = data.object_get(data.root, "commission_per_mille")
        var amount_index = data.object_get(data.root, "amount")
        if commission_index == -1 or amount_index == -1:
            raise Error("AffiliateInfo JSON requires commission_per_mille and amount")
        var commission_per_mille = data.integer_value(commission_index)
        var amount = data.integer_value(amount_index)
        var affiliate_user = _affiliate_optional_user(data, "affiliate_user")
        var affiliate_chat = _affiliate_optional_chat(data, "affiliate_chat")
        var nanostar_index = data.object_get(data.root, "nanostar_amount")
        var nanostar_amount: Optional[Int] = None
        if nanostar_index != -1 and not data.is_null(nanostar_index):
            nanostar_amount = Optional[Int](data.integer_value(nanostar_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "affiliate_chat" or key == "affiliate_user" or key == "amount" or
                key == "commission_per_mille" or key == "nanostar_amount"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            commission_per_mille,
            amount,
            affiliate_user,
            affiliate_chat,
            nanostar_amount,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
