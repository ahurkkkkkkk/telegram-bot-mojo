#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResultLocation.
# LGPL-3.0-or-later; see LICENSE.

"""A live or static location returned as an inline query result."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._inline.inputmessagecontent import InputMessageContent
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultType, LocationLimit


def _inline_location_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _inline_location_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _inline_location_optional_float(data: JsonDocument, key: String) raises -> Optional[Float64]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Float64](atof(data.number_text(index)))


struct InlineQueryResultLocation(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Location result; equality is based on the inherited result id."""

    comptime HORIZONTAL_ACCURACY = LocationLimit.HORIZONTAL_ACCURACY.value
    comptime MIN_HEADING = LocationLimit.MIN_HEADING.value
    comptime MAX_HEADING = LocationLimit.MAX_HEADING.value
    comptime MIN_LIVE_PERIOD = LocationLimit.MIN_LIVE_PERIOD.value
    comptime MAX_LIVE_PERIOD = LocationLimit.MAX_LIVE_PERIOD.value
    comptime MIN_PROXIMITY_ALERT_RADIUS = LocationLimit.MIN_PROXIMITY_ALERT_RADIUS.value
    comptime MAX_PROXIMITY_ALERT_RADIUS = LocationLimit.MAX_PROXIMITY_ALERT_RADIUS.value

    var type: String
    var id: String
    var latitude: Float64
    var longitude: Float64
    var title: String
    var live_period: Optional[TimeDelta]
    var reply_markup: Optional[InlineKeyboardMarkup]
    var input_message_content: Optional[InputMessageContent]
    var horizontal_accuracy: Optional[Float64]
    var heading: Optional[Int]
    var proximity_alert_radius: Optional[Int]
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
        live_period: Optional[TimeDelta] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        horizontal_accuracy: Optional[Float64] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
    ):
        self.type = InlineQueryResultType.LOCATION.value.copy()
        self.id = id.copy()
        self.latitude = latitude
        self.longitude = longitude
        self.title = title.copy()
        self.live_period = live_period.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.horizontal_accuracy = horizontal_accuracy
        self.heading = heading
        self.proximity_alert_radius = None
        if proximity_alert_radius is not None and proximity_alert_radius.value() != 0:
            self.proximity_alert_radius = proximity_alert_radius
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
        live_period: Optional[TimeDelta] = None,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        input_message_content: Optional[InputMessageContent] = None,
        horizontal_accuracy: Optional[Float64] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        thumbnail_url: Optional[String] = None,
        thumbnail_width: Optional[Int] = None,
        thumbnail_height: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.LOCATION.value.copy()
        self.id = id.copy()
        self.latitude = latitude
        self.longitude = longitude
        self.title = title.copy()
        self.live_period = live_period.copy()
        self.reply_markup = reply_markup.copy()
        self.input_message_content = input_message_content.copy()
        self.horizontal_accuracy = horizontal_accuracy
        self.heading = heading
        self.proximity_alert_radius = None
        if proximity_alert_radius is not None and proximity_alert_radius.value() != 0:
            self.proximity_alert_radius = proximity_alert_radius
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
        self.live_period = existing.live_period.copy()
        self.reply_markup = existing.reply_markup.copy()
        self.input_message_content = existing.input_message_content.copy()
        self.horizontal_accuracy = existing.horizontal_accuracy
        self.heading = existing.heading
        self.proximity_alert_radius = existing.proximity_alert_radius
        self.thumbnail_url = existing.thumbnail_url.copy()
        self.thumbnail_width = existing.thumbnail_width
        self.thumbnail_height = existing.thumbnail_height
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultLocation\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_number(result.root, "latitude", String(self.latitude))
        result.set_number(result.root, "longitude", String(self.longitude))
        result.set_string(result.root, "title", self.title)
        if self.live_period is not None:
            result.set_number(
                result.root, "live_period", self.live_period.value().seconds_json_number()
            )
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", index)
        if self.input_message_content is not None:
            var content = self.input_message_content.value().to_dict(recursive)
            var index = result.copy_subtree_from(content, content.root)
            result.object_set(result.root, "input_message_content", index)
        if self.horizontal_accuracy is not None:
            result.set_number(
                result.root, "horizontal_accuracy", String(self.horizontal_accuracy.value())
            )
        if self.heading is not None:
            result.set_number(result.root, "heading", String(self.heading.value()))
        if self.proximity_alert_radius is not None:
            result.set_number(
                result.root, "proximity_alert_radius", String(self.proximity_alert_radius.value())
            )
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
            raise Error("InlineQueryResultLocation JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var latitude_index = data.object_get(data.root, "latitude")
        var longitude_index = data.object_get(data.root, "longitude")
        var title_index = data.object_get(data.root, "title")
        if id_index == -1 or latitude_index == -1 or longitude_index == -1 or title_index == -1:
            raise Error("InlineQueryResultLocation JSON object is missing required fields")

        var live_period: Optional[TimeDelta] = None
        var live_period_index = data.object_get(data.root, "live_period")
        if live_period_index != -1 and not data.is_null(live_period_index):
            live_period = Optional[TimeDelta](to_timedelta(atof(data.number_text(live_period_index))))
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

        var horizontal_accuracy = _inline_location_optional_float(data, "horizontal_accuracy")
        var heading = _inline_location_optional_int(data, "heading")
        var proximity_alert_radius = _inline_location_optional_int(data, "proximity_alert_radius")
        var thumbnail_url = _inline_location_optional_string(data, "thumbnail_url")
        var thumbnail_width = _inline_location_optional_int(data, "thumbnail_width")
        var thumbnail_height = _inline_location_optional_int(data, "thumbnail_height")

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "type" and key != "id" and key != "latitude" and key != "longitude" and
                key != "title" and key != "live_period" and key != "reply_markup" and
                key != "input_message_content" and key != "horizontal_accuracy" and
                key != "heading" and key != "proximity_alert_radius" and
                key != "thumbnail_url" and key != "thumbnail_width" and key != "thumbnail_height"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultLocation(
            data.string_value(id_index), atof(data.number_text(latitude_index)),
            atof(data.number_text(longitude_index)), data.string_value(title_index), live_period,
            markup, content, horizontal_accuracy, heading, proximity_alert_radius,
            thumbnail_url, thumbnail_width, thumbnail_height, api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultLocation.de_json(items[index].copy()))
        return result^
