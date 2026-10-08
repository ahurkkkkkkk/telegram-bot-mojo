#!/usr/bin/env mojo
#
# Native translations of selected python-telegram-bot v22.8 giveaway models.
# LGPL-3.0-or-later; see LICENSE.

"""Scheduled giveaway values and public winner summaries."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _giveaway_require_object(data: JsonDocument, model: String) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error(model + " JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error(model + " JSON value is not an object")


def _giveaway_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("Giveaway nested JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _giveaway_api_kwargs(data: JsonDocument, known_fields: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = False
        for field in known_fields:
            if key == field:
                known = True
        if not known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _giveaway_chat_list(data: JsonDocument, index: Int) raises -> List[Chat]:
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error("Giveaway chats must be a JSON array")
    var result = List[Chat]()
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(Chat.de_json(_giveaway_nested(data, child)))
        child = data.nodes[child].next_sibling
    return result^


def _giveaway_user_list(data: JsonDocument, index: Int) raises -> List[User]:
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error("Giveaway winners must be a JSON array")
    var result = List[User]()
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(User.de_json(_giveaway_nested(data, child)))
        child = data.nodes[child].next_sibling
    return result^


def _giveaway_put_chats(mut result: JsonDocument, chats: List[Chat], recursive: Bool) raises:
    var array_node = result.add_array()
    for chat in chats:
        var document = chat.to_dict(recursive=recursive)
        var node = result.copy_subtree_from(document, document.root)
        result.append_child(array_node, node)
    result.object_set(result.root, "chats", array_node)


def _giveaway_put_users(mut result: JsonDocument, winners: List[User], recursive: Bool) raises:
    var array_node = result.add_array()
    for user in winners:
        var document = user.to_dict(recursive=recursive)
        var node = result.copy_subtree_from(document, document.root)
        result.append_child(array_node, node)
    result.object_set(result.root, "winners", array_node)


struct Giveaway(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A scheduled giveaway's participation rules and prize metadata."""

    var chats: List[Chat]
    var winners_selection_date: TimestampDateTime
    var winner_count: Int
    var only_new_members: Optional[Bool]
    var has_public_winners: Optional[Bool]
    var prize_description: Optional[String]
    var country_codes: List[String]
    var premium_subscription_month_count: Optional[Int]
    var prize_star_count: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, chats: List[Chat], winners_selection_date: TimestampDateTime, winner_count: Int):
        self.chats = chats.copy()
        self.winners_selection_date = winners_selection_date.copy()
        self.winner_count = winner_count
        self.only_new_members = None
        self.has_public_winners = None
        self.prize_description = None
        self.country_codes = List[String]()
        self.premium_subscription_month_count = None
        self.prize_star_count = None
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        chats: List[Chat],
        winners_selection_date: TimestampDateTime,
        winner_count: Int,
        only_new_members: Optional[Bool] = None,
        has_public_winners: Optional[Bool] = None,
        prize_description: Optional[String] = None,
        country_codes: List[String] = List[String](),
        premium_subscription_month_count: Optional[Int] = None,
        prize_star_count: Optional[Int] = None,
    ):
        self.chats = chats.copy()
        self.winners_selection_date = winners_selection_date.copy()
        self.winner_count = winner_count
        self.only_new_members = only_new_members
        self.has_public_winners = has_public_winners
        self.prize_description = prize_description
        self.country_codes = country_codes.copy()
        self.premium_subscription_month_count = premium_subscription_month_count
        self.prize_star_count = prize_star_count
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        chats: List[Chat],
        winners_selection_date: TimestampDateTime,
        winner_count: Int,
        only_new_members: Optional[Bool],
        has_public_winners: Optional[Bool],
        prize_description: Optional[String],
        country_codes: List[String],
        premium_subscription_month_count: Optional[Int],
        prize_star_count: Optional[Int],
        *,
        api_kwargs: JsonDocument,
    ):
        self.chats = chats.copy()
        self.winners_selection_date = winners_selection_date.copy()
        self.winner_count = winner_count
        self.only_new_members = only_new_members
        self.has_public_winners = has_public_winners
        self.prize_description = prize_description
        self.country_codes = country_codes.copy()
        self.premium_subscription_month_count = premium_subscription_month_count
        self.prize_star_count = prize_star_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chats = existing.chats.copy()
        self.winners_selection_date = existing.winners_selection_date.copy()
        self.winner_count = existing.winner_count
        self.only_new_members = existing.only_new_members.copy()
        self.has_public_winners = existing.has_public_winners.copy()
        self.prize_description = existing.prize_description.copy()
        self.country_codes = existing.country_codes.copy()
        self.premium_subscription_month_count = existing.premium_subscription_month_count.copy()
        self.prize_star_count = existing.prize_star_count.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.chats != other.chats or self.winners_selection_date != other.winners_selection_date:
            return False
        return self.winner_count == other.winner_count

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("Giveaway\0").as_bytes())
        for chat in self.chats:
            hasher.update(String(hash(chat)).as_bytes())
            hasher.update(String(",").as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.winners_selection_date)).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.winner_count).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        _giveaway_put_chats(result, self.chats, recursive)
        result.set_number(result.root, "winners_selection_date", String(to_timestamp(self.winners_selection_date)))
        result.set_number(result.root, "winner_count", String(self.winner_count))
        if self.only_new_members is not None:
            result.set_boolean(result.root, "only_new_members", self.only_new_members.value())
        if self.has_public_winners is not None:
            result.set_boolean(result.root, "has_public_winners", self.has_public_winners.value())
        if self.prize_description is not None:
            result.set_string(result.root, "prize_description", self.prize_description.value())
        if len(self.country_codes) > 0:
            var codes = result.add_array()
            for country in self.country_codes:
                var code = result.add_string(country.copy())
                result.append_child(codes, code)
            result.object_set(result.root, "country_codes", codes)
        if self.premium_subscription_month_count is not None:
            result.set_number(result.root, "premium_subscription_month_count", String(self.premium_subscription_month_count.value()))
        if self.prize_star_count is not None:
            result.set_number(result.root, "prize_star_count", String(self.prize_star_count.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _giveaway_require_object(data, "Giveaway")
        var chats_index = data.object_get(data.root, "chats")
        var date_index = data.object_get(data.root, "winners_selection_date")
        var count_index = data.object_get(data.root, "winner_count")
        if chats_index == -1 or date_index == -1 or count_index == -1:
            raise Error("Giveaway JSON object is missing a required field")
        if data.is_null(chats_index) or data.is_null(date_index) or data.is_null(count_index):
            raise Error("Giveaway required field is null")
        var only_new_members: Optional[Bool] = None
        var index = data.object_get(data.root, "only_new_members")
        if index != -1 and not data.is_null(index):
            only_new_members = Optional[Bool](data.boolean_value(index))
        var has_public_winners: Optional[Bool] = None
        index = data.object_get(data.root, "has_public_winners")
        if index != -1 and not data.is_null(index):
            has_public_winners = Optional[Bool](data.boolean_value(index))
        var prize_description: Optional[String] = None
        index = data.object_get(data.root, "prize_description")
        if index != -1 and not data.is_null(index):
            prize_description = Optional[String](data.string_value(index))
        var country_codes = List[String]()
        index = data.object_get(data.root, "country_codes")
        if index != -1 and not data.is_null(index):
            if data.nodes[index].kind != JSON_ARRAY:
                raise Error("Giveaway country_codes must be an array")
            var child = data.nodes[index].first_child
            while child != -1:
                country_codes.append(data.string_value(child))
                child = data.nodes[child].next_sibling
        var premium_count: Optional[Int] = None
        index = data.object_get(data.root, "premium_subscription_month_count")
        if index != -1 and not data.is_null(index):
            premium_count = Optional[Int](data.integer_value(index))
        var star_count: Optional[Int] = None
        index = data.object_get(data.root, "prize_star_count")
        if index != -1 and not data.is_null(index):
            star_count = Optional[Int](data.integer_value(index))
        var known = List[String]()
        known.append("chats")
        known.append("winners_selection_date")
        known.append("winner_count")
        known.append("only_new_members")
        known.append("has_public_winners")
        known.append("prize_description")
        known.append("country_codes")
        known.append("premium_subscription_month_count")
        known.append("prize_star_count")
        return Giveaway(
            _giveaway_chat_list(data, chats_index),
            from_timestamp(data.integer_value(date_index)),
            data.integer_value(count_index),
            only_new_members,
            has_public_winners,
            prize_description,
            country_codes,
            premium_count,
            star_count,
            api_kwargs=_giveaway_api_kwargs(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct GiveawayCreated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A service event recording creation of a scheduled giveaway."""

    var prize_star_count: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, prize_star_count: Optional[Int] = None):
        self.prize_star_count = prize_star_count
        self.api_kwargs = empty_json_object()

    def __init__(out self, prize_star_count: Optional[Int], *, api_kwargs: JsonDocument):
        self.prize_star_count = prize_star_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.prize_star_count = existing.prize_star_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.prize_star_count == other.prize_star_count

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("GiveawayCreated\0").as_bytes())
        if self.prize_star_count is not None:
            hasher.update(String(self.prize_star_count.value()).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.prize_star_count is not None:
            result.set_number(result.root, "prize_star_count", String(self.prize_star_count.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _giveaway_require_object(data, "GiveawayCreated")
        var value: Optional[Int] = None
        var index = data.object_get(data.root, "prize_star_count")
        if index != -1 and not data.is_null(index):
            value = Optional[Int](data.integer_value(index))
        var known = List[String]()
        known.append("prize_star_count")
        return GiveawayCreated(value, api_kwargs=_giveaway_api_kwargs(data, known))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct GiveawayWinners(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A public giveaway winner summary."""

    var chat: Chat
    var giveaway_message_id: Int
    var winners_selection_date: TimestampDateTime
    var winner_count: Int
    var winners: List[User]
    var additional_chat_count: Optional[Int]
    var premium_subscription_month_count: Optional[Int]
    var unclaimed_prize_count: Optional[Int]
    var only_new_members: Optional[Bool]
    var was_refunded: Optional[Bool]
    var prize_description: Optional[String]
    var prize_star_count: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        chat: Chat,
        giveaway_message_id: Int,
        winners_selection_date: TimestampDateTime,
        winner_count: Int,
        winners: List[User],
    ):
        self.chat = chat.copy()
        self.giveaway_message_id = giveaway_message_id
        self.winners_selection_date = winners_selection_date.copy()
        self.winner_count = winner_count
        self.winners = winners.copy()
        self.additional_chat_count = None
        self.premium_subscription_month_count = None
        self.unclaimed_prize_count = None
        self.only_new_members = None
        self.was_refunded = None
        self.prize_description = None
        self.prize_star_count = None
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        chat: Chat,
        giveaway_message_id: Int,
        winners_selection_date: TimestampDateTime,
        winner_count: Int,
        winners: List[User],
        additional_chat_count: Optional[Int] = None,
        premium_subscription_month_count: Optional[Int] = None,
        unclaimed_prize_count: Optional[Int] = None,
        only_new_members: Optional[Bool] = None,
        was_refunded: Optional[Bool] = None,
        prize_description: Optional[String] = None,
        prize_star_count: Optional[Int] = None,
    ):
        self.chat = chat.copy()
        self.giveaway_message_id = giveaway_message_id
        self.winners_selection_date = winners_selection_date.copy()
        self.winner_count = winner_count
        self.winners = winners.copy()
        self.additional_chat_count = additional_chat_count
        self.premium_subscription_month_count = premium_subscription_month_count
        self.unclaimed_prize_count = unclaimed_prize_count
        self.only_new_members = only_new_members
        self.was_refunded = was_refunded
        self.prize_description = prize_description
        self.prize_star_count = prize_star_count
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        chat: Chat,
        giveaway_message_id: Int,
        winners_selection_date: TimestampDateTime,
        winner_count: Int,
        winners: List[User],
        additional_chat_count: Optional[Int],
        premium_subscription_month_count: Optional[Int],
        unclaimed_prize_count: Optional[Int],
        only_new_members: Optional[Bool],
        was_refunded: Optional[Bool],
        prize_description: Optional[String],
        prize_star_count: Optional[Int],
        *,
        api_kwargs: JsonDocument,
    ):
        self.chat = chat.copy()
        self.giveaway_message_id = giveaway_message_id
        self.winners_selection_date = winners_selection_date.copy()
        self.winner_count = winner_count
        self.winners = winners.copy()
        self.additional_chat_count = additional_chat_count
        self.premium_subscription_month_count = premium_subscription_month_count
        self.unclaimed_prize_count = unclaimed_prize_count
        self.only_new_members = only_new_members
        self.was_refunded = was_refunded
        self.prize_description = prize_description
        self.prize_star_count = prize_star_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.giveaway_message_id = existing.giveaway_message_id
        self.winners_selection_date = existing.winners_selection_date.copy()
        self.winner_count = existing.winner_count
        self.winners = existing.winners.copy()
        self.additional_chat_count = existing.additional_chat_count
        self.premium_subscription_month_count = existing.premium_subscription_month_count
        self.unclaimed_prize_count = existing.unclaimed_prize_count
        self.only_new_members = existing.only_new_members
        self.was_refunded = existing.was_refunded
        self.prize_description = existing.prize_description.copy()
        self.prize_star_count = existing.prize_star_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.chat != other.chat or self.giveaway_message_id != other.giveaway_message_id:
            return False
        if self.winners_selection_date != other.winners_selection_date or self.winner_count != other.winner_count:
            return False
        if len(self.winners) != len(other.winners):
            return False
        for index in range(len(self.winners)):
            if self.winners[index] != other.winners[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("GiveawayWinners\0").as_bytes())
        hasher.update(String(hash(self.chat)).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.giveaway_message_id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.winners_selection_date)).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.winner_count).as_bytes())
        for winner in self.winners:
            hasher.update(String(hash(winner)).as_bytes())
            hasher.update(String(",").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var chat_document = self.chat.to_dict(recursive=recursive)
        var chat_node = result.copy_subtree_from(chat_document, chat_document.root)
        result.object_set(result.root, "chat", chat_node)
        result.set_number(result.root, "giveaway_message_id", String(self.giveaway_message_id))
        result.set_number(result.root, "winners_selection_date", String(to_timestamp(self.winners_selection_date)))
        result.set_number(result.root, "winner_count", String(self.winner_count))
        _giveaway_put_users(result, self.winners, recursive)
        if self.additional_chat_count is not None:
            result.set_number(result.root, "additional_chat_count", String(self.additional_chat_count.value()))
        if self.premium_subscription_month_count is not None:
            result.set_number(result.root, "premium_subscription_month_count", String(self.premium_subscription_month_count.value()))
        if self.unclaimed_prize_count is not None:
            result.set_number(result.root, "unclaimed_prize_count", String(self.unclaimed_prize_count.value()))
        if self.only_new_members is not None:
            result.set_boolean(result.root, "only_new_members", self.only_new_members.value())
        if self.was_refunded is not None:
            result.set_boolean(result.root, "was_refunded", self.was_refunded.value())
        if self.prize_description is not None:
            result.set_string(result.root, "prize_description", self.prize_description.value())
        if self.prize_star_count is not None:
            result.set_number(result.root, "prize_star_count", String(self.prize_star_count.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _giveaway_require_object(data, "GiveawayWinners")
        var chat_index = data.object_get(data.root, "chat")
        var message_id_index = data.object_get(data.root, "giveaway_message_id")
        var date_index = data.object_get(data.root, "winners_selection_date")
        var count_index = data.object_get(data.root, "winner_count")
        var winners_index = data.object_get(data.root, "winners")
        if chat_index == -1 or message_id_index == -1 or date_index == -1 or count_index == -1 or winners_index == -1:
            raise Error("GiveawayWinners JSON object is missing a required field")
        if data.is_null(chat_index) or data.is_null(date_index) or data.is_null(count_index) or data.is_null(winners_index):
            raise Error("GiveawayWinners required field is null")
        var additional_chat_count: Optional[Int] = None
        var index = data.object_get(data.root, "additional_chat_count")
        if index != -1 and not data.is_null(index):
            additional_chat_count = Optional[Int](data.integer_value(index))
        var premium_count: Optional[Int] = None
        index = data.object_get(data.root, "premium_subscription_month_count")
        if index != -1 and not data.is_null(index):
            premium_count = Optional[Int](data.integer_value(index))
        var unclaimed_count: Optional[Int] = None
        index = data.object_get(data.root, "unclaimed_prize_count")
        if index != -1 and not data.is_null(index):
            unclaimed_count = Optional[Int](data.integer_value(index))
        var only_new_members: Optional[Bool] = None
        index = data.object_get(data.root, "only_new_members")
        if index != -1 and not data.is_null(index):
            only_new_members = Optional[Bool](data.boolean_value(index))
        var was_refunded: Optional[Bool] = None
        index = data.object_get(data.root, "was_refunded")
        if index != -1 and not data.is_null(index):
            was_refunded = Optional[Bool](data.boolean_value(index))
        var prize_description: Optional[String] = None
        index = data.object_get(data.root, "prize_description")
        if index != -1 and not data.is_null(index):
            prize_description = Optional[String](data.string_value(index))
        var prize_star_count: Optional[Int] = None
        index = data.object_get(data.root, "prize_star_count")
        if index != -1 and not data.is_null(index):
            prize_star_count = Optional[Int](data.integer_value(index))
        var known = List[String]()
        known.append("chat")
        known.append("giveaway_message_id")
        known.append("winners_selection_date")
        known.append("winner_count")
        known.append("winners")
        known.append("additional_chat_count")
        known.append("premium_subscription_month_count")
        known.append("unclaimed_prize_count")
        known.append("only_new_members")
        known.append("was_refunded")
        known.append("prize_description")
        known.append("prize_star_count")
        return GiveawayWinners(
            Chat.de_json(_giveaway_nested(data, chat_index)),
            data.integer_value(message_id_index),
            from_timestamp(data.integer_value(date_index)),
            data.integer_value(count_index),
            _giveaway_user_list(data, winners_index),
            additional_chat_count,
            premium_count,
            unclaimed_count,
            only_new_members,
            was_refunded,
            prize_description,
            prize_star_count,
            api_kwargs=_giveaway_api_kwargs(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct GiveawayCompleted(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A completion event for a giveaway without public winners."""

    var winner_count: Int
    var unclaimed_prize_count: Optional[Int]
    var giveaway_message: Optional[JsonDocument]
    var is_star_giveaway: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        winner_count: Int,
        unclaimed_prize_count: Optional[Int] = None,
        giveaway_message: Optional[JsonDocument] = None,
        is_star_giveaway: Optional[Bool] = None,
    ):
        self.winner_count = winner_count
        self.unclaimed_prize_count = unclaimed_prize_count
        self.giveaway_message = giveaway_message.copy()
        self.is_star_giveaway = is_star_giveaway
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        winner_count: Int,
        unclaimed_prize_count: Optional[Int],
        giveaway_message: Optional[JsonDocument],
        is_star_giveaway: Optional[Bool],
        *,
        api_kwargs: JsonDocument,
    ):
        self.winner_count = winner_count
        self.unclaimed_prize_count = unclaimed_prize_count
        self.giveaway_message = giveaway_message.copy()
        self.is_star_giveaway = is_star_giveaway
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.winner_count = existing.winner_count
        self.unclaimed_prize_count = existing.unclaimed_prize_count
        self.giveaway_message = existing.giveaway_message.copy()
        self.is_star_giveaway = existing.is_star_giveaway
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.winner_count == other.winner_count and self.unclaimed_prize_count == other.unclaimed_prize_count

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("GiveawayCompleted\0").as_bytes())
        hasher.update(String(self.winner_count).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.unclaimed_prize_count is not None:
            hasher.update(String(self.unclaimed_prize_count.value()).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "winner_count", String(self.winner_count))
        if self.unclaimed_prize_count is not None:
            result.set_number(result.root, "unclaimed_prize_count", String(self.unclaimed_prize_count.value()))
        if self.giveaway_message is not None:
            var message = self.giveaway_message.value().copy()
            var node = result.copy_subtree_from(message, message.root)
            result.object_set(result.root, "giveaway_message", node)
        if self.is_star_giveaway is not None:
            result.set_boolean(result.root, "is_star_giveaway", self.is_star_giveaway.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _giveaway_require_object(data, "GiveawayCompleted")
        var count_index = data.object_get(data.root, "winner_count")
        if count_index == -1 or data.is_null(count_index):
            raise Error("GiveawayCompleted JSON object is missing winner_count")
        var unclaimed: Optional[Int] = None
        var index = data.object_get(data.root, "unclaimed_prize_count")
        if index != -1 and not data.is_null(index):
            unclaimed = Optional[Int](data.integer_value(index))
        var message: Optional[JsonDocument] = None
        index = data.object_get(data.root, "giveaway_message")
        if index != -1 and not data.is_null(index):
            message = Optional[JsonDocument](_giveaway_nested(data, index))
        var is_star: Optional[Bool] = None
        index = data.object_get(data.root, "is_star_giveaway")
        if index != -1 and not data.is_null(index):
            is_star = Optional[Bool](data.boolean_value(index))
        var known = List[String]()
        known.append("winner_count")
        known.append("unclaimed_prize_count")
        known.append("giveaway_message")
        known.append("is_star_giveaway")
        return GiveawayCompleted(
            data.integer_value(count_index),
            unclaimed,
            message,
            is_star,
            api_kwargs=_giveaway_api_kwargs(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
