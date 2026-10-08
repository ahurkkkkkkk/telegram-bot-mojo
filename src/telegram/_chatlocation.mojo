#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ChatLocation.
# LGPL-3.0-or-later; see LICENSE.

"""The location and address linked to a Telegram chat."""

from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._files.location import Location
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ChatLocation(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A chat location; equality uses the nested Location value."""

    var location: Location
    var address: String
    var api_kwargs: JsonDocument

    comptime MIN_ADDRESS = constants.LocationLimit.MIN_CHAT_LOCATION_ADDRESS.value
    comptime MAX_ADDRESS = constants.LocationLimit.MAX_CHAT_LOCATION_ADDRESS.value

    def __init__(out self, location: Location, address: String):
        self.location = location.copy()
        self.address = address.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, location: Location, address: String, *, api_kwargs: JsonDocument):
        self.location = location.copy()
        self.address = address.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.location = existing.location.copy()
        self.address = existing.address.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.location == other.location

    def __hash__[H: Hasher](self, mut hasher: H):
        var longitude_hash_text = String(self.location.longitude)
        if self.location.longitude == 0.0:
            longitude_hash_text = String("0")
        hasher.update(longitude_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var latitude_hash_text = String(self.location.latitude)
        if self.location.latitude == 0.0:
            latitude_hash_text = String("0")
        hasher.update(latitude_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var location_document = self.location.to_dict(recursive=recursive)
        var location_node = result.copy_subtree_from(location_document, location_document.root)
        result.object_set(result.root, "location", location_node)
        result.set_string(result.root, "address", self.address)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ChatLocation JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatLocation JSON value is not an object")
        var location_index = data.object_get(data.root, "location")
        var address_index = data.object_get(data.root, "address")
        if location_index == -1 or address_index == -1:
            raise Error("ChatLocation JSON object is missing a required field")
        var location_document = JsonDocument()
        location_document.root = location_document.copy_subtree_from(data, location_index)
        var location = Location.de_json(location_document)
        var address = data.string_value(address_index)

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "location" and key != "address":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatLocation(location, address, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ChatLocation.de_json(items[index].copy()))
        return result^
