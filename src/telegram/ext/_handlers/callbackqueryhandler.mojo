#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 CallbackQueryHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Filter callback-query updates by callback-data and game-name regexes."""

from std.collections.optional import Optional

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram._utils.regex import regex_match_from_start
from telegram.ext._handlers.basehandler import BaseHandler


struct CallbackQueryHandler(Copyable):
    """Native regex-matching predicate for callback-query updates.

    String patterns are supported. Python callable and runtime-type filters,
    callback invocation, and CallbackContext.matches propagation require the
    not-yet-ported polymorphic callback runtime.
    """

    var base_handler: BaseHandler
    var pattern: Optional[String]
    var game_pattern: Optional[String]

    def __init__(
        out self,
        pattern: Optional[String] = None,
        game_pattern: Optional[String] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.pattern = pattern.copy()
        self.game_pattern = game_pattern.copy()
        if pattern is not None:
            _ = regex_match_from_start(pattern.value(), "")
        if game_pattern is not None:
            _ = regex_match_from_start(game_pattern.value(), "")

    def __init__(
        out self,
        pattern: Optional[String],
        game_pattern: Optional[String],
        block: Bool,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.pattern = pattern.copy()
        self.game_pattern = game_pattern.copy()
        if pattern is not None:
            _ = regex_match_from_start(pattern.value(), "")
        if game_pattern is not None:
            _ = regex_match_from_start(game_pattern.value(), "")

    def __init__(out self, block: Bool):
        self.base_handler = BaseHandler(block)
        self.pattern = None
        self.game_pattern = None

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) raises -> Optional[Bool]:
        """Return None for unrelated updates and a predicate result otherwise."""
        if update is None or update.value().callback_query is None:
            return None
        var query = update.value().callback_query.value().copy()
        if self.pattern is None and self.game_pattern is None:
            return Optional[Bool](True)

        if query.data is not None and query.data.value().byte_length() > 0:
            if self.pattern is None:
                return Optional[Bool](False)
            return Optional[Bool](
                regex_match_from_start(self.pattern.value(), query.data.value())
            )

        if query.game_short_name is not None and query.game_short_name.value().byte_length() > 0:
            if self.game_pattern is None:
                return Optional[Bool](False)
            return Optional[Bool](
                regex_match_from_start(
                    self.game_pattern.value(), query.game_short_name.value()
                )
            )
        return Optional[Bool](True)
