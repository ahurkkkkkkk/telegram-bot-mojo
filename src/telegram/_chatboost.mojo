#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _chatboost.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _chatboost_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("ChatBoost JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _chatboost_unknown(data: JsonDocument, known: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var is_known = False
        for key in known:
            if key == data.nodes[child].name:
                is_known = True
                break
        if not is_known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, data.nodes[child].name.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^

struct ChatBoostAdded(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream ChatBoostAdded."""

    var boost_count: Int
    var api_kwargs: JsonDocument

    def __init__(out self, boost_count: Int):
        self.boost_count = boost_count
        self.api_kwargs = empty_json_object()

    def __init__(out self, boost_count: Int, api_kwargs: JsonDocument):
        self.boost_count = boost_count
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.boost_count = existing.boost_count
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.boost_count == other.boost_count

    def __hash__[H: Hasher](self, mut hasher: H):
        var boost_count_hash_text = String(self.boost_count)
        hasher.update(boost_count_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "boost_count", String(self.boost_count))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostAdded:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ChatBoostAdded JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatBoostAdded JSON value is not an object")
        var parsed_boost_count_index = data.object_get(data.root, "boost_count")
        if parsed_boost_count_index == -1:
            raise Error("ChatBoostAdded JSON object is missing boost_count")
        var parsed_boost_count = data.integer_value(parsed_boost_count_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "boost_count":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatBoostAdded(parsed_boost_count, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostAdded]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostAdded]()
        for index in range(len(items)):
            result.append(ChatBoostAdded.de_json(items[index].copy()))
        return result^


struct ChatBoostSource(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Tagged Premium, gift-code, or giveaway source of a chat boost."""

    comptime PREMIUM = "premium"
    comptime GIFT_CODE = "gift_code"
    comptime GIVEAWAY = "giveaway"

    var source: String
    var user: Optional[User]
    var giveaway_message_id: Optional[Int]
    var prize_star_count: Optional[Int]
    var is_unclaimed: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        source: String,
        user: Optional[User] = None,
        giveaway_message_id: Optional[Int] = None,
        prize_star_count: Optional[Int] = None,
        is_unclaimed: Optional[Bool] = None,
    ):
        self.source = source.copy()
        self.user = user.copy()
        self.giveaway_message_id = giveaway_message_id.copy()
        self.prize_star_count = prize_star_count.copy()
        self.is_unclaimed = is_unclaimed.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        source: String,
        user: Optional[User] = None,
        giveaway_message_id: Optional[Int] = None,
        prize_star_count: Optional[Int] = None,
        is_unclaimed: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.source = source.copy()
        self.user = user.copy()
        self.giveaway_message_id = giveaway_message_id.copy()
        self.prize_star_count = prize_star_count.copy()
        self.is_unclaimed = is_unclaimed.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.source = existing.source.copy()
        self.user = existing.user.copy()
        self.giveaway_message_id = existing.giveaway_message_id.copy()
        self.prize_star_count = existing.prize_star_count.copy()
        self.is_unclaimed = existing.is_unclaimed.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.source == other.source

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.source.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "source", self.source)
        if self.user is not None:
            var user_data = self.user.value().to_dict(recursive=recursive)
            var user_index = result.copy_subtree_from(user_data, user_data.root)
            result.object_set(result.root, "user", user_index)
        if self.giveaway_message_id is not None:
            result.set_number(result.root, "giveaway_message_id", String(self.giveaway_message_id.value()))
        if self.prize_star_count is not None:
            result.set_number(result.root, "prize_star_count", String(self.prize_star_count.value()))
        if self.is_unclaimed is not None:
            result.set_boolean(result.root, "is_unclaimed", self.is_unclaimed.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostSource:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatBoostSource JSON value must be an object")
        var source_index = data.object_get(data.root, "source")
        if source_index == -1 or data.nodes[source_index].kind != JSON_STRING:
            raise Error("ChatBoostSource JSON object is missing source")
        var source = data.string_value(source_index)
        var user: Optional[User] = None
        var user_index = data.object_get(data.root, "user")
        if user_index != -1 and not data.is_null(user_index):
            user = Optional[User](User.de_json(_chatboost_nested(data, user_index)))
        var giveaway_message_id: Optional[Int] = None
        var value_index = data.object_get(data.root, "giveaway_message_id")
        if value_index != -1 and not data.is_null(value_index):
            giveaway_message_id = Optional[Int](data.integer_value(value_index))
        var prize_star_count: Optional[Int] = None
        value_index = data.object_get(data.root, "prize_star_count")
        if value_index != -1 and not data.is_null(value_index):
            prize_star_count = Optional[Int](data.integer_value(value_index))
        var is_unclaimed: Optional[Bool] = None
        value_index = data.object_get(data.root, "is_unclaimed")
        if value_index != -1 and not data.is_null(value_index):
            is_unclaimed = Optional[Bool](data.boolean_value(value_index))
        # Telegram dispatches the three known source tags to constructors with
        # required fields. Keep unknown future tags forward-compatible, while
        # matching those required-field checks for the variants we know.
        if (source == ChatBoostSource.PREMIUM or source == ChatBoostSource.GIFT_CODE) and user is None:
            raise Error("Premium and gift-code chat boost sources require user")
        if source == ChatBoostSource.GIVEAWAY and giveaway_message_id is None:
            raise Error("Giveaway chat boost sources require giveaway_message_id")
        var known = List[String]()
        known.append("source")
        known.append("user")
        known.append("giveaway_message_id")
        known.append("prize_star_count")
        known.append("is_unclaimed")
        return ChatBoostSource(
            source,
            user,
            giveaway_message_id,
            prize_star_count,
            is_unclaimed,
            api_kwargs=_chatboost_unknown(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostSource]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostSource]()
        for item in items:
            result.append(ChatBoostSource.de_json(item.copy()))
        return result^


struct ChatBoostSourcePremium(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A chat boost granted by Telegram Premium."""

    var user: User
    var api_kwargs: JsonDocument

    def __init__(out self, user: User):
        self.user = user.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, user: User, *, api_kwargs: JsonDocument):
        self.user = user.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.user = existing.user.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("premium").as_bytes())

    def to_source(self) -> ChatBoostSource:
        return ChatBoostSource(
            ChatBoostSource.PREMIUM,
            Optional[User](self.user.copy()),
            api_kwargs=self.api_kwargs.copy(),
        )

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.to_source().to_dict(recursive=recursive)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostSourcePremium:
        var source = ChatBoostSource.de_json(data)
        if source.source != ChatBoostSource.PREMIUM or source.user is None:
            raise Error("ChatBoostSourcePremium requires a premium source and user")
        return ChatBoostSourcePremium(source.user.value(), api_kwargs=source.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostSourcePremium]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostSourcePremium]()
        for item in items:
            result.append(ChatBoostSourcePremium.de_json(item.copy()))
        return result^


struct ChatBoostSourceGiftCode(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A chat boost granted by a Telegram Premium gift code."""

    var user: User
    var api_kwargs: JsonDocument

    def __init__(out self, user: User):
        self.user = user.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, user: User, *, api_kwargs: JsonDocument):
        self.user = user.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.user = existing.user.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("gift_code").as_bytes())

    def to_source(self) -> ChatBoostSource:
        return ChatBoostSource(
            ChatBoostSource.GIFT_CODE,
            Optional[User](self.user.copy()),
            api_kwargs=self.api_kwargs.copy(),
        )

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.to_source().to_dict(recursive=recursive)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostSourceGiftCode:
        var source = ChatBoostSource.de_json(data)
        if source.source != ChatBoostSource.GIFT_CODE or source.user is None:
            raise Error("ChatBoostSourceGiftCode requires a gift-code source and user")
        return ChatBoostSourceGiftCode(source.user.value(), api_kwargs=source.api_kwargs.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostSourceGiftCode]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostSourceGiftCode]()
        for item in items:
            result.append(ChatBoostSourceGiftCode.de_json(item.copy()))
        return result^


struct ChatBoostSourceGiveaway(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A chat boost granted by a Telegram giveaway."""

    var giveaway_message_id: Int
    var user: Optional[User]
    var prize_star_count: Optional[Int]
    var is_unclaimed: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        giveaway_message_id: Int,
        user: Optional[User] = None,
        is_unclaimed: Optional[Bool] = None,
        prize_star_count: Optional[Int] = None,
    ):
        self.giveaway_message_id = giveaway_message_id
        self.user = user.copy()
        self.prize_star_count = prize_star_count.copy()
        self.is_unclaimed = is_unclaimed.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        giveaway_message_id: Int,
        user: Optional[User] = None,
        is_unclaimed: Optional[Bool] = None,
        prize_star_count: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.giveaway_message_id = giveaway_message_id
        self.user = user.copy()
        self.prize_star_count = prize_star_count.copy()
        self.is_unclaimed = is_unclaimed.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.giveaway_message_id = existing.giveaway_message_id
        self.user = existing.user.copy()
        self.prize_star_count = existing.prize_star_count.copy()
        self.is_unclaimed = existing.is_unclaimed.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("giveaway").as_bytes())

    def to_source(self) -> ChatBoostSource:
        return ChatBoostSource(
            ChatBoostSource.GIVEAWAY,
            self.user.copy(),
            Optional[Int](self.giveaway_message_id),
            self.prize_star_count.copy(),
            self.is_unclaimed.copy(),
            api_kwargs=self.api_kwargs.copy(),
        )

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.to_source().to_dict(recursive=recursive)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostSourceGiveaway:
        var source = ChatBoostSource.de_json(data)
        if source.source != ChatBoostSource.GIVEAWAY or source.giveaway_message_id is None:
            raise Error("ChatBoostSourceGiveaway requires a giveaway source and message id")
        return ChatBoostSourceGiveaway(
            source.giveaway_message_id.value(),
            source.user.copy(),
            source.is_unclaimed.copy(),
            source.prize_star_count.copy(),
            api_kwargs=source.api_kwargs.copy(),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostSourceGiveaway]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostSourceGiveaway]()
        for item in items:
            result.append(ChatBoostSourceGiveaway.de_json(item.copy()))
        return result^


struct ChatBoost(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A single active chat boost and its native source variant."""

    var boost_id: String
    var add_date: TimestampDateTime
    var expiration_date: TimestampDateTime
    var source: ChatBoostSource
    var api_kwargs: JsonDocument

    def __init__(out self, boost_id: String, add_date: TimestampDateTime, expiration_date: TimestampDateTime, source: ChatBoostSource):
        self.boost_id = boost_id.copy()
        self.add_date = add_date.copy()
        self.expiration_date = expiration_date.copy()
        self.source = source.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, boost_id: String, add_date: TimestampDateTime, expiration_date: TimestampDateTime, source: ChatBoostSource, *, api_kwargs: JsonDocument):
        self.boost_id = boost_id.copy()
        self.add_date = add_date.copy()
        self.expiration_date = expiration_date.copy()
        self.source = source.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.boost_id = existing.boost_id.copy()
        self.add_date = existing.add_date.copy()
        self.expiration_date = existing.expiration_date.copy()
        self.source = existing.source.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.boost_id == other.boost_id and self.add_date == other.add_date and self.expiration_date == other.expiration_date and self.source == other.source

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.boost_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "boost_id", self.boost_id)
        result.set_number(result.root, "add_date", String(to_timestamp(self.add_date)))
        result.set_number(result.root, "expiration_date", String(to_timestamp(self.expiration_date)))
        var source_data = self.source.to_dict(recursive=recursive)
        var source_index = result.copy_subtree_from(source_data, source_data.root)
        result.object_set(result.root, "source", source_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoost:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatBoost JSON value must be an object")
        var id_index = data.object_get(data.root, "boost_id")
        var add_index = data.object_get(data.root, "add_date")
        var expiration_index = data.object_get(data.root, "expiration_date")
        var source_index = data.object_get(data.root, "source")
        if id_index == -1 or add_index == -1 or expiration_index == -1 or source_index == -1:
            raise Error("ChatBoost JSON object is missing required fields")
        var known = List[String]()
        known.append("boost_id")
        known.append("add_date")
        known.append("expiration_date")
        known.append("source")
        return ChatBoost(
            data.string_value(id_index),
            from_timestamp(data.integer_value(add_index)),
            from_timestamp(data.integer_value(expiration_index)),
            ChatBoostSource.de_json(_chatboost_nested(data, source_index)),
            api_kwargs=_chatboost_unknown(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoost]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoost]()
        for item in items:
            result.append(ChatBoost.de_json(item.copy()))
        return result^


struct ChatBoostUpdated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A chat boost was added or changed."""

    var chat: Chat
    var boost: ChatBoost
    var api_kwargs: JsonDocument

    def __init__(out self, chat: Chat, boost: ChatBoost):
        self.chat = chat.copy()
        self.boost = boost.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat: Chat, boost: ChatBoost, *, api_kwargs: JsonDocument):
        self.chat = chat.copy()
        self.boost = boost.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.boost = existing.boost.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.chat.id == other.chat.id and self.boost == other.boost

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.chat.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.boost)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var chat_data = self.chat.to_dict(recursive=recursive)
        var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_index)
        var boost_data = self.boost.to_dict(recursive=recursive)
        var boost_index = result.copy_subtree_from(boost_data, boost_data.root)
        result.object_set(result.root, "boost", boost_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostUpdated:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatBoostUpdated JSON value must be an object")
        var chat_index = data.object_get(data.root, "chat")
        var boost_index = data.object_get(data.root, "boost")
        if chat_index == -1 or boost_index == -1:
            raise Error("ChatBoostUpdated JSON object is missing required fields")
        var known = List[String]()
        known.append("chat")
        known.append("boost")
        return ChatBoostUpdated(
            Chat.de_json(_chatboost_nested(data, chat_index)),
            ChatBoost.de_json(_chatboost_nested(data, boost_index)),
            api_kwargs=_chatboost_unknown(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostUpdated]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostUpdated]()
        for item in items:
            result.append(ChatBoostUpdated.de_json(item.copy()))
        return result^


struct ChatBoostRemoved(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A boost was removed from a chat."""

    var chat: Chat
    var boost_id: String
    var remove_date: TimestampDateTime
    var source: ChatBoostSource
    var api_kwargs: JsonDocument

    def __init__(out self, chat: Chat, boost_id: String, remove_date: TimestampDateTime, source: ChatBoostSource):
        self.chat = chat.copy()
        self.boost_id = boost_id.copy()
        self.remove_date = remove_date.copy()
        self.source = source.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat: Chat, boost_id: String, remove_date: TimestampDateTime, source: ChatBoostSource, *, api_kwargs: JsonDocument):
        self.chat = chat.copy()
        self.boost_id = boost_id.copy()
        self.remove_date = remove_date.copy()
        self.source = source.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.boost_id = existing.boost_id.copy()
        self.remove_date = existing.remove_date.copy()
        self.source = existing.source.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.chat == other.chat and self.boost_id == other.boost_id and self.remove_date == other.remove_date and self.source == other.source

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.boost_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var chat_data = self.chat.to_dict(recursive=recursive)
        var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_index)
        result.set_string(result.root, "boost_id", self.boost_id)
        result.set_number(result.root, "remove_date", String(to_timestamp(self.remove_date)))
        var source_data = self.source.to_dict(recursive=recursive)
        var source_index = result.copy_subtree_from(source_data, source_data.root)
        result.object_set(result.root, "source", source_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatBoostRemoved:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatBoostRemoved JSON value must be an object")
        var chat_index = data.object_get(data.root, "chat")
        var id_index = data.object_get(data.root, "boost_id")
        var date_index = data.object_get(data.root, "remove_date")
        var source_index = data.object_get(data.root, "source")
        if chat_index == -1 or id_index == -1 or date_index == -1 or source_index == -1:
            raise Error("ChatBoostRemoved JSON object is missing required fields")
        var known = List[String]()
        known.append("chat")
        known.append("boost_id")
        known.append("remove_date")
        known.append("source")
        return ChatBoostRemoved(
            Chat.de_json(_chatboost_nested(data, chat_index)),
            data.string_value(id_index),
            from_timestamp(data.integer_value(date_index)),
            ChatBoostSource.de_json(_chatboost_nested(data, source_index)),
            api_kwargs=_chatboost_unknown(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatBoostRemoved]:
        var items = data.array_documents(array_index)
        var result = List[ChatBoostRemoved]()
        for item in items:
            result.append(ChatBoostRemoved.de_json(item.copy()))
        return result^


struct UserChatBoosts(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The boosts added to a chat by one user."""

    var boosts: List[ChatBoost]
    var api_kwargs: JsonDocument

    def __init__(out self, boosts: List[ChatBoost]):
        self.boosts = boosts.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, boosts: List[ChatBoost], *, api_kwargs: JsonDocument):
        self.boosts = boosts.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.boosts = existing.boosts.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if len(self.boosts) != len(other.boosts):
            return False
        for index in range(len(self.boosts)):
            if self.boosts[index] != other.boosts[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        for boost in self.boosts:
            hasher.update(String(hash(boost)).as_bytes())
            hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var array_index = result.add_array()
        for boost in self.boosts:
            var boost_data = boost.to_dict(recursive=recursive)
            var boost_index = result.copy_subtree_from(boost_data, boost_data.root)
            result.append_child(array_index, boost_index)
        result.object_set(result.root, "boosts", array_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> UserChatBoosts:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UserChatBoosts JSON value must be an object")
        var index = data.object_get(data.root, "boosts")
        if index == -1 or data.nodes[index].kind != JSON_ARRAY:
            raise Error("UserChatBoosts JSON object is missing boosts array")
        var boosts = ChatBoost.de_list(data, index)
        var known = List[String]()
        known.append("boosts")
        return UserChatBoosts(boosts, api_kwargs=_chatboost_unknown(data, known))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[UserChatBoosts]:
        var items = data.array_documents(array_index)
        var result = List[UserChatBoosts]()
        for item in items:
            result.append(UserChatBoosts.de_json(item.copy()))
        return result^
