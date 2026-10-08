from std.collections.list import List
from std.testing import assert_equal

from telegram import (
    BackgroundFill,
    BackgroundFillFreeformGradient,
    BackgroundFillGradient,
    BackgroundFillSolid,
    BackgroundTypeChatTheme,
)
from telegram._utils.json import parse_json


def main() raises:
    var solid = BackgroundFillSolid(0x123456)
    assert_equal(solid.type, "solid")
    assert_equal(solid.to_json(), "{\"color\": 1193046, \"type\": \"solid\"}")
    var solid_copy = BackgroundFillSolid.de_json(parse_json(solid.to_json()))
    assert_equal(solid_copy == solid, True)
    assert_equal(hash(solid_copy), hash(solid))
    var tagged_solid = BackgroundFill.de_json(parse_json(solid.to_json()))
    assert_equal(tagged_solid.type, "solid")
    assert_equal(tagged_solid.has_variant, True)
    assert_equal(tagged_solid.color, solid.color)
    assert_equal(tagged_solid.to_json(), solid.to_json())
    var solid_future = BackgroundFillSolid.de_json(
        parse_json("{\"type\":\"solid\",\"color\":1,\"future\":true}")
    )
    assert_equal(
        solid_future.to_json(),
        "{\"color\": 1, \"type\": \"solid\", \"future\": true}",
    )

    var gradient = BackgroundFillGradient(1, 2, 90)
    assert_equal(
        gradient.to_json(),
        "{\"bottom_color\": 2, \"rotation_angle\": 90, \"top_color\": 1, \"type\": \"gradient\"}",
    )
    var gradient_copy = BackgroundFillGradient.de_json(parse_json(gradient.to_json()))
    assert_equal(gradient_copy == gradient, True)
    var tagged_gradient = BackgroundFill.de_json(parse_json(gradient.to_json()))
    assert_equal(tagged_gradient == BackgroundFill.de_json(parse_json(gradient.to_json())), True)
    assert_equal(tagged_gradient.rotation_angle, 90)

    var colors = List[Int]()
    colors.append(1)
    colors.append(2)
    colors.append(3)
    var freeform = BackgroundFillFreeformGradient(colors)
    var freeform_copy = BackgroundFillFreeformGradient.de_json(parse_json(freeform.to_json()))
    assert_equal(freeform_copy == freeform, True)
    assert_equal(freeform_copy.colors[2], 3)
    var tagged_freeform = BackgroundFill.de_json(parse_json(freeform.to_json()))
    assert_equal(tagged_freeform.colors[1], 2)
    assert_equal(tagged_freeform.to_json(), freeform.to_json())

    var unknown_fill = BackgroundFill.de_json(
        parse_json("{\"type\":\"future_fill\",\"future_field\":true}")
    )
    assert_equal(unknown_fill.has_variant, False)
    assert_equal(
        unknown_fill.to_json(),
        "{\"type\": \"future_fill\", \"future_field\": true}",
    )

    var theme = BackgroundTypeChatTheme("day")
    assert_equal(theme.type, "chat_theme")
    var theme_copy = BackgroundTypeChatTheme.de_json(parse_json(theme.to_json()))
    assert_equal(theme_copy == theme, True)
