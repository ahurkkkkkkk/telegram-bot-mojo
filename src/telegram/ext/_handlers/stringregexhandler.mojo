#!/usr/bin/env mojo
# Native string regex predicate corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Match string updates with an anchored Unicode regular expression."""

from std.collections.optional import Optional

from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram._utils.regex import regex_match_from_start
from telegram.ext._handlers.basehandler import BaseHandler


struct StringRegexHandler(Copyable):
    """Native string-pattern predicate with block-default behavior.

    The Mojo runtime has no dynamic callback/context protocol yet. This port
    exposes the synchronous check as an optional Boolean; Python's ``re.Match``
    captures and ``CallbackContext.matches`` propagation remain unimplemented.
    """

    var pattern: String
    var base_handler: BaseHandler

    def __init__(
        out self,
        pattern: String,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ) raises:
        self.pattern = pattern.copy()
        self.base_handler = BaseHandler(block)
        _ = regex_match_from_start(pattern, "")

    def __init__(out self, pattern: String, block: Bool) raises:
        self.pattern = pattern.copy()
        self.base_handler = BaseHandler(block)
        _ = regex_match_from_start(pattern, "")

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[String]) raises -> Optional[Bool]:
        """Return true for a string whose prefix matches, otherwise no match."""
        if update is None:
            return None
        if regex_match_from_start(self.pattern, update.value()):
            return Optional[Bool](True)
        return None
