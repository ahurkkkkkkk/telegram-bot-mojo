from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram._utils.warnings_transition import (
    build_deprecation_warning_message,
    resolve_deprecated_string_argument,
)


def main() raises:
    var message = build_deprecation_warning_message(
        "old_name", "new_name", "parameter", "10.0"
    )
    assert_equal(
        message,
        "The parameter 'old_name' was replaced by 'new_name' in Bot API 10.0. "
        "We recommend using 'new_name' instead of 'old_name'.",
    )

    var deprecated = resolve_deprecated_string_argument(
        Optional[String]("old"), None, "old_name", "new_name", "10.0", "22.8"
    )
    assert_equal(deprecated.value, "old")
    assert_equal(deprecated.used_deprecated_name, True)
    assert_equal(deprecated.warning is not None, True)
    assert_equal(
        deprecated.warning.value().__str__(),
        "Deprecated since version 22.8: Bot API 10.0 renamed the argument "
        "'old_name' to 'new_name'.",
    )

    var current = resolve_deprecated_string_argument(
        Optional[String]("old"), Optional[String]("old"),
        "old_name", "new_name", "10.0", "22.8",
    )
    assert_equal(current.value, "old")
    var empty_old = resolve_deprecated_string_argument(
        Optional[String](""), Optional[String]("new"),
        "old_name", "new_name", "10.0", "22.8",
    )
    assert_equal(empty_old.value, "new")
    assert_equal(empty_old.warning is None, True)

    with assert_raises():
        _ = resolve_deprecated_string_argument(
            Optional[String]("old"), Optional[String]("different"),
            "old_name", "new_name", "10.0", "22.8",
        )
