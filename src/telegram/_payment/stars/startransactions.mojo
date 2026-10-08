#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8
# _payment/stars/startransactions.py.
# LGPL-3.0-or-later; see LICENSE.

"""Star transaction history values."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._payment.stars.transactionpartner import TransactionPartner
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _star_transactions_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


def _star_transaction_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _star_partners_equal(
    left: Optional[TransactionPartner], right: Optional[TransactionPartner]
) -> Bool:
    if left is None or right is None:
        return left is None and right is None
    return left.value() == right.value()


struct StarTransaction(Equatable, Hashable, Copyable, TelegramJsonObject):
    """One incoming or outgoing Stars transaction.

    Source and receiver are native tagged ``TransactionPartner`` values, so
    each partner's source identity rules are used by transaction equality.
    """

    var id: String
    var amount: Int
    var date: TimestampDateTime
    var source: Optional[TransactionPartner]
    var receiver: Optional[TransactionPartner]
    var nanostar_amount: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        amount: Int,
        date: TimestampDateTime,
        source: Optional[TransactionPartner] = None,
        receiver: Optional[TransactionPartner] = None,
        nanostar_amount: Optional[Int] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises:
        self.id = id.copy()
        self.amount = amount
        self.date = date.copy()
        self.source = source.copy()
        self.receiver = receiver.copy()
        self.nanostar_amount = nanostar_amount
        self.api_kwargs = _star_transactions_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.amount = existing.amount
        self.date = existing.date.copy()
        self.source = existing.source.copy()
        self.receiver = existing.receiver.copy()
        self.nanostar_amount = existing.nanostar_amount
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.id == other.id
            and _star_partners_equal(self.source, other.source)
            and _star_partners_equal(self.receiver, other.receiver)
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("StarTransaction\0").as_bytes())
        hasher.update(self.id.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.source is None:
            hasher.update(String("source:none\0").as_bytes())
        else:
            hasher.update(self.source.value().identity.as_bytes())
            hasher.update(String("\0").as_bytes())
        if self.receiver is None:
            hasher.update(String("receiver:none").as_bytes())
        else:
            hasher.update(self.receiver.value().identity.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "amount", String(self.amount))
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        result.set_string(result.root, "id", self.id)
        if self.nanostar_amount is not None:
            result.set_number(result.root, "nanostar_amount", String(self.nanostar_amount.value()))
        if self.receiver is not None:
            var receiver_data = self.receiver.value().to_dict(recursive=recursive)
            var receiver_index = result.copy_subtree_from(receiver_data, receiver_data.root)
            result.object_set(result.root, "receiver", receiver_index)
        if self.source is not None:
            var source_data = self.source.value().to_dict(recursive=recursive)
            var source_index = result.copy_subtree_from(source_data, source_data.root)
            result.object_set(result.root, "source", source_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("StarTransaction JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var amount_index = data.object_get(data.root, "amount")
        var date_index = data.object_get(data.root, "date")
        if id_index == -1 or amount_index == -1 or date_index == -1:
            raise Error("StarTransaction JSON object is missing a required field")
        var id = data.string_value(id_index)
        var amount = data.integer_value(amount_index)
        var date = from_timestamp(data.integer_value(date_index))
        var source: Optional[TransactionPartner] = None
        var source_index = data.object_get(data.root, "source")
        if source_index != -1 and not data.is_null(source_index):
            source = Optional[TransactionPartner](
                TransactionPartner.de_json(_star_transaction_nested(data, source_index))
            )
        var receiver: Optional[TransactionPartner] = None
        var receiver_index = data.object_get(data.root, "receiver")
        if receiver_index != -1 and not data.is_null(receiver_index):
            receiver = Optional[TransactionPartner](
                TransactionPartner.de_json(_star_transaction_nested(data, receiver_index))
            )
        var nanostar_amount: Optional[Int] = None
        var nanostar_index = data.object_get(data.root, "nanostar_amount")
        if nanostar_index != -1 and not data.is_null(nanostar_index):
            nanostar_amount = Optional[Int](data.integer_value(nanostar_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "amount" or key == "date" or key == "id" or
                key == "nanostar_amount" or key == "receiver" or key == "source"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            id,
            amount,
            date,
            source,
            receiver,
            nanostar_amount,
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^


struct StarTransactions(Equatable, Hashable, Copyable, TelegramJsonObject):
    """An ordered transaction history."""

    var transactions: List[StarTransaction]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        transactions: List[StarTransaction],
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.transactions = List[StarTransaction](copy=transactions)
        self.api_kwargs = _star_transactions_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.transactions = List[StarTransaction](copy=existing.transactions)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if len(self.transactions) != len(other.transactions):
            return False
        for index in range(len(self.transactions)):
            if self.transactions[index] != other.transactions[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        for transaction in self.transactions:
            hasher.update(String(hash(transaction)).as_bytes())
            hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if len(self.transactions) > 0:
            var array_index = result.add_array()
            for transaction in self.transactions:
                var item = transaction.to_dict(recursive=recursive)
                var child = result.copy_subtree_from(item, item.root)
                result.append_child(array_index, child)
            result.object_set(result.root, "transactions", array_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("StarTransactions JSON value must be an object")
        var transactions = List[StarTransaction]()
        var transactions_index = data.object_get(data.root, "transactions")
        if transactions_index != -1 and not data.is_null(transactions_index):
            var items = data.array_documents(transactions_index)
            for item in items:
                transactions.append(StarTransaction.de_json(item))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "transactions":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(transactions, api_kwargs=Optional[JsonDocument](api_kwargs.copy()))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
