#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8
# _payment/stars/revenuewithdrawalstate.py.
# LGPL-3.0-or-later; see LICENSE.

"""Tagged revenue-withdrawal state values."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _copy_withdrawal_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


struct RevenueWithdrawalState(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Pending, succeeded, or failed withdrawal state in one tagged value.

    Python's runtime subclasses are represented by the ``type`` discriminator;
    ``succeeded`` values carry their completion timestamp and transaction URL.
    """

    comptime PENDING = constants.RevenueWithdrawalStateType.PENDING.value
    comptime SUCCEEDED = constants.RevenueWithdrawalStateType.SUCCEEDED.value
    comptime FAILED = constants.RevenueWithdrawalStateType.FAILED.value

    var type: String
    var date: Optional[TimestampDateTime]
    var url: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        type: String,
        date: Optional[TimestampDateTime] = None,
        url: Optional[String] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.type = type.copy()
        self.date = date.copy()
        self.url = url.copy()
        self.api_kwargs = _copy_withdrawal_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.date = existing.date.copy()
        self.url = existing.url.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.type != other.type:
            return False
        if self.type != Self.SUCCEEDED:
            return True
        if self.date is None or other.date is None:
            return self.date is None and other.date is None
        return self.date.value() == other.date.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("RevenueWithdrawalState\0").as_bytes())
        hasher.update(self.type.as_bytes())
        if self.type == Self.SUCCEEDED and self.date is not None:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(to_timestamp(self.date.value())).as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(String(self.date.value().microsecond).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        if self.type == Self.SUCCEEDED:
            if self.date is not None:
                result.set_number(
                    result.root, "date", String(to_timestamp(self.date.value()))
                )
            if self.url is not None:
                result.set_string(result.root, "url", self.url.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def pending(*, api_kwargs: Optional[JsonDocument] = None) -> Self:
        return Self(Self.PENDING, api_kwargs=api_kwargs)

    @staticmethod
    def failed(*, api_kwargs: Optional[JsonDocument] = None) -> Self:
        return Self(Self.FAILED, api_kwargs=api_kwargs)

    @staticmethod
    def succeeded(
        date: TimestampDateTime,
        url: String,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) -> Self:
        return Self(
            Self.SUCCEEDED,
            Optional[TimestampDateTime](date.copy()),
            Optional[String](url.copy()),
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("RevenueWithdrawalState JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1:
            raise Error("RevenueWithdrawalState JSON object is missing type")
        var type = data.string_value(type_index)
        var date: Optional[TimestampDateTime] = None
        var url: Optional[String] = None
        if type == Self.SUCCEEDED:
            var date_index = data.object_get(data.root, "date")
            var url_index = data.object_get(data.root, "url")
            if date_index == -1 or url_index == -1:
                raise Error("Succeeded RevenueWithdrawalState is missing date or url")
            date = Optional[TimestampDateTime](from_timestamp(data.integer_value(date_index)))
            url = Optional[String](data.string_value(url_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type" and not (type == Self.SUCCEEDED and (key == "date" or key == "url")):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(type, date, url, api_kwargs=Optional[JsonDocument](api_kwargs.copy()))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^

