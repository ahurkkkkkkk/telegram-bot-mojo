#!/usr/bin/env mojo
#
# Native typed specialization of python-telegram-bot v22.8 TypeHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Handle values statically specialized to a native Mojo update type."""

from std.collections.optional import Optional

from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler


struct TypeHandler[UpdateType: Copyable & Deinitable](Copyable):
    """Type-specialized update predicate.

    The handled type is a Mojo compile-time parameter. Mojo has no Python-style
    runtime class object or subclass relation, so subclass-aware dispatch is not
    represented; the optional value's static type establishes the match.
    """

    var base_handler: BaseHandler
    var strict: Bool

    def __init__(
        out self,
        strict: Bool = False,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.strict = strict

    def __init__(out self, strict: Bool, block: Bool):
        self.base_handler = BaseHandler(block)
        self.strict = strict

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Self.UpdateType]) -> Bool:
        """Return true exactly when the statically typed update is present."""
        return update is not None
