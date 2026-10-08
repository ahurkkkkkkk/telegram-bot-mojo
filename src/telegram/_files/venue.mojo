#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 Venue.
# LGPL-3.0-or-later; see LICENSE.

"""A venue with a map location and optional provider identifiers."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.location import Location
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Venue(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A venue; equality uses its Location and title."""

    var location: Location
    var title: String
    var address: String
    var foursquare_id: Optional[String]
    var foursquare_type: Optional[String]
    var google_place_id: Optional[String]
    var google_place_type: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        location: Location,
        title: String,
        address: String,
        foursquare_id: Optional[String] = None,
        foursquare_type: Optional[String] = None,
        google_place_id: Optional[String] = None,
        google_place_type: Optional[String] = None,
    ):
        self.location = location.copy()
        self.title = title.copy()
        self.address = address.copy()
        self.foursquare_id = foursquare_id
        self.foursquare_type = foursquare_type
        self.google_place_id = google_place_id
        self.google_place_type = google_place_type
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        location: Location,
        title: String,
        address: String,
        foursquare_id: Optional[String] = None,
        foursquare_type: Optional[String] = None,
        google_place_id: Optional[String] = None,
        google_place_type: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.location = location.copy()
        self.title = title.copy()
        self.address = address.copy()
        self.foursquare_id = foursquare_id
        self.foursquare_type = foursquare_type
        self.google_place_id = google_place_id
        self.google_place_type = google_place_type
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.location = existing.location.copy()
        self.title = existing.title.copy()
        self.address = existing.address.copy()
        self.foursquare_id = existing.foursquare_id
        self.foursquare_type = existing.foursquare_type
        self.google_place_id = existing.google_place_id
        self.google_place_type = existing.google_place_type
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.location.longitude == other.location.longitude
            and self.location.latitude == other.location.latitude
            and self.title == other.title
        )

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
        hasher.update(String("\0").as_bytes())
        hasher.update(self.title.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "address", self.address)
        if self.foursquare_id is not None:
            result.set_string(result.root, "foursquare_id", self.foursquare_id.value())
        if self.foursquare_type is not None:
            result.set_string(result.root, "foursquare_type", self.foursquare_type.value())
        if self.google_place_id is not None:
            result.set_string(result.root, "google_place_id", self.google_place_id.value())
        if self.google_place_type is not None:
            result.set_string(result.root, "google_place_type", self.google_place_type.value())
        var location_document = self.location.to_dict(recursive=recursive)
        var location_node = result.copy_subtree_from(location_document, location_document.root)
        result.object_set(result.root, "location", location_node)
        result.set_string(result.root, "title", self.title)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Venue JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Venue JSON value is not an object")
        var location_index = data.object_get(data.root, "location")
        var title_index = data.object_get(data.root, "title")
        var address_index = data.object_get(data.root, "address")
        if location_index == -1 or title_index == -1 or address_index == -1:
            raise Error("Venue JSON object is missing a required field")
        var location_document = JsonDocument()
        location_document.root = location_document.copy_subtree_from(data, location_index)
        var location = Location.de_json(location_document)
        var title = data.string_value(title_index)
        var address = data.string_value(address_index)

        var foursquare_id: Optional[String] = None
        var foursquare_id_index = data.object_get(data.root, "foursquare_id")
        if foursquare_id_index != -1 and not data.is_null(foursquare_id_index):
            foursquare_id = Optional[String](data.string_value(foursquare_id_index))
        var foursquare_type: Optional[String] = None
        var foursquare_type_index = data.object_get(data.root, "foursquare_type")
        if foursquare_type_index != -1 and not data.is_null(foursquare_type_index):
            foursquare_type = Optional[String](data.string_value(foursquare_type_index))
        var google_place_id: Optional[String] = None
        var google_place_id_index = data.object_get(data.root, "google_place_id")
        if google_place_id_index != -1 and not data.is_null(google_place_id_index):
            google_place_id = Optional[String](data.string_value(google_place_id_index))
        var google_place_type: Optional[String] = None
        var google_place_type_index = data.object_get(data.root, "google_place_type")
        if google_place_type_index != -1 and not data.is_null(google_place_type_index):
            google_place_type = Optional[String](data.string_value(google_place_type_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "location"
                and key != "title"
                and key != "address"
                and key != "foursquare_id"
                and key != "foursquare_type"
                and key != "google_place_id"
                and key != "google_place_type"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Venue(
            location,
            title,
            address,
            foursquare_id,
            foursquare_type,
            google_place_id,
            google_place_type,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Venue.de_json(items[index].copy()))
        return result^
