#!/usr/bin/env mojo
#
# Native Mojo translation of python-telegram-bot v22.8 _ownedgift.py.
# LGPL-3.0-or-later; see LICENSE.

"""Owned regular and unique Telegram gifts as a native tagged value."""

from std.collections import Dict, List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.sticker import Sticker
from telegram._gifts import Gift
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._uniquegift import UniqueGift
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _owned_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _owned_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


def _owned_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _owned_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _owned_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _owned_validate_optional_bool(data: JsonDocument, key: String) raises:
    var index = data.object_get(data.root, key)
    if index != -1 and not data.is_null(index):
        _ = data.boolean_value(index)


def _owned_validate_optional_int(data: JsonDocument, key: String) raises:
    var index = data.object_get(data.root, key)
    if index != -1 and not data.is_null(index):
        _ = data.integer_value(index)


def _owned_validate(data: JsonDocument, type: String) raises:
    if type == "regular":
        var gift_index = data.object_get(data.root, "gift")
        var date_index = data.object_get(data.root, "send_date")
        if gift_index == -1 or date_index == -1:
            raise Error("regular owned gift requires gift and send_date")
        _ = Gift.de_json(_owned_nested(data, gift_index))
        _ = data.integer_value(date_index)
        var sender = data.object_get(data.root, "sender_user")
        if sender != -1 and not data.is_null(sender):
            _ = User.de_json(_owned_nested(data, sender))
        var entities = data.object_get(data.root, "entities")
        if entities != -1 and not data.is_null(entities):
            if data.nodes[entities].kind != JSON_ARRAY:
                raise Error("owned gift entities must be an array")
            var entity_data = data.array_documents(entities)
            for entity in entity_data:
                _ = MessageEntity.de_json(entity)
        _owned_validate_optional_bool(data, "is_private")
        _owned_validate_optional_bool(data, "is_saved")
        _owned_validate_optional_bool(data, "can_be_upgraded")
        _owned_validate_optional_bool(data, "was_refunded")
        _owned_validate_optional_bool(data, "is_upgrade_separate")
        _owned_validate_optional_int(data, "convert_star_count")
        _owned_validate_optional_int(data, "prepaid_upgrade_star_count")
        _owned_validate_optional_int(data, "unique_gift_number")
        _ = _owned_optional_string(data, "owned_gift_id")
        _ = _owned_optional_string(data, "text")
    elif type == "unique":
        var gift_index = data.object_get(data.root, "gift")
        var date_index = data.object_get(data.root, "send_date")
        if gift_index == -1 or date_index == -1:
            raise Error("unique owned gift requires gift and send_date")
        _ = UniqueGift.de_json(_owned_nested(data, gift_index))
        _ = data.integer_value(date_index)
        var sender = data.object_get(data.root, "sender_user")
        if sender != -1 and not data.is_null(sender):
            _ = User.de_json(_owned_nested(data, sender))
        _owned_validate_optional_bool(data, "is_saved")
        _owned_validate_optional_bool(data, "can_be_transferred")
        var transfer_count = data.object_get(data.root, "transfer_star_count")
        if transfer_count != -1 and not data.is_null(transfer_count):
            _ = data.integer_value(transfer_count)
        var next_transfer = data.object_get(data.root, "next_transfer_date")
        if next_transfer != -1 and not data.is_null(next_transfer):
            _ = data.integer_value(next_transfer)


struct OwnedGift(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native tagged regular/unique gift value with upstream identity behavior."""

    comptime REGULAR = "regular"
    comptime UNIQUE = "unique"

    var type: String
    var fields: JsonDocument
    var regular_gift: Optional[Gift]
    var unique_gift: Optional[UniqueGift]
    var send_date: Optional[TimestampDateTime]

    def __init__(out self, data: JsonDocument) raises:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("OwnedGift JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1 or data.is_null(type_index):
            raise Error("OwnedGift JSON object is missing type")
        var gift_type = data.string_value(type_index)
        _owned_validate(data, gift_type)
        self.type = gift_type.copy()
        self.fields = data.copy()
        self.regular_gift = None
        self.unique_gift = None
        self.send_date = None
        if gift_type == Self.REGULAR or gift_type == Self.UNIQUE:
            var gift_index = data.object_get(data.root, "gift")
            var date_index = data.object_get(data.root, "send_date")
            self.send_date = Optional[TimestampDateTime](
                from_timestamp(data.integer_value(date_index))
            )
            if gift_type == Self.REGULAR:
                self.regular_gift = Optional[Gift](
                    Gift.de_json(_owned_nested(data, gift_index))
                )
            else:
                self.unique_gift = Optional[UniqueGift](
                    UniqueGift.de_json(_owned_nested(data, gift_index))
                )

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.fields = existing.fields.copy()
        self.regular_gift = existing.regular_gift.copy()
        self.unique_gift = existing.unique_gift.copy()
        self.send_date = existing.send_date.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.type != other.type:
            return False
        if self.type == Self.REGULAR:
            return (
                self.regular_gift is not None and other.regular_gift is not None and
                self.regular_gift.value() == other.regular_gift.value() and
                self.send_date is not None and other.send_date is not None and
                self.send_date.value() == other.send_date.value()
            )
        if self.type == Self.UNIQUE:
            return (
                self.unique_gift is not None and other.unique_gift is not None and
                self.unique_gift.value() == other.unique_gift.value() and
                self.send_date is not None and other.send_date is not None and
                self.send_date.value() == other.send_date.value()
            )
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        if self.regular_gift is not None:
            hasher.update(String(hash(self.regular_gift.value())).as_bytes())
        if self.unique_gift is not None:
            hasher.update(String(hash(self.unique_gift.value())).as_bytes())
        if self.send_date is not None:
            hasher.update(String(hash(self.send_date.value())).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.fields.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def field(self, key: String) raises -> Optional[JsonDocument]:
        var index = self.fields.object_get(self.fields.root, key)
        if index == -1 or self.fields.is_null(index):
            return None
        return Optional[JsonDocument](_owned_nested(self.fields, index))

    def parse_entity(self, entity: MessageEntity) raises -> String:
        var text_index = self.fields.object_get(self.fields.root, "text")
        if self.type != Self.REGULAR or text_index == -1 or self.fields.is_null(text_index):
            raise Error("This owned gift has no 'text'.")
        var text = self.fields.string_value(text_index)
        if text.byte_length() == 0:
            raise Error("This owned gift has no 'text'.")
        return parse_message_entity(text, entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        var text_index = self.fields.object_get(self.fields.root, "text")
        if self.type != Self.REGULAR or text_index == -1 or self.fields.is_null(text_index):
            raise Error("This owned gift has no 'text'.")
        var text = self.fields.string_value(text_index)
        if text.byte_length() == 0:
            raise Error("This owned gift has no 'text'.")
        var entities = List[MessageEntity]()
        var entities_index = self.fields.object_get(self.fields.root, "entities")
        if entities_index == -1 or self.fields.is_null(entities_index):
            return Dict[MessageEntity, String]()
        var entity_data = self.fields.array_documents(entities_index)
        for item in entity_data:
            entities.append(MessageEntity.de_json(item))
        return parse_message_entities(text, entities, types)

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return Self(data)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^

    @staticmethod
    def regular(
        gift: Gift,
        send_date: TimestampDateTime,
        owned_gift_id: Optional[String] = None,
        sender_user: Optional[User] = None,
        text: Optional[String] = None,
        entities: Optional[List[MessageEntity]] = None,
        is_private: Optional[Bool] = None,
        is_saved: Optional[Bool] = None,
        can_be_upgraded: Optional[Bool] = None,
        was_refunded: Optional[Bool] = None,
        convert_star_count: Optional[Int] = None,
        prepaid_upgrade_star_count: Optional[Int] = None,
        is_upgrade_separate: Optional[Bool] = None,
        unique_gift_number: Optional[Int] = None,
    ) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.REGULAR)
        var gift_data = gift.to_dict()
        var gift_index = result.copy_subtree_from(gift_data, gift_data.root)
        result.object_set(result.root, "gift", gift_index)
        result.set_number(result.root, "send_date", String(to_timestamp(send_date)))
        if owned_gift_id is not None:
            result.set_string(result.root, "owned_gift_id", owned_gift_id.value())
        if sender_user is not None:
            var sender_data = sender_user.value().to_dict()
            var sender_index = result.copy_subtree_from(sender_data, sender_data.root)
            result.object_set(result.root, "sender_user", sender_index)
        if text is not None:
            result.set_string(result.root, "text", text.value())
        if entities is not None:
            var entity_array = result.add_array()
            for entity in entities.value():
                var entity_data = entity.to_dict()
                var index = result.copy_subtree_from(entity_data, entity_data.root)
                result.append_child(entity_array, index)
            result.object_set(result.root, "entities", entity_array)
        if is_private is not None:
            result.set_boolean(result.root, "is_private", is_private.value())
        if is_saved is not None:
            result.set_boolean(result.root, "is_saved", is_saved.value())
        if can_be_upgraded is not None:
            result.set_boolean(result.root, "can_be_upgraded", can_be_upgraded.value())
        if was_refunded is not None:
            result.set_boolean(result.root, "was_refunded", was_refunded.value())
        if convert_star_count is not None:
            result.set_number(result.root, "convert_star_count", String(convert_star_count.value()))
        if prepaid_upgrade_star_count is not None:
            result.set_number(result.root, "prepaid_upgrade_star_count", String(prepaid_upgrade_star_count.value()))
        if is_upgrade_separate is not None:
            result.set_boolean(result.root, "is_upgrade_separate", is_upgrade_separate.value())
        if unique_gift_number is not None:
            result.set_number(result.root, "unique_gift_number", String(unique_gift_number.value()))
        return Self(result)

    @staticmethod
    def unique(
        gift: UniqueGift,
        send_date: TimestampDateTime,
        owned_gift_id: Optional[String] = None,
        sender_user: Optional[User] = None,
        is_saved: Optional[Bool] = None,
        can_be_transferred: Optional[Bool] = None,
        transfer_star_count: Optional[Int] = None,
        next_transfer_date: Optional[TimestampDateTime] = None,
    ) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.UNIQUE)
        var gift_data = gift.to_dict()
        var gift_index = result.copy_subtree_from(gift_data, gift_data.root)
        result.object_set(result.root, "gift", gift_index)
        result.set_number(result.root, "send_date", String(to_timestamp(send_date)))
        if owned_gift_id is not None:
            result.set_string(result.root, "owned_gift_id", owned_gift_id.value())
        if sender_user is not None:
            var sender_data = sender_user.value().to_dict()
            var sender_index = result.copy_subtree_from(sender_data, sender_data.root)
            result.object_set(result.root, "sender_user", sender_index)
        if is_saved is not None:
            result.set_boolean(result.root, "is_saved", is_saved.value())
        if can_be_transferred is not None:
            result.set_boolean(result.root, "can_be_transferred", can_be_transferred.value())
        if transfer_star_count is not None:
            result.set_number(result.root, "transfer_star_count", String(transfer_star_count.value()))
        if next_transfer_date is not None:
            result.set_number(
                result.root,
                "next_transfer_date",
                String(to_timestamp(next_transfer_date.value())),
            )
        return Self(result)


struct OwnedGifts(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A page of gifts owned by a user or chat."""

    var total_count: Int
    var gifts: List[OwnedGift]
    var next_offset: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        total_count: Int,
        gifts: List[OwnedGift],
        next_offset: Optional[String] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.total_count = total_count
        self.gifts = List[OwnedGift](copy=gifts)
        self.next_offset = next_offset.copy()
        self.api_kwargs = _owned_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.total_count = existing.total_count
        self.gifts = List[OwnedGift](copy=existing.gifts)
        self.next_offset = existing.next_offset.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.total_count != other.total_count or len(self.gifts) != len(other.gifts):
            return False
        for index in range(len(self.gifts)):
            if self.gifts[index] != other.gifts[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.total_count).as_bytes())
        for gift in self.gifts:
            hasher.update(String(hash(gift)).as_bytes())
            hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var gifts = result.add_array()
        for gift in self.gifts:
            var item = gift.to_dict(recursive)
            var index = result.copy_subtree_from(item, item.root)
            result.append_child(gifts, index)
        result.object_set(result.root, "gifts", gifts)
        if self.next_offset is not None:
            result.set_string(result.root, "next_offset", self.next_offset.value())
        result.set_number(result.root, "total_count", String(self.total_count))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("OwnedGifts JSON value must be an object")
        var count_index = data.object_get(data.root, "total_count")
        if count_index == -1:
            raise Error("OwnedGifts JSON object is missing total_count")
        var gifts = List[OwnedGift]()
        var gifts_index = data.object_get(data.root, "gifts")
        if gifts_index != -1 and not data.is_null(gifts_index):
            var items = data.array_documents(gifts_index)
            for item in items:
                gifts.append(OwnedGift.de_json(item))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "total_count" and key != "gifts" and key != "next_offset":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            data.integer_value(count_index),
            gifts,
            _owned_optional_string(data, "next_offset"),
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^
