#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 InlineQueryHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match inline queries, optionally restricting their chat type."""

from std.collections import List
from std.collections.optional import Optional

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram._utils.regex import regex_match_from_start
from telegram.ext._handlers.basehandler import BaseHandler


struct InlineQueryHandler:
    """Regex and chat-type predicate for inline-query updates."""

    var base_handler: BaseHandler
    var chat_types: Optional[List[String]]
    var pattern: Optional[String]

    def __init__(
        out self,
        chat_types: Optional[List[String]] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
        pattern: Optional[String] = None,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.chat_types = chat_types.copy()
        self.pattern = pattern.copy()
        if pattern is not None:
            _ = regex_match_from_start(pattern.value(), "")

    def __init__(
        out self,
        chat_types: Optional[List[String]],
        block: Bool,
        pattern: Optional[String] = None,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.chat_types = chat_types.copy()
        self.pattern = pattern.copy()
        if pattern is not None:
            _ = regex_match_from_start(pattern.value(), "")

    def __init__(out self, block: Bool):
        self.base_handler = BaseHandler(block)
        self.chat_types = None
        self.pattern = None

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) raises -> Optional[Bool]:
        """Match inline queries, returning None for absent or regex-nonmatching updates."""
        if update is None or update.value().inline_query is None:
            return None
        var query = update.value().inline_query.value().copy()
        if self.chat_types is not None:
            if query.chat_type is None:
                return Optional[Bool](False)
            var allowed = False
            for allowed_type in self.chat_types.value():
                if query.chat_type.value() == allowed_type:
                    allowed = True
                    break
            if not allowed:
                return Optional[Bool](False)
        if self.pattern is not None:
            if regex_match_from_start(self.pattern.value(), query.query):
                return Optional[Bool](True)
            return None
        return Optional[Bool](True)
