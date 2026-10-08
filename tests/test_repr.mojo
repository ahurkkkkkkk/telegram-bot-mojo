from std.collections import List
from std.testing import assert_equal

from telegram._utils.repr import (
    ReprField,
    build_repr_with_selected_attrs,
    stringify_repr_field,
)


def main() raises:
    var fields = List[ReprField]()
    fields.append(stringify_repr_field("name", "Ada"))
    fields.append(stringify_repr_field("enabled", True))
    fields.append(stringify_repr_field("count", 3))
    assert_equal(
        build_repr_with_selected_attrs("Example", fields),
        "Example[name=Ada, enabled=True, count=3]",
    )
    assert_equal(build_repr_with_selected_attrs("Empty", List[ReprField]()), "Empty[]")
