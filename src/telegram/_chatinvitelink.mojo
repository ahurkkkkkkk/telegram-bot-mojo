#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 ChatInviteLink.
# LGPL-3.0-or-later; see LICENSE.

"""Invite-link metadata with native User, timestamp, and duration values."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimeDelta, TimestampDateTime, from_timestamp, to_timestamp, to_timedelta
from telegram._utils.json import JSON_NUMBER, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _chat_invite_parse_int(value: String) raises -> Int:
    if value.byte_length() == 0:
        raise Error("Expected an integer string")
    var position = 0
    var sign = 1
    if value[byte=0] == "-":
        sign = -1
        position = 1
    if position == value.byte_length():
        raise Error("Expected an integer string")
    var result = 0
    while position < value.byte_length():
        var byte = value.as_bytes()[position]
        if byte < 0x30 or byte > 0x39:
            raise Error("Expected an integer string")
        result = result * 10 + Int(byte - 0x30)
        position += 1
    return sign * result


def _chat_invite_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    if data.nodes[index].kind == JSON_STRING:
        return Optional[Int](_chat_invite_parse_int(data.string_value(index)))
    return Optional[Int](data.integer_value(index))


def _chat_invite_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _chat_invite_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


struct ChatInviteLink(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Invite link; equality follows the five upstream identity fields."""

    var invite_link: String
    var creator: User
    var creates_join_request: Bool
    var is_primary: Bool
    var is_revoked: Bool
    var expire_date: Optional[TimestampDateTime]
    var member_limit: Optional[Int]
    var name: Optional[String]
    var pending_join_request_count: Optional[Int]
    var subscription_period: Optional[TimeDelta]
    var subscription_price: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        invite_link: String,
        creator: User,
        creates_join_request: Bool,
        is_primary: Bool,
        is_revoked: Bool,
        expire_date: Optional[TimestampDateTime] = None,
        member_limit: Optional[Int] = None,
        name: Optional[String] = None,
        pending_join_request_count: Optional[Int] = None,
        subscription_period: Optional[TimeDelta] = None,
        subscription_price: Optional[Int] = None,
    ):
        self.invite_link = invite_link.copy()
        self.creator = creator.copy()
        self.creates_join_request = creates_join_request
        self.is_primary = is_primary
        self.is_revoked = is_revoked
        self.expire_date = expire_date.copy()
        self.member_limit = member_limit
        self.name = name.copy()
        self.pending_join_request_count = pending_join_request_count
        self.subscription_period = subscription_period.copy()
        self.subscription_price = subscription_price
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        invite_link: String,
        creator: User,
        creates_join_request: Bool,
        is_primary: Bool,
        is_revoked: Bool,
        expire_date: Optional[TimestampDateTime] = None,
        member_limit: Optional[Int] = None,
        name: Optional[String] = None,
        pending_join_request_count: Optional[Int] = None,
        subscription_period: Optional[TimeDelta] = None,
        subscription_price: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.invite_link = invite_link.copy()
        self.creator = creator.copy()
        self.creates_join_request = creates_join_request
        self.is_primary = is_primary
        self.is_revoked = is_revoked
        self.expire_date = expire_date.copy()
        self.member_limit = member_limit
        self.name = name.copy()
        self.pending_join_request_count = pending_join_request_count
        self.subscription_period = subscription_period.copy()
        self.subscription_price = subscription_price
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.invite_link = existing.invite_link.copy()
        self.creator = existing.creator.copy()
        self.creates_join_request = existing.creates_join_request
        self.is_primary = existing.is_primary
        self.is_revoked = existing.is_revoked
        self.expire_date = existing.expire_date.copy()
        self.member_limit = existing.member_limit
        self.name = existing.name.copy()
        self.pending_join_request_count = existing.pending_join_request_count
        self.subscription_period = existing.subscription_period.copy()
        self.subscription_price = existing.subscription_price
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.invite_link == other.invite_link
            and self.creator == other.creator
            and self.creates_join_request == other.creates_join_request
            and self.is_primary == other.is_primary
            and self.is_revoked == other.is_revoked
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ChatInviteLink\0").as_bytes())
        hasher.update(self.invite_link.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.creator.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.creates_join_request:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.is_primary:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.is_revoked:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "creates_join_request", self.creates_join_request)
        var creator_data = self.creator.to_dict(recursive)
        var creator_index = result.copy_subtree_from(creator_data, creator_data.root)
        result.object_set(result.root, "creator", creator_index)
        if self.expire_date is not None:
            result.set_number(
                result.root, "expire_date", String(to_timestamp(self.expire_date.value()))
            )
        result.set_string(result.root, "invite_link", self.invite_link)
        result.set_boolean(result.root, "is_primary", self.is_primary)
        result.set_boolean(result.root, "is_revoked", self.is_revoked)
        if self.member_limit is not None:
            result.set_number(result.root, "member_limit", String(self.member_limit.value()))
        if self.name is not None:
            result.set_string(result.root, "name", self.name.value())
        if self.pending_join_request_count is not None:
            result.set_number(
                result.root,
                "pending_join_request_count",
                String(self.pending_join_request_count.value()),
            )
        if self.subscription_price is not None:
            result.set_number(
                result.root, "subscription_price", String(self.subscription_price.value())
            )
        if self.subscription_period is not None:
            result.set_number(
                result.root,
                "subscription_period",
                self.subscription_period.value().seconds_json_number(),
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatInviteLink JSON value must be an object")
        var link_index = data.object_get(data.root, "invite_link")
        var creator_index = data.object_get(data.root, "creator")
        var join_request_index = data.object_get(data.root, "creates_join_request")
        var primary_index = data.object_get(data.root, "is_primary")
        var revoked_index = data.object_get(data.root, "is_revoked")
        if (
            link_index == -1 or creator_index == -1 or join_request_index == -1 or
            primary_index == -1 or revoked_index == -1
        ):
            raise Error("ChatInviteLink JSON object is missing a required field")
        var creator_data = JsonDocument()
        creator_data.root = creator_data.copy_subtree_from(data, creator_index)
        var creator = User.de_json(creator_data)
        var expire_index = data.object_get(data.root, "expire_date")
        var expire_date: Optional[TimestampDateTime] = None
        if expire_index != -1 and not data.is_null(expire_index):
            expire_date = Optional[TimestampDateTime](
                from_timestamp(data.integer_value(expire_index))
            )
        var member_limit = _chat_invite_optional_int(data, "member_limit")
        var name = _chat_invite_optional_string(data, "name")
        var pending_join_request_count = _chat_invite_optional_int(
            data, "pending_join_request_count"
        )
        var subscription_period: Optional[TimeDelta] = None
        var period_index = data.object_get(data.root, "subscription_period")
        if period_index != -1 and not data.is_null(period_index):
            if data.nodes[period_index].kind == JSON_NUMBER:
                subscription_period = Optional[TimeDelta](
                    to_timedelta(atof(data.number_text(period_index)))
                )
            else:
                raise Error("ChatInviteLink subscription_period must be a number")
        var subscription_price = _chat_invite_optional_int(data, "subscription_price")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "invite_link" or key == "creator" or key == "creates_join_request" or
                key == "is_primary" or key == "is_revoked" or key == "expire_date" or
                key == "member_limit" or key == "name" or
                key == "pending_join_request_count" or key == "subscription_period" or
                key == "subscription_price"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            data.string_value(link_index),
            creator,
            data.boolean_value(join_request_index),
            data.boolean_value(primary_index),
            data.boolean_value(revoked_index),
            expire_date,
            member_limit,
            name,
            pending_join_request_count,
            subscription_period,
            subscription_price,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
