from std.testing import assert_equal, assert_raises

from telegram import MaskPosition
from telegram._utils.json import parse_json


def main() raises:
    var position = MaskPosition(MaskPosition.EYES, 0.25, -0.5, 1.5)
    assert_equal(
        position.to_json(),
        "{\"point\": \"eyes\", \"x_shift\": 0.25, \"y_shift\": -0.5, \"scale\": 1.5}",
    )
    var decoded = MaskPosition.de_json(
        parse_json("{\"point\":\"mouth\",\"x_shift\":0,\"y_shift\":-1.25,\"scale\":2,\"future\":true}")
    )
    assert_equal(decoded.point, MaskPosition.MOUTH)
    assert_equal(decoded.y_shift, -1.25)
    assert_equal(
        decoded.to_json(),
        "{\"point\": \"mouth\", \"x_shift\": 0.0, \"y_shift\": -1.25, \"scale\": 2.0, \"future\": true}",
    )
    assert_equal(decoded == MaskPosition("mouth", 0.0, -1.25, 2.0), True)
    assert_equal(hash(decoded), hash(MaskPosition("mouth", -0.0, -1.25, 2.0)))
    assert_equal(
        len(MaskPosition.de_list(parse_json("[{\"point\":\"chin\",\"x_shift\":0,\"y_shift\":0,\"scale\":1}]"), 0)),
        1,
    )
    with assert_raises():
        _ = MaskPosition.de_json(parse_json("{}"))
