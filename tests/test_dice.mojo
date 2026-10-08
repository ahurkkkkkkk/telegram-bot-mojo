from std.testing import assert_equal

from telegram import Dice
from telegram._utils.json import parse_json


def main() raises:
    var dice = Dice.de_json(
        parse_json("{\"value\":4,\"emoji\":\"🎲\",\"future\":false}")
    )
    assert_equal(dice.value, 4)
    assert_equal(dice.emoji, "🎲")
    assert_equal(dice == Dice(4, "🎲"), True)
    assert_equal(hash(dice), hash(Dice(4, "🎲")))
    assert_equal(
        dice.to_json(),
        "{\"value\": 4, \"emoji\": \"\\ud83c\\udfb2\", \"future\": false}",
    )
    assert_equal(Dice.DICE, "🎲")
    assert_equal(Dice.MAX_VALUE_DICE, 6)
