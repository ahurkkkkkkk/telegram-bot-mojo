#!/usr/bin/env mojo
#
# Native command-scope model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native value forms for Telegram bot-command scopes."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher
from std.collections.optional import Optional

from telegram import constants
from telegram._utils.json import JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _scope_api_kwargs(data: JsonDocument) raises -> JsonDocument:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("BotCommandScope JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("BotCommandScope JSON value is not an object")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        if data.nodes[child].name != "type":
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, data.nodes[child].name.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _scope_to_dict(scope_type: String, api_kwargs: JsonDocument) raises -> JsonDocument:
    var result = empty_json_object()
    result.set_string(result.root, "type", scope_type)
    result.merge_object(result.root, api_kwargs.copy(), api_kwargs.root)
    return result^


def _scope_api_kwargs_except(
    data: JsonDocument, first: String, second: String, third: String = String()
) raises -> JsonDocument:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("BotCommandScope JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("BotCommandScope JSON value is not an object")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if key != first and key != second and key != third:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _parse_chat_id(value: String) raises -> Int:
    if value.byte_length() == 0:
        raise Error("chat_id must be a username or integer")
    var bytes = value.as_bytes()
    var begin = 0
    var end = len(bytes)
    while begin < end and _is_ascii_whitespace(bytes[begin]):
        begin += 1
    while end > begin and _is_ascii_whitespace(bytes[end - 1]):
        end -= 1
    var position = begin
    var sign = 1
    if position < end and bytes[position] == 0x2D:
        sign = -1
        position = 1
        position += begin
    elif position < end and bytes[position] == 0x2B:
        position = 1
        position += begin
    if position == end:
        raise Error("chat_id string is not an integer")
    var result = 0
    var previous_was_digit = False
    while position < end:
        var byte = bytes[position]
        if byte == 0x5F:
            if not previous_was_digit or position + 1 >= end:
                raise Error("chat_id string is not an integer")
            var next_byte = bytes[position + 1]
            if next_byte < 0x30 or next_byte > 0x39:
                raise Error("chat_id string is not an integer")
            previous_was_digit = False
            position += 1
            continue
        if byte < 0x30 or byte > 0x39:
            raise Error("chat_id string is not an integer")
        result = result * 10 + Int(byte - 0x30)
        previous_was_digit = True
        position += 1
    if not previous_was_digit:
        raise Error("chat_id string is not an integer")
    return result * sign


def _is_ascii_whitespace(byte: UInt8) -> Bool:
    return byte == 0x20 or (byte >= 0x09 and byte <= 0x0D)


struct ChatIdentifier(Equatable, Hashable, Copyable):
    """A numeric Telegram chat ID or public @username."""

    var number: Int
    var username: String

    def __init__(out self, number: Int):
        self.number = number
        self.username = String()

    def __init__(out self, username_or_id: String) raises:
        if username_or_id.byte_length() != 0 and username_or_id[byte=0] == "@":
            self.number = 0
            self.username = username_or_id
        else:
            self.number = _parse_chat_id(username_or_id)
            self.username = String()

    def __copyinit__(out self, existing: Self):
        self.number = existing.number
        self.username = existing.username.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.number == other.number and self.username == other.username

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.username.byte_length() != 0:
            hasher.update(String("username\0").as_bytes())
            hasher.update(self.username.as_bytes())
        else:
            hasher.update(String("number\0").as_bytes())
            var text = String(self.number)
            hasher.update(text.as_bytes())

    @staticmethod
    def from_json(data: JsonDocument, index: Int) raises -> Self:
        if index < 0 or index >= len(data.nodes):
            raise Error("chat_id JSON node index is out of range")
        if data.nodes[index].kind == JSON_STRING:
            return ChatIdentifier(data.string_value(index))
        return ChatIdentifier(data.integer_value(index))


def _chat_scope_to_dict(
    scope_type: String,
    chat_id: ChatIdentifier,
    api_kwargs: JsonDocument,
    user_id: Optional[Int] = None,
) raises -> JsonDocument:
    var result = empty_json_object()
    result.set_string(result.root, "type", scope_type)
    if chat_id.username.byte_length() != 0:
        result.set_string(result.root, "chat_id", chat_id.username)
    else:
        result.set_number(result.root, "chat_id", String(chat_id.number))
    if user_id is not None:
        result.set_number(result.root, "user_id", String(user_id.value()))
    result.merge_object(result.root, api_kwargs.copy(), api_kwargs.root)
    return result^


struct BotCommandScope(Equatable, Hashable, Copyable):
    """The type discriminator of a Telegram bot-command scope."""

    var type: String
    var api_kwargs: JsonDocument

    comptime DEFAULT = constants.BotCommandScopeType.DEFAULT.value
    comptime ALL_PRIVATE_CHATS = constants.BotCommandScopeType.ALL_PRIVATE_CHATS.value
    comptime ALL_GROUP_CHATS = constants.BotCommandScopeType.ALL_GROUP_CHATS.value
    comptime ALL_CHAT_ADMINISTRATORS = constants.BotCommandScopeType.ALL_CHAT_ADMINISTRATORS.value
    comptime CHAT = constants.BotCommandScopeType.CHAT.value
    comptime CHAT_ADMINISTRATORS = constants.BotCommandScopeType.CHAT_ADMINISTRATORS.value
    comptime CHAT_MEMBER = constants.BotCommandScopeType.CHAT_MEMBER.value

    def __init__(out self, type: String):
        self.type = type
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: String, *, api_kwargs: JsonDocument):
        self.type = type
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _scope_to_dict(self.type, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BotCommandScope JSON document has no root")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1:
            raise Error("BotCommandScope JSON object is missing type")
        var scope_type = data.string_value(type_index)
        var api_kwargs = _scope_api_kwargs(data)
        return BotCommandScope(scope_type, api_kwargs=api_kwargs)


struct BotCommandScopeDefault(Equatable, Hashable, Copyable):
    """The default command scope."""

    var type: String
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.DEFAULT

    def __init__(out self):
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _scope_to_dict(self.type, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return BotCommandScopeDefault(api_kwargs=_scope_api_kwargs(data))


struct BotCommandScopeAllPrivateChats(Equatable, Hashable, Copyable):
    """The command scope covering every private chat."""

    var type: String
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.ALL_PRIVATE_CHATS

    def __init__(out self):
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _scope_to_dict(self.type, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return BotCommandScopeAllPrivateChats(api_kwargs=_scope_api_kwargs(data))


struct BotCommandScopeAllGroupChats(Equatable, Hashable, Copyable):
    """The command scope covering every group and supergroup chat."""

    var type: String
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.ALL_GROUP_CHATS

    def __init__(out self):
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _scope_to_dict(self.type, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return BotCommandScopeAllGroupChats(api_kwargs=_scope_api_kwargs(data))


struct BotCommandScopeAllChatAdministrators(Equatable, Hashable, Copyable):
    """The command scope covering administrators of all group chats."""

    var type: String
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.ALL_CHAT_ADMINISTRATORS

    def __init__(out self):
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _scope_to_dict(self.type, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return BotCommandScopeAllChatAdministrators(api_kwargs=_scope_api_kwargs(data))


struct BotCommandScopeChat(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The command scope for one chat, identified by ID or @username."""

    var chat_id: ChatIdentifier
    var type: String
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.CHAT

    def __init__(out self, chat_id: Int):
        self.chat_id = ChatIdentifier(chat_id)
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: String) raises:
        self.chat_id = ChatIdentifier(chat_id)
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: ChatIdentifier):
        self.chat_id = chat_id.copy()
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: ChatIdentifier, *, api_kwargs: JsonDocument):
        self.chat_id = chat_id.copy()
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat_id = existing.chat_id.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.chat_id == other.chat_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.type, "\0").as_bytes())
        if self.chat_id.username.byte_length() != 0:
            hasher.update(String("username\0", self.chat_id.username).as_bytes())
        else:
            hasher.update(String("number\0", self.chat_id.number).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _chat_scope_to_dict(self.type, self.chat_id, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BotCommandScopeChat JSON value is not an object")
        var chat_id_index = data.object_get(data.root, "chat_id")
        if chat_id_index == -1:
            raise Error("BotCommandScopeChat JSON object is missing chat_id")
        var chat_id = ChatIdentifier.from_json(data, chat_id_index)
        var api_kwargs = _scope_api_kwargs_except(data, "type", "chat_id")
        return BotCommandScopeChat(chat_id, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotCommandScopeChat.de_json(items[index].copy()))
        return result^


struct BotCommandScopeChatAdministrators(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The command scope for administrators of one chat."""

    var chat_id: ChatIdentifier
    var type: String
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.CHAT_ADMINISTRATORS

    def __init__(out self, chat_id: Int):
        self.chat_id = ChatIdentifier(chat_id)
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: String) raises:
        self.chat_id = ChatIdentifier(chat_id)
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: ChatIdentifier):
        self.chat_id = chat_id.copy()
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: ChatIdentifier, *, api_kwargs: JsonDocument):
        self.chat_id = chat_id.copy()
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat_id = existing.chat_id.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.chat_id == other.chat_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.type, "\0").as_bytes())
        if self.chat_id.username.byte_length() != 0:
            hasher.update(String("username\0", self.chat_id.username).as_bytes())
        else:
            hasher.update(String("number\0", self.chat_id.number).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _chat_scope_to_dict(self.type, self.chat_id, self.api_kwargs)

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BotCommandScopeChatAdministrators JSON value is not an object")
        var chat_id_index = data.object_get(data.root, "chat_id")
        if chat_id_index == -1:
            raise Error("BotCommandScopeChatAdministrators JSON object is missing chat_id")
        var chat_id = ChatIdentifier.from_json(data, chat_id_index)
        var api_kwargs = _scope_api_kwargs_except(data, "type", "chat_id")
        return BotCommandScopeChatAdministrators(chat_id, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotCommandScopeChatAdministrators.de_json(items[index].copy()))
        return result^


struct BotCommandScopeChatMember(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The command scope for one member of a chat."""

    var chat_id: ChatIdentifier
    var type: String
    var user_id: Int
    var api_kwargs: JsonDocument
    comptime TYPE = BotCommandScope.CHAT_MEMBER

    def __init__(out self, chat_id: Int, user_id: Int):
        self.chat_id = ChatIdentifier(chat_id)
        self.type = Self.TYPE
        self.user_id = user_id
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: String, user_id: Int) raises:
        self.chat_id = ChatIdentifier(chat_id)
        self.type = Self.TYPE
        self.user_id = user_id
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: ChatIdentifier, user_id: Int):
        self.chat_id = chat_id.copy()
        self.type = Self.TYPE
        self.user_id = user_id
        self.api_kwargs = empty_json_object()

    def __init__(out self, chat_id: ChatIdentifier, user_id: Int, *, api_kwargs: JsonDocument):
        self.chat_id = chat_id.copy()
        self.type = Self.TYPE
        self.user_id = user_id
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat_id = existing.chat_id.copy()
        self.type = existing.type.copy()
        self.user_id = existing.user_id
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.chat_id == other.chat_id and self.user_id == other.user_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.type, "\0").as_bytes())
        if self.chat_id.username.byte_length() != 0:
            hasher.update(String("username\0", self.chat_id.username, "\0").as_bytes())
        else:
            hasher.update(String("number\0", self.chat_id.number, "\0").as_bytes())
        hasher.update(String(self.user_id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return _chat_scope_to_dict(
            self.type, self.chat_id, self.api_kwargs, Optional[Int](self.user_id)
        )

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BotCommandScopeChatMember JSON value is not an object")
        var chat_id_index = data.object_get(data.root, "chat_id")
        var user_id_index = data.object_get(data.root, "user_id")
        if chat_id_index == -1 or user_id_index == -1:
            raise Error("BotCommandScopeChatMember JSON object is missing a required field")
        var chat_id = ChatIdentifier.from_json(data, chat_id_index)
        var user_id = data.integer_value(user_id_index)
        var api_kwargs = _scope_api_kwargs_except(data, "type", "chat_id", "user_id")
        return BotCommandScopeChatMember(chat_id, user_id, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotCommandScopeChatMember.de_json(items[index].copy()))
        return result^
