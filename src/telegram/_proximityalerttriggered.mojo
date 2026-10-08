#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ProximityAlertTriggered.
# LGPL-3.0-or-later; see LICENSE.

"""A service-message value describing a triggered proximity alert."""

from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ProximityAlertTriggered(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The users involved in a proximity alert and their separation distance."""

    var traveler: User
    var watcher: User
    var distance: Int
    var api_kwargs: JsonDocument

    def __init__(out self, traveler: User, watcher: User, distance: Int):
        self.traveler = traveler.copy()
        self.watcher = watcher.copy()
        self.distance = distance
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        traveler: User,
        watcher: User,
        distance: Int,
        *,
        api_kwargs: JsonDocument,
    ):
        self.traveler = traveler.copy()
        self.watcher = watcher.copy()
        self.distance = distance
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.traveler = existing.traveler.copy()
        self.watcher = existing.watcher.copy()
        self.distance = existing.distance
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.traveler == other.traveler
            and self.watcher == other.watcher
            and self.distance == other.distance
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.traveler.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.watcher.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.distance).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var traveler = self.traveler.to_dict(recursive=recursive)
        var traveler_node = result.copy_subtree_from(traveler, traveler.root)
        result.object_set(result.root, "traveler", traveler_node)
        var watcher = self.watcher.to_dict(recursive=recursive)
        var watcher_node = result.copy_subtree_from(watcher, watcher.root)
        result.object_set(result.root, "watcher", watcher_node)
        result.set_number(result.root, "distance", String(self.distance))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ProximityAlertTriggered JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ProximityAlertTriggered JSON value is not an object")
        var traveler_index = data.object_get(data.root, "traveler")
        var watcher_index = data.object_get(data.root, "watcher")
        var distance_index = data.object_get(data.root, "distance")
        if traveler_index == -1 or watcher_index == -1 or distance_index == -1:
            raise Error("ProximityAlertTriggered JSON object is missing a required field")
        var traveler_document = JsonDocument()
        traveler_document.root = traveler_document.copy_subtree_from(data, traveler_index)
        var traveler = User.de_json(traveler_document)
        var watcher_document = JsonDocument()
        watcher_document.root = watcher_document.copy_subtree_from(data, watcher_index)
        var watcher = User.de_json(watcher_document)
        var distance = data.integer_value(distance_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "traveler" and key != "watcher" and key != "distance":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ProximityAlertTriggered(traveler, watcher, distance, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ProximityAlertTriggered.de_json(items[index].copy()))
        return result^
