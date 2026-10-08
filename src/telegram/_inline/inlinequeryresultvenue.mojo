#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResultVenue.
# LGPL-3.0-or-later; see LICENSE.

"""A venue result returned by an inline query."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType


def _inline_venue_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _inline_venue_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


struct InlineQueryResultVenue(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Venue result; identity is the inherited inline-result id."""

    var type: String
    var id: String
    var latitude: Float64
    var longitude: Float64
    var title: String
    var address: String
    var foursquare_id: Optional[String]
    var foursquare_type: Optional[String]
    var google_place_id: Optional[String]
    var google_place_type: Optional[String]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var thumbnail_url: Optional[String]
    var thumbnail_width: Optional[Int]
    var thumbnail_height: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        latitude: Float64,
        longitude: Float64,
        title: String,
        address: String,
        foursquare_id: Optional[String] = None,
        foursquare_type: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        google_place_id: Optional[String] = None,
        google_place_type: Optional[String] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
    ):
        self.type = InlineQueryResultType.VENUE.value.copy()
        self.id = id.copy()
        self.latitude = latitude
        self.longitude = longitude
        self.title = title.copy()
        self.address = address.copy()
        self.foursquare_id = foursquare_id.copy()
        self.foursquare_type = foursquare_type.copy()
        self.google_place_id = google_place_id.copy()
        self.google_place_type = google_place_type.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        latitude: Float64,
        longitude: Float64,
        title: String,
        address: String,
        foursquare_id: Optional[String] = None,
        foursquare_type: Optional[String] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        google_place_id: Optional[String] = None,
        google_place_type: Optional[String] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.VENUE.value.copy()
        self.id = id.copy()
        self.latitude = latitude
        self.longitude = longitude
        self.title = title.copy()
        self.address = address.copy()
        self.foursquare_id = foursquare_id.copy()
        self.foursquare_type = foursquare_type.copy()
        self.google_place_id = google_place_id.copy()
        self.google_place_type = google_place_type.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.thumbnail_url = thumbnail_url.copy()
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.latitude = existing.latitude
        self.longitude = existing.longitude
        self.title = existing.title.copy()
        self.address = existing.address.copy()
        self.foursquare_id = existing.foursquare_id.copy()
        self.foursquare_type = existing.foursquare_type.copy()
        self.google_place_id = existing.google_place_id.copy()
        self.google_place_type = existing.google_place_type.copy()
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.thumbnail_url = existing.thumbnail_url.copy()
        self.thumbnail_width = existing.thumbnail_width
        self.thumbnail_height = existing.thumbnail_height
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultVenue\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_number(result.root, "latitude", String(self.latitude))
        result.set_number(result.root, "longitude", String(self.longitude))
        result.set_string(result.root, "title", self.title)
        result.set_string(result.root, "address", self.address)
        if self.foursquare_id is not None:
            result.set_string(result.root, "foursquare_id", self.foursquare_id.value())
        if self.foursquare_type is not None:
            result.set_string(result.root, "foursquare_type", self.foursquare_type.value())
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", index)
        if self.input_message_content is not None:
            var content = self.input_message_content.value().to_dict(recursive)
            var index = result.copy_subtree_from(content, content.root)
            result.object_set(result.root, "input_message_content", index)
        if self.google_place_id is not None:
            result.set_string(result.root, "google_place_id", self.google_place_id.value())
        if self.google_place_type is not None:
            result.set_string(result.root, "google_place_type", self.google_place_type.value())
        if self.thumbnail_url is not None:
            result.set_string(result.root, "thumbnail_url", self.thumbnail_url.value())
        if self.thumbnail_width is not None:
            result.set_number(result.root, "thumbnail_width", String(self.thumbnail_width.value()))
        if self.thumbnail_height is not None:
            result.set_number(result.root, "thumbnail_height", String(self.thumbnail_height.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultVenue JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var latitude_index = data.object_get(data.root, "latitude")
        var longitude_index = data.object_get(data.root, "longitude")
        var title_index = data.object_get(data.root, "title")
        var address_index = data.object_get(data.root, "address")
        if (
            id_index == -1 or latitude_index == -1 or longitude_index == -1 or
            title_index == -1 or address_index == -1
        ):
            raise Error("InlineQueryResultVenue JSON object is missing required fields")

        var markup: Optional[InlineKeyboardMarkup] = None
        var markup_index = data.object_get(data.root, "reply_markup")
        if markup_index != -1 and not data.is_null(markup_index):
            var nested = JsonDocument()
            nested.root = nested.copy_subtree_from(data, markup_index)
            markup = Optional[InlineKeyboardMarkup](InlineKeyboardMarkup.de_json(nested))
        var content: Optional[InputMessageContent] = None
        var content_index = data.object_get(data.root, "input_message_content")
        if content_index != -1 and not data.is_null(content_index):
            var nested = JsonDocument()
            nested.root = nested.copy_subtree_from(data, content_index)
            content = Optional[InputMessageContent](InputMessageContent.de_json(nested))

        var foursquare_id = _inline_venue_optional_string(data, "foursquare_id")
        var foursquare_type = _inline_venue_optional_string(data, "foursquare_type")
        var google_place_id = _inline_venue_optional_string(data, "google_place_id")
        var google_place_type = _inline_venue_optional_string(data, "google_place_type")
        var thumbnail_url = _inline_venue_optional_string(data, "thumbnail_url")
        var thumbnail_width = _inline_venue_optional_int(data, "thumbnail_width")
        var thumbnail_height = _inline_venue_optional_int(data, "thumbnail_height")

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type" and key != "id" and key != "latitude" and key != "longitude" and
                key != "title" and key != "address" and key != "foursquare_id" and
                key != "foursquare_type" and key != "reply_markup" and
                key != "input_message_content" and key != "google_place_id" and
                key != "google_place_type" and key != "thumbnail_url" and
                key != "thumbnail_width" and key != "thumbnail_height"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultVenue(
            data.string_value(id_index), atof(data.number_text(latitude_index)),
            atof(data.number_text(longitude_index)), data.string_value(title_index),
            data.string_value(address_index), foursquare_id, foursquare_type, markup, content,
            google_place_id, google_place_type, thumbnail_url, thumbnail_width, thumbnail_height,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultVenue.de_json(items[index].copy()))
        return result^
