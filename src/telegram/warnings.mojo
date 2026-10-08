#!/usr/bin/env mojo
# Native value types corresponding to python-telegram-bot v22.8 warnings.
# LGPL-3.0-or-later; see LICENSE.

"""Warning value types exposed by the Telegram client."""


@fieldwise_init
struct PTBUserWarning(Copyable):
    """A native user-warning value carrying its display message."""

    var message: String

    def __str__(self) -> String:
        return self.message.copy()


@fieldwise_init
struct PTBRuntimeWarning(Copyable):
    """A runtime-warning value with the PTB user-warning message contract."""

    var message: String

    def __str__(self) -> String:
        return self.message.copy()


@fieldwise_init
struct PTBDeprecationWarning(Copyable):
    """A deprecation warning with upstream version-prefixed string formatting."""

    var version: String
    var message: String

    def __str__(self) -> String:
        return String("Deprecated since version ", self.version, ": ", self.message)
