#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _storyarea.py."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._reaction import ReactionType
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct LocationAddress(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream LocationAddress."""

    var country_code: String
    var state: Optional[String]
    var city: Optional[String]
    var street: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, country_code: String, state: Optional[String] = None, city: Optional[String] = None, street: Optional[String] = None):
        self.country_code = country_code
        self.state = state
        self.city = city
        self.street = street
        self.api_kwargs = empty_json_object()

    def __init__(out self, country_code: String, state: Optional[String] = None, city: Optional[String] = None, street: Optional[String] = None, *, api_kwargs: JsonDocument):
        self.country_code = country_code
        self.state = state
        self.city = city
        self.street = street
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.country_code = existing.country_code.copy()
        self.state = existing.state
        self.city = existing.city
        self.street = existing.street
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.country_code == other.country_code and self.state == other.state and self.city == other.city and self.street == other.street

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.country_code.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.state is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.state.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.city is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.city.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.street is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.street.value().as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.city is not None:
            result.set_string(result.root, "city", self.city.value())
        result.set_string(result.root, "country_code", self.country_code)
        if self.state is not None:
            result.set_string(result.root, "state", self.state.value())
        if self.street is not None:
            result.set_string(result.root, "street", self.street.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> LocationAddress:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("LocationAddress JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("LocationAddress JSON value is not an object")
        var parsed_country_code_index = data.object_get(data.root, "country_code")
        if parsed_country_code_index == -1:
            raise Error("LocationAddress JSON object is missing country_code")
        var parsed_country_code = data.string_value(parsed_country_code_index)
        var parsed_state_index = data.object_get(data.root, "state")
        var parsed_state: Optional[String] = None
        if parsed_state_index != -1 and not data.is_null(parsed_state_index):
            parsed_state = Optional[String](data.string_value(parsed_state_index))
        var parsed_city_index = data.object_get(data.root, "city")
        var parsed_city: Optional[String] = None
        if parsed_city_index != -1 and not data.is_null(parsed_city_index):
            parsed_city = Optional[String](data.string_value(parsed_city_index))
        var parsed_street_index = data.object_get(data.root, "street")
        var parsed_street: Optional[String] = None
        if parsed_street_index != -1 and not data.is_null(parsed_street_index):
            parsed_street = Optional[String](data.string_value(parsed_street_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "country_code" and key != "state" and key != "city" and key != "street":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return LocationAddress(parsed_country_code, parsed_state, parsed_city, parsed_street, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[LocationAddress]:
        var items = data.array_documents(array_index)
        var result = List[LocationAddress]()
        for index in range(len(items)):
            result.append(LocationAddress.de_json(items[index].copy()))
        return result^


def _area_require_object(data: JsonDocument, class_name: String) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error(String(class_name, " JSON document has no root"))
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error(String(class_name, " JSON value is not an object"))


def _area_float(data: JsonDocument, index: Int) raises -> Float64:
    return atof(data.number_text(index))


def _area_set_float(mut data: JsonDocument, key: String, value: Float64) raises:
    data.set_number(data.root, key, String(value))


def _area_subdocument(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("StoryArea JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _area_api_kwargs(data: JsonDocument, type: String) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var is_model_field = key == "type"
        if type == "location":
            is_model_field = is_model_field or key == "latitude" or key == "longitude" or key == "address"
        elif type == "suggested_reaction":
            is_model_field = is_model_field or key == "reaction_type" or key == "is_dark" or key == "is_flipped"
        elif type == "link":
            is_model_field = is_model_field or key == "url"
        elif type == "weather":
            is_model_field = is_model_field or key == "temperature" or key == "emoji" or key == "background_color"
        elif type == "unique_gift":
            is_model_field = is_model_field or key == "name"
        if not is_model_field:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct StoryAreaPosition(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Coordinates and dimensions for a clickable story area."""

    var x_percentage: Float64
    var y_percentage: Float64
    var width_percentage: Float64
    var height_percentage: Float64
    var rotation_angle: Float64
    var corner_radius_percentage: Float64
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        x_percentage: Float64,
        y_percentage: Float64,
        width_percentage: Float64,
        height_percentage: Float64,
        rotation_angle: Float64,
        corner_radius_percentage: Float64,
    ):
        self.x_percentage = x_percentage
        self.y_percentage = y_percentage
        self.width_percentage = width_percentage
        self.height_percentage = height_percentage
        self.rotation_angle = rotation_angle
        self.corner_radius_percentage = corner_radius_percentage
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        x_percentage: Float64,
        y_percentage: Float64,
        width_percentage: Float64,
        height_percentage: Float64,
        rotation_angle: Float64,
        corner_radius_percentage: Float64,
        *,
        api_kwargs: JsonDocument,
    ):
        self.x_percentage = x_percentage
        self.y_percentage = y_percentage
        self.width_percentage = width_percentage
        self.height_percentage = height_percentage
        self.rotation_angle = rotation_angle
        self.corner_radius_percentage = corner_radius_percentage
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.x_percentage = existing.x_percentage
        self.y_percentage = existing.y_percentage
        self.width_percentage = existing.width_percentage
        self.height_percentage = existing.height_percentage
        self.rotation_angle = existing.rotation_angle
        self.corner_radius_percentage = existing.corner_radius_percentage
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.x_percentage == other.x_percentage
            and self.y_percentage == other.y_percentage
            and self.width_percentage == other.width_percentage
            and self.height_percentage == other.height_percentage
            and self.rotation_angle == other.rotation_angle
            and self.corner_radius_percentage == other.corner_radius_percentage
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.x_percentage).as_bytes())
        hasher.update(String(self.y_percentage).as_bytes())
        hasher.update(String(self.width_percentage).as_bytes())
        hasher.update(String(self.height_percentage).as_bytes())
        hasher.update(String(self.rotation_angle).as_bytes())
        hasher.update(String(self.corner_radius_percentage).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        _area_set_float(result, "x_percentage", self.x_percentage)
        _area_set_float(result, "y_percentage", self.y_percentage)
        _area_set_float(result, "width_percentage", self.width_percentage)
        _area_set_float(result, "height_percentage", self.height_percentage)
        _area_set_float(result, "rotation_angle", self.rotation_angle)
        _area_set_float(result, "corner_radius_percentage", self.corner_radius_percentage)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _area_require_object(data, "StoryAreaPosition")
        var x = data.object_get(data.root, "x_percentage")
        var y = data.object_get(data.root, "y_percentage")
        var width = data.object_get(data.root, "width_percentage")
        var height = data.object_get(data.root, "height_percentage")
        var rotation = data.object_get(data.root, "rotation_angle")
        var corner = data.object_get(data.root, "corner_radius_percentage")
        if x == -1 or y == -1 or width == -1 or height == -1 or rotation == -1 or corner == -1:
            raise Error("StoryAreaPosition JSON object is missing a required coordinate")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "x_percentage"
                and key != "y_percentage"
                and key != "width_percentage"
                and key != "height_percentage"
                and key != "rotation_angle"
                and key != "corner_radius_percentage"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return StoryAreaPosition(
            _area_float(data, x),
            _area_float(data, y),
            _area_float(data, width),
            _area_float(data, height),
            _area_float(data, rotation),
            _area_float(data, corner),
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct StoryAreaType(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Tagged value for location, reaction, link, weather, and gift story areas."""

    comptime LOCATION = "location"
    comptime SUGGESTED_REACTION = "suggested_reaction"
    comptime LINK = "link"
    comptime WEATHER = "weather"
    comptime UNIQUE_GIFT = "unique_gift"

    var type: String
    var latitude: Float64
    var longitude: Float64
    var address: Optional[LocationAddress]
    var reaction_type: Optional[ReactionType]
    var is_dark: Optional[Bool]
    var is_flipped: Optional[Bool]
    var url: String
    var temperature: Float64
    var emoji: String
    var background_color: Int
    var name: String
    var api_kwargs: JsonDocument

    def __init__(out self, type: String):
        self.type = type.copy()
        self.latitude = 0.0
        self.longitude = 0.0
        self.address = None
        self.reaction_type = None
        self.is_dark = None
        self.is_flipped = None
        self.url = ""
        self.temperature = 0.0
        self.emoji = ""
        self.background_color = 0
        self.name = ""
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: String, *, api_kwargs: JsonDocument):
        self.type = type.copy()
        self.latitude = 0.0
        self.longitude = 0.0
        self.address = None
        self.reaction_type = None
        self.is_dark = None
        self.is_flipped = None
        self.url = ""
        self.temperature = 0.0
        self.emoji = ""
        self.background_color = 0
        self.name = ""
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.latitude = existing.latitude
        self.longitude = existing.longitude
        self.address = existing.address.copy()
        self.reaction_type = existing.reaction_type.copy()
        self.is_dark = existing.is_dark
        self.is_flipped = existing.is_flipped
        self.url = existing.url.copy()
        self.temperature = existing.temperature
        self.emoji = existing.emoji.copy()
        self.background_color = existing.background_color
        self.name = existing.name.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    @staticmethod
    def location(
        latitude: Float64,
        longitude: Float64,
        address: Optional[LocationAddress] = None,
    ) -> Self:
        var result = Self(Self.LOCATION)
        result.latitude = latitude
        result.longitude = longitude
        result.address = address.copy()
        return result^

    @staticmethod
    def suggested_reaction(
        reaction_type: ReactionType,
        is_dark: Optional[Bool] = None,
        is_flipped: Optional[Bool] = None,
    ) -> Self:
        var result = Self(Self.SUGGESTED_REACTION)
        result.reaction_type = Optional[ReactionType](reaction_type.copy())
        result.is_dark = is_dark
        result.is_flipped = is_flipped
        return result^

    @staticmethod
    def link(url: String) -> Self:
        var result = Self(Self.LINK)
        result.url = url.copy()
        return result^

    @staticmethod
    def weather(temperature: Float64, emoji: String, background_color: Int) -> Self:
        var result = Self(Self.WEATHER)
        result.temperature = temperature
        result.emoji = emoji.copy()
        result.background_color = background_color
        return result^

    @staticmethod
    def unique_gift(name: String) -> Self:
        var result = Self(Self.UNIQUE_GIFT)
        result.name = name.copy()
        return result^

    def __eq__(self, other: Self) -> Bool:
        if self.type != other.type:
            return False
        if self.type == Self.LOCATION:
            return self.latitude == other.latitude and self.longitude == other.longitude
        if self.type == Self.SUGGESTED_REACTION:
            return (
                self.reaction_type == other.reaction_type
                and self.is_dark == other.is_dark
                and self.is_flipped == other.is_flipped
            )
        if self.type == Self.LINK:
            return self.url == other.url
        if self.type == Self.WEATHER:
            return (
                self.temperature == other.temperature
                and self.emoji == other.emoji
                and self.background_color == other.background_color
            )
        if self.type == Self.UNIQUE_GIFT:
            return self.name == other.name
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        if self.type == Self.LOCATION:
            hasher.update(String(self.latitude).as_bytes())
            hasher.update(String(self.longitude).as_bytes())
        elif self.type == Self.SUGGESTED_REACTION:
            if self.reaction_type is not None:
                hasher.update(String(hash(self.reaction_type.value())).as_bytes())
            if self.is_dark is not None:
                hasher.update(String(self.is_dark.value()).as_bytes())
            if self.is_flipped is not None:
                hasher.update(String(self.is_flipped.value()).as_bytes())
        elif self.type == Self.LINK:
            hasher.update(self.url.as_bytes())
        elif self.type == Self.WEATHER:
            hasher.update(String(self.temperature).as_bytes())
            hasher.update(self.emoji.as_bytes())
            hasher.update(String(self.background_color).as_bytes())
        elif self.type == Self.UNIQUE_GIFT:
            hasher.update(self.name.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        if self.type == Self.LOCATION:
            _area_set_float(result, "latitude", self.latitude)
            _area_set_float(result, "longitude", self.longitude)
            if self.address is not None:
                var address_document = self.address.value().to_dict(recursive=recursive)
                var address_node = result.copy_subtree_from(address_document, address_document.root)
                result.object_set(result.root, "address", address_node)
        elif self.type == Self.SUGGESTED_REACTION:
            if self.reaction_type is not None:
                var reaction_document = self.reaction_type.value().to_dict(recursive=recursive)
                var reaction_node = result.copy_subtree_from(reaction_document, reaction_document.root)
                result.object_set(result.root, "reaction_type", reaction_node)
            if self.is_dark is not None:
                result.set_boolean(result.root, "is_dark", self.is_dark.value())
            if self.is_flipped is not None:
                result.set_boolean(result.root, "is_flipped", self.is_flipped.value())
        elif self.type == Self.LINK:
            result.set_string(result.root, "url", self.url)
        elif self.type == Self.WEATHER:
            _area_set_float(result, "temperature", self.temperature)
            result.set_string(result.root, "emoji", self.emoji)
            result.set_number(result.root, "background_color", String(self.background_color))
        elif self.type == Self.UNIQUE_GIFT:
            result.set_string(result.root, "name", self.name)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _area_require_object(data, "StoryAreaType")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1 or data.is_null(type_index):
            raise Error("StoryAreaType JSON object is missing type")
        var kind = data.string_value(type_index)
        var result = StoryAreaType(kind, api_kwargs=_area_api_kwargs(data, kind))
        if kind == Self.LOCATION:
            var latitude_index = data.object_get(data.root, "latitude")
            var longitude_index = data.object_get(data.root, "longitude")
            if latitude_index == -1 or longitude_index == -1:
                raise Error("StoryAreaType location is missing latitude or longitude")
            result.latitude = _area_float(data, latitude_index)
            result.longitude = _area_float(data, longitude_index)
            var address_index = data.object_get(data.root, "address")
            if address_index != -1 and not data.is_null(address_index):
                result.address = Optional[LocationAddress](
                    LocationAddress.de_json(_area_subdocument(data, address_index))
                )
        elif kind == Self.SUGGESTED_REACTION:
            var reaction_index = data.object_get(data.root, "reaction_type")
            if reaction_index == -1 or data.is_null(reaction_index):
                raise Error("StoryAreaType suggested reaction is missing reaction_type")
            result.reaction_type = Optional[ReactionType](
                ReactionType.de_json(_area_subdocument(data, reaction_index))
            )
            var dark_index = data.object_get(data.root, "is_dark")
            if dark_index != -1 and not data.is_null(dark_index):
                result.is_dark = Optional[Bool](data.boolean_value(dark_index))
            var flipped_index = data.object_get(data.root, "is_flipped")
            if flipped_index != -1 and not data.is_null(flipped_index):
                result.is_flipped = Optional[Bool](data.boolean_value(flipped_index))
        elif kind == Self.LINK:
            var url_index = data.object_get(data.root, "url")
            if url_index == -1 or data.is_null(url_index):
                raise Error("StoryAreaType link is missing url")
            result.url = data.string_value(url_index)
        elif kind == Self.WEATHER:
            var temperature_index = data.object_get(data.root, "temperature")
            var emoji_index = data.object_get(data.root, "emoji")
            var color_index = data.object_get(data.root, "background_color")
            if temperature_index == -1 or emoji_index == -1 or color_index == -1:
                raise Error("StoryAreaType weather is missing a required field")
            result.temperature = _area_float(data, temperature_index)
            result.emoji = data.string_value(emoji_index)
            result.background_color = data.integer_value(color_index)
        elif kind == Self.UNIQUE_GIFT:
            var name_index = data.object_get(data.root, "name")
            if name_index == -1 or data.is_null(name_index):
                raise Error("StoryAreaType unique gift is missing name")
            result.name = data.string_value(name_index)
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct StoryArea(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A clickable area on a story, composed of position and a typed action."""

    var position: StoryAreaPosition
    var type: StoryAreaType
    var api_kwargs: JsonDocument

    def __init__(out self, position: StoryAreaPosition, type: StoryAreaType):
        self.position = position.copy()
        self.type = type.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        position: StoryAreaPosition,
        type: StoryAreaType,
        *,
        api_kwargs: JsonDocument,
    ):
        self.position = position.copy()
        self.type = type.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.position = existing.position.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.position == other.position and self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(hash(self.position)).as_bytes())
        hasher.update(String(hash(self.type)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var position_document = self.position.to_dict(recursive=recursive)
        var position_node = result.copy_subtree_from(position_document, position_document.root)
        result.object_set(result.root, "position", position_node)
        var type_document = self.type.to_dict(recursive=recursive)
        var type_node = result.copy_subtree_from(type_document, type_document.root)
        result.object_set(result.root, "type", type_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _area_require_object(data, "StoryArea")
        var position_index = data.object_get(data.root, "position")
        var type_index = data.object_get(data.root, "type")
        if position_index == -1 or type_index == -1 or data.is_null(position_index) or data.is_null(type_index):
            raise Error("StoryArea JSON object is missing position or type")
        var position = StoryAreaPosition.de_json(_area_subdocument(data, position_index))
        var area_type = StoryAreaType.de_json(_area_subdocument(data, type_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "position" and key != "type":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return StoryArea(position, area_type, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
