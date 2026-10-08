#!/usr/bin/env mojo
#
# Native chat-background value translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native concrete chat background fill and chat-theme value types."""

from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _background_api_kwargs(
    data: JsonDocument,
    first: String,
    second: String = String(),
    third: String = String(),
    fourth: String = String(),
) raises -> JsonDocument:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("background JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("background JSON value is not an object")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if key != first and key != second and key != third and key != fourth:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _background_type(data: JsonDocument, expected: String) raises:
    var type_index = data.object_get(data.root, "type")
    if type_index == -1 or data.nodes[type_index].kind != JSON_STRING:
        raise Error("background JSON object is missing string type")
    if data.string_value(type_index) != expected:
        raise Error("background JSON type does not match requested value")


def _array_ints_equal(left: List[Int], right: List[Int]) -> Bool:
    if len(left) != len(right):
        return False
    for index in range(len(left)):
        if left[index] != right[index]:
            return False
    return True


struct BackgroundFill(Equatable, Hashable, Copyable):
    """A tagged native value for any Telegram background-fill variant."""

    comptime SOLID = "solid"
    comptime GRADIENT = "gradient"
    comptime FREEFORM_GRADIENT = "freeform_gradient"

    var type: String
    var has_variant: Bool
    var color: Int
    var top_color: Int
    var bottom_color: Int
    var rotation_angle: Int
    var colors: List[Int]
    var api_kwargs: JsonDocument

    def __init__(out self, type: String):
        self.type = type
        self.has_variant = False
        self.color = 0
        self.top_color = 0
        self.bottom_color = 0
        self.rotation_angle = 0
        self.colors = List[Int]()
        self.api_kwargs = empty_json_object()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.has_variant = existing.has_variant
        self.color = existing.color
        self.top_color = existing.top_color
        self.bottom_color = existing.bottom_color
        self.rotation_angle = existing.rotation_angle
        self.colors = existing.colors.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.type != other.type or self.has_variant != other.has_variant:
            return False
        if not self.has_variant:
            return True
        if self.type == Self.SOLID:
            return self.color == other.color
        if self.type == Self.GRADIENT:
            return (
                self.top_color == other.top_color
                and self.bottom_color == other.bottom_color
                and self.rotation_angle == other.rotation_angle
            )
        if self.type == Self.FREEFORM_GRADIENT:
            return _array_ints_equal(self.colors, other.colors)
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        if not self.has_variant:
            return
        if self.type == Self.SOLID:
            hasher.update(String(self.color).as_bytes())
        elif self.type == Self.GRADIENT:
            hasher.update(String(self.top_color).as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(String(self.bottom_color).as_bytes())
            hasher.update(String("\0").as_bytes())
            hasher.update(String(self.rotation_angle).as_bytes())
        elif self.type == Self.FREEFORM_GRADIENT:
            for index in range(len(self.colors)):
                if index != 0:
                    hasher.update(String("\0").as_bytes())
                hasher.update(String(self.colors[index]).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.has_variant and self.type == Self.SOLID:
            result.set_number(result.root, "color", String(self.color))
        elif self.has_variant and self.type == Self.GRADIENT:
            result.set_number(result.root, "bottom_color", String(self.bottom_color))
            result.set_number(result.root, "rotation_angle", String(self.rotation_angle))
            result.set_number(result.root, "top_color", String(self.top_color))
        elif self.has_variant and self.type == Self.FREEFORM_GRADIENT:
            var array = result.add_array()
            for color in self.colors:
                var number = result.add_number(String(color))
                result.append_child(array, number)
            result.object_set(result.root, "colors", array)
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BackgroundFill:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BackgroundFill JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BackgroundFill JSON value is not an object")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1 or data.nodes[type_index].kind != JSON_STRING:
            raise Error("BackgroundFill JSON object is missing type")
        var fill_type = data.string_value(type_index)
        var result = BackgroundFill(fill_type)
        if fill_type == Self.SOLID:
            var index = data.object_get(data.root, "color")
            if index == -1:
                raise Error("BackgroundFillSolid JSON object is missing color")
            result.color = data.integer_value(index)
            result.has_variant = True
            result.api_kwargs = _background_api_kwargs(data, "type", "color")
        elif fill_type == Self.GRADIENT:
            var top_index = data.object_get(data.root, "top_color")
            var bottom_index = data.object_get(data.root, "bottom_color")
            var angle_index = data.object_get(data.root, "rotation_angle")
            if top_index == -1 or bottom_index == -1 or angle_index == -1:
                raise Error("BackgroundFillGradient JSON object is missing a required field")
            result.top_color = data.integer_value(top_index)
            result.bottom_color = data.integer_value(bottom_index)
            result.rotation_angle = data.integer_value(angle_index)
            result.has_variant = True
            result.api_kwargs = _background_api_kwargs(
                data, "type", "top_color", "bottom_color", "rotation_angle"
            )
        elif fill_type == Self.FREEFORM_GRADIENT:
            var colors_index = data.object_get(data.root, "colors")
            if colors_index == -1 or data.nodes[colors_index].kind != JSON_ARRAY:
                raise Error("BackgroundFillFreeformGradient JSON object is missing colors array")
            var child = data.nodes[colors_index].first_child
            while child != -1:
                result.colors.append(data.integer_value(child))
                child = data.nodes[child].next_sibling
            result.has_variant = True
            result.api_kwargs = _background_api_kwargs(data, "type", "colors")
        else:
            result.api_kwargs = _background_api_kwargs(data, "type")
        return result^


struct BackgroundFillSolid(Equatable, Hashable, Copyable):
    """A solid RGB24 background fill."""

    comptime TYPE = "solid"
    var color: Int
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self, color: Int):
        self.color = color
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, color: Int, *, api_kwargs: JsonDocument):
        self.color = color
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.color = existing.color
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.color == other.color

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.color).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "color", String(self.color))
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BackgroundFillSolid:
        _background_type(data, BackgroundFillSolid.TYPE)
        var color_index = data.object_get(data.root, "color")
        if color_index == -1:
            raise Error("BackgroundFillSolid JSON object is missing color")
        return BackgroundFillSolid(
            data.integer_value(color_index),
            api_kwargs=_background_api_kwargs(data, "type", "color"),
        )


struct BackgroundFillGradient(Equatable, Hashable, Copyable):
    """A two-color gradient background fill."""

    comptime TYPE = "gradient"
    var top_color: Int
    var bottom_color: Int
    var rotation_angle: Int
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self, top_color: Int, bottom_color: Int, rotation_angle: Int):
        self.top_color = top_color
        self.bottom_color = bottom_color
        self.rotation_angle = rotation_angle
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        top_color: Int,
        bottom_color: Int,
        rotation_angle: Int,
        *,
        api_kwargs: JsonDocument,
    ):
        self.top_color = top_color
        self.bottom_color = bottom_color
        self.rotation_angle = rotation_angle
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.top_color = existing.top_color
        self.bottom_color = existing.bottom_color
        self.rotation_angle = existing.rotation_angle
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.top_color == other.top_color
            and self.bottom_color == other.bottom_color
            and self.rotation_angle == other.rotation_angle
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.top_color).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.bottom_color).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.rotation_angle).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "bottom_color", String(self.bottom_color))
        result.set_number(result.root, "rotation_angle", String(self.rotation_angle))
        result.set_number(result.root, "top_color", String(self.top_color))
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BackgroundFillGradient:
        _background_type(data, BackgroundFillGradient.TYPE)
        var top_index = data.object_get(data.root, "top_color")
        var bottom_index = data.object_get(data.root, "bottom_color")
        var angle_index = data.object_get(data.root, "rotation_angle")
        if top_index == -1 or bottom_index == -1 or angle_index == -1:
            raise Error("BackgroundFillGradient JSON object is missing a required field")
        return BackgroundFillGradient(
            data.integer_value(top_index),
            data.integer_value(bottom_index),
            data.integer_value(angle_index),
            api_kwargs=_background_api_kwargs(
                data, "type", "top_color", "bottom_color", "rotation_angle"
            ),
        )


struct BackgroundFillFreeformGradient(Equatable, Hashable, Copyable):
    """A rotating freeform gradient with three or four RGB24 colors."""

    comptime TYPE = "freeform_gradient"
    var colors: List[Int]
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self, colors: List[Int]):
        self.colors = colors.copy()
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, colors: List[Int], *, api_kwargs: JsonDocument):
        self.colors = colors.copy()
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.colors = existing.colors.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return _array_ints_equal(self.colors, other.colors)

    def __hash__[H: Hasher](self, mut hasher: H):
        for index in range(len(self.colors)):
            if index != 0:
                hasher.update(String("\0").as_bytes())
            hasher.update(String(self.colors[index]).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var array = result.add_array()
        for color in self.colors:
            var number = result.add_number(String(color))
            result.append_child(array, number)
        result.object_set(result.root, "colors", array)
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BackgroundFillFreeformGradient:
        _background_type(data, BackgroundFillFreeformGradient.TYPE)
        var colors_index = data.object_get(data.root, "colors")
        if colors_index == -1 or data.nodes[colors_index].kind != JSON_ARRAY:
            raise Error("BackgroundFillFreeformGradient JSON object is missing colors array")
        var colors = List[Int]()
        var child = data.nodes[colors_index].first_child
        while child != -1:
            colors.append(data.integer_value(child))
            child = data.nodes[child].next_sibling
        return BackgroundFillFreeformGradient(
            colors,
            api_kwargs=_background_api_kwargs(data, "type", "colors"),
        )


struct BackgroundTypeChatTheme(Equatable, Hashable, Copyable):
    """A background that uses a Telegram chat theme."""

    comptime TYPE = "chat_theme"
    var theme_name: String
    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self, theme_name: String):
        self.theme_name = theme_name
        self.type = Self.TYPE
        self.api_kwargs = empty_json_object()

    def __init__(out self, theme_name: String, *, api_kwargs: JsonDocument):
        self.theme_name = theme_name
        self.type = Self.TYPE
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.theme_name = existing.theme_name.copy()
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.theme_name == other.theme_name

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.theme_name.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "theme_name", self.theme_name)
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BackgroundTypeChatTheme:
        _background_type(data, BackgroundTypeChatTheme.TYPE)
        var theme_index = data.object_get(data.root, "theme_name")
        if theme_index == -1:
            raise Error("BackgroundTypeChatTheme JSON object is missing theme_name")
        return BackgroundTypeChatTheme(
            data.string_value(theme_index),
            api_kwargs=_background_api_kwargs(data, "type", "theme_name"),
        )
