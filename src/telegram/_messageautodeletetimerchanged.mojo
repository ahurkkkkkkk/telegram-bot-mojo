#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 MessageAutoDeleteTimerChanged.
# LGPL-3.0-or-later; see LICENSE.

"""A service message indicating that a chat's auto-delete timer changed."""

from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct MessageAutoDeleteTimerChanged(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The new auto-delete interval, stored with microsecond precision."""

    var message_auto_delete_time: TimeDelta
    var api_kwargs: JsonDocument

    def __init__(out self, message_auto_delete_time: TimeDelta):
        self.message_auto_delete_time = message_auto_delete_time.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, seconds: Int):
        self.message_auto_delete_time = TimeDelta(seconds)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        message_auto_delete_time: TimeDelta,
        *,
        api_kwargs: JsonDocument,
    ):
        self.message_auto_delete_time = message_auto_delete_time.copy()
        self.api_kwargs = api_kwargs.copy()

    def __init__(out self, seconds: Int, *, api_kwargs: JsonDocument):
        self.message_auto_delete_time = TimeDelta(seconds)
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.message_auto_delete_time = existing.message_auto_delete_time.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.message_auto_delete_time == other.message_auto_delete_time

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.message_auto_delete_time.days).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.message_auto_delete_time.seconds).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.message_auto_delete_time.microseconds).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(
            result.root,
            "message_auto_delete_time",
            self.message_auto_delete_time.seconds_json_number(),
        )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("MessageAutoDeleteTimerChanged JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MessageAutoDeleteTimerChanged JSON value is not an object")
        var time_index = data.object_get(data.root, "message_auto_delete_time")
        if time_index == -1:
            raise Error("MessageAutoDeleteTimerChanged JSON object is missing its timer")
        var time = to_timedelta(atof(data.number_text(time_index)))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "message_auto_delete_time":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return MessageAutoDeleteTimerChanged(time, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MessageAutoDeleteTimerChanged.de_json(items[index].copy()))
        return result^
