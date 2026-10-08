from std.testing import assert_equal, assert_raises

from telegram._utils.json import (
    JSON_ARRAY,
    JSON_BOOL,
    JSON_NULL,
    JSON_NUMBER,
    JSON_OBJECT,
    JSON_STRING,
    dumps_json,
    parse_json,
)


def main() raises:
    var document = parse_json(
        "{\"name\":\"bot\",\"items\":[true,null,-1.25e+2,\"\\uD83D\\uDE80\"]}"
    )
    assert_equal(document.nodes[document.root].kind, JSON_OBJECT)
    assert_equal(document.child_count(document.root), 2)

    var name = document.object_get(document.root, "name")
    assert_equal(document.nodes[name].kind, JSON_STRING)
    assert_equal(document.string_value(name), "bot")

    var items = document.object_get(document.root, "items")
    assert_equal(document.nodes[items].kind, JSON_ARRAY)
    assert_equal(document.child_count(items), 4)
    assert_equal(document.nodes[document.array_get(items, 0)].kind, JSON_BOOL)
    assert_equal(document.boolean_value(document.array_get(items, 0)), True)
    assert_equal(document.nodes[document.array_get(items, 1)].kind, JSON_NULL)
    assert_equal(document.nodes[document.array_get(items, 2)].kind, JSON_NUMBER)
    assert_equal(document.number_text(document.array_get(items, 2)), "-1.25e+2")
    assert_equal(document.string_value(document.array_get(items, 3)), "🚀")
    assert_equal(
        dumps_json(document),
        "{\"name\": \"bot\", \"items\": [true, null, -1.25e+2, \"\\ud83d\\ude80\"]}",
    )
    assert_equal(
        dumps_json(document, compact=True),
        "{\"name\":\"bot\",\"items\":[true,null,-1.25e+2,\"\\ud83d\\ude80\"]}",
    )
    assert_equal(
        dumps_json(document, compact=True, ensure_ascii=False),
        "{\"name\":\"bot\",\"items\":[true,null,-1.25e+2,\"🚀\"]}",
    )

    var duplicates = parse_json("{\"a\":1,\"b\":2,\"a\":3}")
    assert_equal(duplicates.child_count(duplicates.root), 2)
    assert_equal(
        duplicates.integer_value(duplicates.object_get(duplicates.root, "a")),
        3,
    )
    assert_equal(dumps_json(duplicates), "{\"a\": 3, \"b\": 2}")

    with assert_raises():
        _ = parse_json("[1,]")
    with assert_raises():
        _ = parse_json("{\"x\":01}")
    with assert_raises():
        _ = parse_json("true false")
