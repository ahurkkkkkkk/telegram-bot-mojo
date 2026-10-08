#!/usr/bin/env mojo
# Native warning-transition helpers corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Build deprecation messages and resolve renamed string arguments."""

from std.collections.optional import Optional

from telegram.warnings import PTBDeprecationWarning


@fieldwise_init
struct DeprecatedArgumentResolution(Copyable):
    """Selected value and optional warning produced by renamed-argument handling."""

    var value: String
    var used_deprecated_name: Bool
    var warning: Optional[PTBDeprecationWarning]


def build_deprecation_warning_message(
    deprecated_name: String,
    new_name: String,
    object_type: String,
    bot_api_version: String,
) -> String:
    """Return the upstream message for a renamed parameter or attribute."""
    return String(
        "The ", object_type, " '", deprecated_name, "' was replaced by '",
        new_name, "' in Bot API ", bot_api_version,
        ". We recommend using '", new_name, "' instead of '",
        deprecated_name, "'.",
    )


def resolve_deprecated_string_argument(
    deprecated_value: Optional[String],
    new_value: Optional[String],
    deprecated_name: String,
    new_name: String,
    bot_api_version: String,
    ptb_version: String,
) raises -> DeprecatedArgumentResolution:
    """Resolve string aliases using Python truthiness and equality semantics.

    The result carries a warning value for the caller to emit. Python's warning
    callback, category filters, and stacklevel reporting are not available here.
    """
    var old_is_truthy = deprecated_value is not None
    if old_is_truthy and deprecated_value.value().byte_length() == 0:
        old_is_truthy = False
    var new_is_truthy = new_value is not None
    if new_is_truthy and new_value.value().byte_length() == 0:
        new_is_truthy = False

    if old_is_truthy and new_is_truthy and deprecated_value.value() != new_value.value():
        var base_message = build_deprecation_warning_message(
            deprecated_name, new_name, "parameter", bot_api_version
        )
        raise Error(
            String(
                "You passed different entities as '", deprecated_name, "' and '",
                new_name, "'. ", base_message,
            )
        )

    if old_is_truthy:
        var warning_message = String(
            "Bot API ", bot_api_version, " renamed the argument '",
            deprecated_name, "' to '", new_name, "'.",
        )
        return DeprecatedArgumentResolution(
            deprecated_value.value().copy(),
            True,
            Optional[PTBDeprecationWarning](
                PTBDeprecationWarning(ptb_version, warning_message)
            ),
        )

    var selected = String()
    if new_value is not None:
        selected = new_value.value().copy()
    return DeprecatedArgumentResolution(selected, False, None)
