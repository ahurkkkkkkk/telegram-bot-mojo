#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InputLocationMessageContent.
# LGPL-3.0-or-later; see LICENSE.

"""Inline-query content that sends a point or live location."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct InputLocationMessageContent(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A location result; equality uses its latitude and longitude."""

    var latitude: Float64
    var longitude: Float64
    var live_period: Optional[TimeDelta]
    var horizontal_accuracy: Optional[Float64]
    var heading: Optional[Int]
    var proximity_alert_radius: Optional[Int]
    var api_kwargs: JsonDocument

    comptime HORIZONTAL_ACCURACY = constants.LocationLimit.HORIZONTAL_ACCURACY.value
    comptime MIN_HEADING = constants.LocationLimit.MIN_HEADING.value
    comptime MAX_HEADING = constants.LocationLimit.MAX_HEADING.value
    comptime MIN_LIVE_PERIOD = constants.LocationLimit.MIN_LIVE_PERIOD.value
    comptime MAX_LIVE_PERIOD = constants.LocationLimit.MAX_LIVE_PERIOD.value
    comptime MIN_PROXIMITY_ALERT_RADIUS = constants.LocationLimit.MIN_PROXIMITY_ALERT_RADIUS.value
    comptime MAX_PROXIMITY_ALERT_RADIUS = constants.LocationLimit.MAX_PROXIMITY_ALERT_RADIUS.value

    def __init__(
        out self,
        latitude: Float64,
        longitude: Float64,
        live_period: Optional[TimeDelta] = None,
        horizontal_accuracy: Optional[Float64] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
    ):
        self.latitude = latitude
        self.longitude = longitude
        self.live_period = live_period.copy()
        self.horizontal_accuracy = horizontal_accuracy
        self.heading = heading
        self.proximity_alert_radius = None
        if proximity_alert_radius is not None and proximity_alert_radius.value() != 0:
            self.proximity_alert_radius = proximity_alert_radius
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        latitude: Float64,
        longitude: Float64,
        live_period: Optional[TimeDelta] = None,
        horizontal_accuracy: Optional[Float64] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.latitude = latitude
        self.longitude = longitude
        self.live_period = live_period.copy()
        self.horizontal_accuracy = horizontal_accuracy
        self.heading = heading
        self.proximity_alert_radius = None
        if proximity_alert_radius is not None and proximity_alert_radius.value() != 0:
            self.proximity_alert_radius = proximity_alert_radius
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.latitude = existing.latitude
        self.longitude = existing.longitude
        self.live_period = existing.live_period.copy()
        self.horizontal_accuracy = existing.horizontal_accuracy
        self.heading = existing.heading
        self.proximity_alert_radius = existing.proximity_alert_radius
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.latitude == other.latitude and self.longitude == other.longitude

    def __hash__[H: Hasher](self, mut hasher: H):
        var latitude_hash_text = String(self.latitude)
        if self.latitude == 0.0:
            latitude_hash_text = String("0")
        hasher.update(latitude_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var longitude_hash_text = String(self.longitude)
        if self.longitude == 0.0:
            longitude_hash_text = String("0")
        hasher.update(longitude_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.heading is not None:
            result.set_number(result.root, "heading", String(self.heading.value()))
        if self.horizontal_accuracy is not None:
            result.set_number(
                result.root, "horizontal_accuracy", String(self.horizontal_accuracy.value())
            )
        result.set_number(result.root, "latitude", String(self.latitude))
        if self.live_period is not None:
            result.set_number(
                result.root,
                "live_period",
                self.live_period.value().seconds_json_number(),
            )
        result.set_number(result.root, "longitude", String(self.longitude))
        if self.proximity_alert_radius is not None:
            result.set_number(
                result.root,
                "proximity_alert_radius",
                String(self.proximity_alert_radius.value()),
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("InputLocationMessageContent JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InputLocationMessageContent JSON value is not an object")
        var latitude_index = data.object_get(data.root, "latitude")
        var longitude_index = data.object_get(data.root, "longitude")
        if latitude_index == -1 or longitude_index == -1:
            raise Error("InputLocationMessageContent JSON object is missing coordinates")
        var latitude = atof(data.number_text(latitude_index))
        var longitude = atof(data.number_text(longitude_index))

        var live_period: Optional[TimeDelta] = None
        var live_period_index = data.object_get(data.root, "live_period")
        if live_period_index != -1 and not data.is_null(live_period_index):
            live_period = Optional[TimeDelta](to_timedelta(atof(data.number_text(live_period_index))))
        var horizontal_accuracy: Optional[Float64] = None
        var horizontal_accuracy_index = data.object_get(data.root, "horizontal_accuracy")
        if horizontal_accuracy_index != -1 and not data.is_null(horizontal_accuracy_index):
            horizontal_accuracy = Optional[Float64](atof(data.number_text(horizontal_accuracy_index)))
        var heading: Optional[Int] = None
        var heading_index = data.object_get(data.root, "heading")
        if heading_index != -1 and not data.is_null(heading_index):
            heading = Optional[Int](data.integer_value(heading_index))
        var proximity_alert_radius: Optional[Int] = None
        var proximity_alert_radius_index = data.object_get(data.root, "proximity_alert_radius")
        if proximity_alert_radius_index != -1 and not data.is_null(proximity_alert_radius_index):
            proximity_alert_radius = Optional[Int](data.integer_value(proximity_alert_radius_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "latitude"
                and key != "longitude"
                and key != "live_period"
                and key != "horizontal_accuracy"
                and key != "heading"
                and key != "proximity_alert_radius"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return InputLocationMessageContent(
            latitude,
            longitude,
            live_period,
            horizontal_accuracy,
            heading,
            proximity_alert_radius,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InputLocationMessageContent.de_json(items[index].copy()))
        return result^
