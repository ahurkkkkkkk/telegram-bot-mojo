#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 _videochat.py.
# LGPL-3.0-or-later; see LICENSE.

"""Service-message values describing Telegram video chats."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimeDelta, TimestampDateTime, from_timestamp, to_timestamp, to_timedelta
from telegram._utils.json import JSON_ARRAY, JSON_NUMBER, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _videochat_api_kwargs(data: JsonDocument, known: String) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if key != known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct VideoChatStarted(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A video chat has started; this service message has no data fields."""

    var api_kwargs: JsonDocument

    def __init__(out self):
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("VideoChatStarted").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("VideoChatStarted JSON value must be an object")
        return Self(api_kwargs=data.copy())

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


struct VideoChatEnded(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A video chat ended, with a native duration value."""

    var duration: TimeDelta
    var api_kwargs: JsonDocument

    def __init__(out self, duration: Int):
        self.duration = to_timedelta(duration)
        self.api_kwargs = empty_json_object()

    def __init__(out self, duration: TimeDelta):
        self.duration = duration.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, duration: Int, *, api_kwargs: JsonDocument):
        self.duration = to_timedelta(duration)
        self.api_kwargs = api_kwargs.copy()

    def __init__(out self, duration: TimeDelta, *, api_kwargs: JsonDocument):
        self.duration = duration.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.duration = existing.duration.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.duration == other.duration

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(hash(self.duration)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "duration", self.duration.seconds_json_number())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("VideoChatEnded JSON value must be an object")
        var duration_index = data.object_get(data.root, "duration")
        if duration_index == -1 or data.nodes[duration_index].kind != JSON_NUMBER:
            raise Error("VideoChatEnded JSON object is missing numeric duration")
        var duration = to_timedelta(atof(data.number_text(duration_index)))
        return Self(duration, api_kwargs=_videochat_api_kwargs(data, "duration"))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


struct VideoChatParticipantsInvited(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Users newly invited to a video chat."""

    var users: List[User]
    var api_kwargs: JsonDocument

    def __init__(out self, users: List[User]):
        self.users = users.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, users: List[User], *, api_kwargs: JsonDocument):
        self.users = users.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.users = existing.users.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.users == other.users

    def __hash__[H: Hasher](self, mut hasher: H):
        for user in self.users:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(user.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if len(self.users) > 0:
            var array = result.add_array()
            result.object_set(result.root, "users", array)
            for user in self.users:
                var item = user.to_dict(recursive)
                var child = result.copy_subtree_from(item, item.root)
                result.append_child(array, child)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("VideoChatParticipantsInvited JSON value must be an object")
        var users = List[User]()
        var users_index = data.object_get(data.root, "users")
        if users_index != -1 and not data.is_null(users_index):
            if data.nodes[users_index].kind != JSON_ARRAY:
                raise Error("VideoChatParticipantsInvited users must be an array")
            var items = data.array_documents(users_index)
            for item in items:
                users.append(User.de_json(item))
        return Self(users, api_kwargs=_videochat_api_kwargs(data, "users"))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


struct VideoChatScheduled(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A video chat scheduled for a specific instant."""

    var start_date: TimestampDateTime
    var api_kwargs: JsonDocument

    def __init__(out self, start_date: TimestampDateTime):
        self.start_date = start_date.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, start_date: TimestampDateTime, *, api_kwargs: JsonDocument):
        self.start_date = start_date.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.start_date = existing.start_date.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.start_date == other.start_date

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(hash(self.start_date)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "start_date", String(to_timestamp(self.start_date)))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("VideoChatScheduled JSON value must be an object")
        var date_index = data.object_get(data.root, "start_date")
        if date_index == -1:
            raise Error("VideoChatScheduled JSON object is missing start_date")
        var date = from_timestamp(data.integer_value(date_index))
        return Self(date, api_kwargs=_videochat_api_kwargs(data, "start_date"))

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^
