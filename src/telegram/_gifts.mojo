#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _gifts.py."""

from std.collections import Dict, List
from std.collections.optional import Optional

from telegram._chat import Chat
from telegram._files.sticker import Sticker
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.entities import parse_message_entities, parse_message_entity
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _gift_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


def _gift_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _gift_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _gift_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _gift_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


struct Gift(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram gift, identified by its stable gift ID."""

    var id: String
    var sticker: Sticker
    var star_count: Int
    var total_count: Optional[Int]
    var remaining_count: Optional[Int]
    var upgrade_star_count: Optional[Int]
    var publisher_chat: Optional[Chat]
    var personal_total_count: Optional[Int]
    var personal_remaining_count: Optional[Int]
    var background: Optional[GiftBackground]
    var is_premium: Optional[Bool]
    var has_colors: Optional[Bool]
    var unique_gift_variant_count: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        sticker: Sticker,
        star_count: Int,
        total_count: Optional[Int] = None,
        remaining_count: Optional[Int] = None,
        upgrade_star_count: Optional[Int] = None,
        publisher_chat: Optional[Chat] = None,
        personal_total_count: Optional[Int] = None,
        personal_remaining_count: Optional[Int] = None,
        background: Optional[GiftBackground] = None,
        is_premium: Optional[Bool] = None,
        has_colors: Optional[Bool] = None,
        unique_gift_variant_count: Optional[Int] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.id = id.copy()
        self.sticker = sticker.copy()
        self.star_count = star_count
        self.total_count = total_count.copy()
        self.remaining_count = remaining_count.copy()
        self.upgrade_star_count = upgrade_star_count.copy()
        self.publisher_chat = publisher_chat.copy()
        self.personal_total_count = personal_total_count.copy()
        self.personal_remaining_count = personal_remaining_count.copy()
        self.background = background.copy()
        self.is_premium = is_premium.copy()
        self.has_colors = has_colors.copy()
        self.unique_gift_variant_count = unique_gift_variant_count.copy()
        self.api_kwargs = _gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.sticker = existing.sticker.copy()
        self.star_count = existing.star_count
        self.total_count = existing.total_count.copy()
        self.remaining_count = existing.remaining_count.copy()
        self.upgrade_star_count = existing.upgrade_star_count.copy()
        self.publisher_chat = existing.publisher_chat.copy()
        self.personal_total_count = existing.personal_total_count.copy()
        self.personal_remaining_count = existing.personal_remaining_count.copy()
        self.background = existing.background.copy()
        self.is_premium = existing.is_premium.copy()
        self.has_colors = existing.has_colors.copy()
        self.unique_gift_variant_count = existing.unique_gift_variant_count.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.background is not None:
            var value = self.background.value().to_dict(recursive)
            var index = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "background", index)
        if self.has_colors is not None:
            result.set_boolean(result.root, "has_colors", self.has_colors.value())
        result.set_string(result.root, "id", self.id)
        if self.is_premium is not None:
            result.set_boolean(result.root, "is_premium", self.is_premium.value())
        if self.personal_remaining_count is not None:
            result.set_number(result.root, "personal_remaining_count", String(self.personal_remaining_count.value()))
        if self.personal_total_count is not None:
            result.set_number(result.root, "personal_total_count", String(self.personal_total_count.value()))
        if self.publisher_chat is not None:
            var value = self.publisher_chat.value().to_dict(recursive)
            var index = result.copy_subtree_from(value, value.root)
            result.object_set(result.root, "publisher_chat", index)
        if self.remaining_count is not None:
            result.set_number(result.root, "remaining_count", String(self.remaining_count.value()))
        result.set_number(result.root, "star_count", String(self.star_count))
        var sticker = self.sticker.to_dict(recursive)
        var sticker_index = result.copy_subtree_from(sticker, sticker.root)
        result.object_set(result.root, "sticker", sticker_index)
        if self.total_count is not None:
            result.set_number(result.root, "total_count", String(self.total_count.value()))
        if self.unique_gift_variant_count is not None:
            result.set_number(result.root, "unique_gift_variant_count", String(self.unique_gift_variant_count.value()))
        if self.upgrade_star_count is not None:
            result.set_number(result.root, "upgrade_star_count", String(self.upgrade_star_count.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Gift JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var sticker_index = data.object_get(data.root, "sticker")
        var stars_index = data.object_get(data.root, "star_count")
        if id_index == -1 or sticker_index == -1 or stars_index == -1:
            raise Error("Gift JSON object is missing a required field")
        var id = data.string_value(id_index)
        var star_count = data.integer_value(stars_index)
        var sticker = Sticker.de_json(_gift_nested(data, sticker_index))
        var publisher_chat: Optional[Chat] = None
        var chat_index = data.object_get(data.root, "publisher_chat")
        if chat_index != -1 and not data.is_null(chat_index):
            publisher_chat = Optional[Chat](Chat.de_json(_gift_nested(data, chat_index)))
        var background: Optional[GiftBackground] = None
        var background_index = data.object_get(data.root, "background")
        if background_index != -1 and not data.is_null(background_index):
            background = Optional[GiftBackground](GiftBackground.de_json(_gift_nested(data, background_index)))
        var total_count = _gift_optional_int(data, "total_count")
        var remaining_count = _gift_optional_int(data, "remaining_count")
        var upgrade_star_count = _gift_optional_int(data, "upgrade_star_count")
        var personal_total_count = _gift_optional_int(data, "personal_total_count")
        var personal_remaining_count = _gift_optional_int(data, "personal_remaining_count")
        var is_premium = _gift_optional_bool(data, "is_premium")
        var has_colors = _gift_optional_bool(data, "has_colors")
        var unique_gift_variant_count = _gift_optional_int(data, "unique_gift_variant_count")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "id" or key == "sticker" or key == "star_count" or
                key == "total_count" or key == "remaining_count" or
                key == "upgrade_star_count" or key == "publisher_chat" or
                key == "personal_total_count" or key == "personal_remaining_count" or
                key == "background" or key == "is_premium" or key == "has_colors" or
                key == "unique_gift_variant_count"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            id, sticker, star_count, total_count, remaining_count, upgrade_star_count,
            publisher_chat, personal_total_count, personal_remaining_count, background,
            is_premium, has_colors, unique_gift_variant_count,
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


struct Gifts(Equatable, Hashable, Copyable, TelegramJsonObject):
    """An ordered collection of Telegram gifts."""

    var gifts: List[Gift]
    var api_kwargs: JsonDocument

    def __init__(out self, gifts: List[Gift], *, api_kwargs: Optional[JsonDocument] = None):
        self.gifts = List[Gift](copy=gifts)
        self.api_kwargs = _gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.gifts = List[Gift](copy=existing.gifts)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if len(self.gifts) != len(other.gifts):
            return False
        for index in range(len(self.gifts)):
            if self.gifts[index] != other.gifts[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        for gift in self.gifts:
            hasher.update(gift.id.as_bytes())
            hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var values = result.add_array()
        for gift in self.gifts:
            var item = gift.to_dict(recursive)
            var index = result.copy_subtree_from(item, item.root)
            result.append_child(values, index)
        result.object_set(result.root, "gifts", values)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Gifts JSON value must be an object")
        var gifts = List[Gift]()
        var gifts_index = data.object_get(data.root, "gifts")
        if gifts_index != -1 and not data.is_null(gifts_index):
            var items = data.array_documents(gifts_index)
            for item in items:
                gifts.append(Gift.de_json(item))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            if data.nodes[child].name != "gifts":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, data.nodes[child].name.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(gifts, api_kwargs=Optional[JsonDocument](api_kwargs.copy()))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


struct GiftInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A received or sent regular gift and its optional attached text."""

    var gift: Gift
    var owned_gift_id: Optional[String]
    var convert_star_count: Optional[Int]
    var prepaid_upgrade_star_count: Optional[Int]
    var can_be_upgraded: Optional[Bool]
    var text: Optional[String]
    var entities: List[MessageEntity]
    var is_private: Optional[Bool]
    var unique_gift_number: Optional[Int]
    var is_upgrade_separate: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        gift: Gift,
        owned_gift_id: Optional[String] = None,
        convert_star_count: Optional[Int] = None,
        prepaid_upgrade_star_count: Optional[Int] = None,
        can_be_upgraded: Optional[Bool] = None,
        text: Optional[String] = None,
        entities: Optional[List[MessageEntity]] = None,
        is_private: Optional[Bool] = None,
        unique_gift_number: Optional[Int] = None,
        is_upgrade_separate: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.gift = gift.copy()
        self.owned_gift_id = owned_gift_id.copy()
        self.convert_star_count = convert_star_count.copy()
        self.prepaid_upgrade_star_count = prepaid_upgrade_star_count.copy()
        self.can_be_upgraded = can_be_upgraded.copy()
        self.text = text.copy()
        self.entities = List[MessageEntity]()
        if entities is not None:
            self.entities = List[MessageEntity](copy=entities.value())
        self.is_private = is_private.copy()
        self.unique_gift_number = unique_gift_number.copy()
        self.is_upgrade_separate = is_upgrade_separate.copy()
        self.api_kwargs = _gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.gift = existing.gift.copy()
        self.owned_gift_id = existing.owned_gift_id.copy()
        self.convert_star_count = existing.convert_star_count.copy()
        self.prepaid_upgrade_star_count = existing.prepaid_upgrade_star_count.copy()
        self.can_be_upgraded = existing.can_be_upgraded.copy()
        self.text = existing.text.copy()
        self.entities = List[MessageEntity](copy=existing.entities)
        self.is_private = existing.is_private.copy()
        self.unique_gift_number = existing.unique_gift_number.copy()
        self.is_upgrade_separate = existing.is_upgrade_separate.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.gift == other.gift

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.gift.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.can_be_upgraded is not None:
            result.set_boolean(result.root, "can_be_upgraded", self.can_be_upgraded.value())
        if self.convert_star_count is not None:
            result.set_number(result.root, "convert_star_count", String(self.convert_star_count.value()))
        var entities = result.add_array()
        for entity in self.entities:
            var entity_data = entity.to_dict(recursive)
            var entity_index = result.copy_subtree_from(entity_data, entity_data.root)
            result.append_child(entities, entity_index)
        result.object_set(result.root, "entities", entities)
        var gift_data = self.gift.to_dict(recursive)
        var gift_index = result.copy_subtree_from(gift_data, gift_data.root)
        result.object_set(result.root, "gift", gift_index)
        if self.is_private is not None:
            result.set_boolean(result.root, "is_private", self.is_private.value())
        if self.is_upgrade_separate is not None:
            result.set_boolean(result.root, "is_upgrade_separate", self.is_upgrade_separate.value())
        if self.owned_gift_id is not None:
            result.set_string(result.root, "owned_gift_id", self.owned_gift_id.value())
        if self.prepaid_upgrade_star_count is not None:
            result.set_number(result.root, "prepaid_upgrade_star_count", String(self.prepaid_upgrade_star_count.value()))
        if self.text is not None:
            result.set_string(result.root, "text", self.text.value())
        if self.unique_gift_number is not None:
            result.set_number(result.root, "unique_gift_number", String(self.unique_gift_number.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def parse_entity(self, entity: MessageEntity) raises -> String:
        if self.text is None or self.text.value().byte_length() == 0:
            raise Error("This GiftInfo has no 'text'.")
        return parse_message_entity(self.text.value(), entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        if self.text is None or self.text.value().byte_length() == 0:
            raise Error("This GiftInfo has no 'text'.")
        return parse_message_entities(self.text.value(), self.entities, types)

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("GiftInfo JSON value must be an object")
        var gift_index = data.object_get(data.root, "gift")
        if gift_index == -1 or data.is_null(gift_index):
            raise Error("GiftInfo JSON object is missing gift")
        var gift = Gift.de_json(_gift_nested(data, gift_index))
        var entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "entities")
        if entities_index != -1 and not data.is_null(entities_index):
            var entity_data = data.array_documents(entities_index)
            for item in entity_data:
                entities.append(MessageEntity.de_json(item))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var known = (
                key == "gift" or key == "owned_gift_id" or key == "convert_star_count" or
                key == "prepaid_upgrade_star_count" or key == "can_be_upgraded" or
                key == "text" or key == "entities" or key == "is_private" or
                key == "unique_gift_number" or key == "is_upgrade_separate"
            )
            if not known:
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            gift,
            _gift_optional_string(data, "owned_gift_id"),
            _gift_optional_int(data, "convert_star_count"),
            _gift_optional_int(data, "prepaid_upgrade_star_count"),
            _gift_optional_bool(data, "can_be_upgraded"),
            _gift_optional_string(data, "text"),
            Optional[List[MessageEntity]](entities.copy()),
            _gift_optional_bool(data, "is_private"),
            _gift_optional_int(data, "unique_gift_number"),
            _gift_optional_bool(data, "is_upgrade_separate"),
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^

struct AcceptedGiftTypes(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream AcceptedGiftTypes."""

    var unlimited_gifts: Bool
    var limited_gifts: Bool
    var unique_gifts: Bool
    var premium_subscription: Bool
    var gifts_from_channels: Bool
    var api_kwargs: JsonDocument

    def __init__(out self, unlimited_gifts: Bool, limited_gifts: Bool, unique_gifts: Bool, premium_subscription: Bool, gifts_from_channels: Bool):
        self.unlimited_gifts = unlimited_gifts
        self.limited_gifts = limited_gifts
        self.unique_gifts = unique_gifts
        self.premium_subscription = premium_subscription
        self.gifts_from_channels = gifts_from_channels
        self.api_kwargs = empty_json_object()

    def __init__(out self, unlimited_gifts: Bool, limited_gifts: Bool, unique_gifts: Bool, premium_subscription: Bool, gifts_from_channels: Bool, api_kwargs: JsonDocument):
        self.unlimited_gifts = unlimited_gifts
        self.limited_gifts = limited_gifts
        self.unique_gifts = unique_gifts
        self.premium_subscription = premium_subscription
        self.gifts_from_channels = gifts_from_channels
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.unlimited_gifts = existing.unlimited_gifts
        self.limited_gifts = existing.limited_gifts
        self.unique_gifts = existing.unique_gifts
        self.premium_subscription = existing.premium_subscription
        self.gifts_from_channels = existing.gifts_from_channels
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.unlimited_gifts == other.unlimited_gifts and self.limited_gifts == other.limited_gifts and self.unique_gifts == other.unique_gifts and self.premium_subscription == other.premium_subscription and self.gifts_from_channels == other.gifts_from_channels

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.unlimited_gifts:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.limited_gifts:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.unique_gifts:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.premium_subscription:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.gifts_from_channels:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "gifts_from_channels", self.gifts_from_channels)
        result.set_boolean(result.root, "limited_gifts", self.limited_gifts)
        result.set_boolean(result.root, "premium_subscription", self.premium_subscription)
        result.set_boolean(result.root, "unique_gifts", self.unique_gifts)
        result.set_boolean(result.root, "unlimited_gifts", self.unlimited_gifts)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> AcceptedGiftTypes:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("AcceptedGiftTypes JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("AcceptedGiftTypes JSON value is not an object")
        var parsed_unlimited_gifts_index = data.object_get(data.root, "unlimited_gifts")
        if parsed_unlimited_gifts_index == -1:
            raise Error("AcceptedGiftTypes JSON object is missing unlimited_gifts")
        var parsed_unlimited_gifts = data.boolean_value(parsed_unlimited_gifts_index)
        var parsed_limited_gifts_index = data.object_get(data.root, "limited_gifts")
        if parsed_limited_gifts_index == -1:
            raise Error("AcceptedGiftTypes JSON object is missing limited_gifts")
        var parsed_limited_gifts = data.boolean_value(parsed_limited_gifts_index)
        var parsed_unique_gifts_index = data.object_get(data.root, "unique_gifts")
        if parsed_unique_gifts_index == -1:
            raise Error("AcceptedGiftTypes JSON object is missing unique_gifts")
        var parsed_unique_gifts = data.boolean_value(parsed_unique_gifts_index)
        var parsed_premium_subscription_index = data.object_get(data.root, "premium_subscription")
        if parsed_premium_subscription_index == -1:
            raise Error("AcceptedGiftTypes JSON object is missing premium_subscription")
        var parsed_premium_subscription = data.boolean_value(parsed_premium_subscription_index)
        var parsed_gifts_from_channels_index = data.object_get(data.root, "gifts_from_channels")
        if parsed_gifts_from_channels_index == -1:
            raise Error("AcceptedGiftTypes JSON object is missing gifts_from_channels")
        var parsed_gifts_from_channels = data.boolean_value(parsed_gifts_from_channels_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "unlimited_gifts" and key != "limited_gifts" and key != "unique_gifts" and key != "premium_subscription" and key != "gifts_from_channels":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return AcceptedGiftTypes(parsed_unlimited_gifts, parsed_limited_gifts, parsed_unique_gifts, parsed_premium_subscription, parsed_gifts_from_channels, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[AcceptedGiftTypes]:
        var items = data.array_documents(array_index)
        var result = List[AcceptedGiftTypes]()
        for index in range(len(items)):
            result.append(AcceptedGiftTypes.de_json(items[index].copy()))
        return result^
struct GiftBackground(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream GiftBackground."""

    var center_color: Int
    var edge_color: Int
    var text_color: Int
    var api_kwargs: JsonDocument

    def __init__(out self, center_color: Int, edge_color: Int, text_color: Int):
        self.center_color = center_color
        self.edge_color = edge_color
        self.text_color = text_color
        self.api_kwargs = empty_json_object()

    def __init__(out self, center_color: Int, edge_color: Int, text_color: Int, api_kwargs: JsonDocument):
        self.center_color = center_color
        self.edge_color = edge_color
        self.text_color = text_color
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.center_color = existing.center_color
        self.edge_color = existing.edge_color
        self.text_color = existing.text_color
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.center_color == other.center_color and self.edge_color == other.edge_color and self.text_color == other.text_color

    def __hash__[H: Hasher](self, mut hasher: H):
        var center_color_hash_text = String(self.center_color)
        hasher.update(center_color_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var edge_color_hash_text = String(self.edge_color)
        hasher.update(edge_color_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var text_color_hash_text = String(self.text_color)
        hasher.update(text_color_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "center_color", String(self.center_color))
        result.set_number(result.root, "edge_color", String(self.edge_color))
        result.set_number(result.root, "text_color", String(self.text_color))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> GiftBackground:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("GiftBackground JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("GiftBackground JSON value is not an object")
        var parsed_center_color_index = data.object_get(data.root, "center_color")
        if parsed_center_color_index == -1:
            raise Error("GiftBackground JSON object is missing center_color")
        var parsed_center_color = data.integer_value(parsed_center_color_index)
        var parsed_edge_color_index = data.object_get(data.root, "edge_color")
        if parsed_edge_color_index == -1:
            raise Error("GiftBackground JSON object is missing edge_color")
        var parsed_edge_color = data.integer_value(parsed_edge_color_index)
        var parsed_text_color_index = data.object_get(data.root, "text_color")
        if parsed_text_color_index == -1:
            raise Error("GiftBackground JSON object is missing text_color")
        var parsed_text_color = data.integer_value(parsed_text_color_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "center_color" and key != "edge_color" and key != "text_color":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return GiftBackground(parsed_center_color, parsed_edge_color, parsed_text_color, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[GiftBackground]:
        var items = data.array_documents(array_index)
        var result = List[GiftBackground]()
        for index in range(len(items)):
            result.append(GiftBackground.de_json(items[index].copy()))
        return result^
