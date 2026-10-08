#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 ChosenInlineResultHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match updates containing a chosen inline result."""

from std.collections.optional import Optional

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram._utils.regex import regex_match_from_start
from telegram.ext._handlers.basehandler import BaseHandler


struct ChosenInlineResultHandler(Copyable):
    """Regex predicate for chosen-inline-result updates."""

    var base_handler: BaseHandler
    var pattern: Optional[String]

    def __init__(
        out self,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
        pattern: Optional[String] = None,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.pattern = pattern.copy()
        if pattern is not None:
            _ = regex_match_from_start(pattern.value(), "")

    def __init__(out self, block: Bool, pattern: Optional[String] = None) raises:
        self.base_handler = BaseHandler(block)
        self.pattern = pattern.copy()
        if pattern is not None:
            _ = regex_match_from_start(pattern.value(), "")

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) raises -> Optional[Bool]:
        """Return None for unrelated or nonmatching results."""
        if update is None or update.value().chosen_inline_result is None:
            return None
        if self.pattern is None:
            return Optional[Bool](True)
        var chosen = update.value().chosen_inline_result.value().copy()
        if regex_match_from_start(self.pattern.value(), chosen.result_id):
            return Optional[Bool](True)
        return None
