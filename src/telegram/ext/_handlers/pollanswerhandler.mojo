#!/usr/bin/env mojo
# Native PollAnswerHandler predicate corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Check whether a typed update contains a PollAnswer."""

from std.collections.optional import Optional

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler


struct PollAnswerHandler(Copyable):
    var base_handler: BaseHandler

    def __init__(out self, block: DefaultValue[Bool] = DEFAULT_TRUE):
        self.base_handler = BaseHandler(block)

    def __init__(out self, block: Bool):
        self.base_handler = BaseHandler(block)

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) -> Bool:
        if update is None:
            return False
        return update.value().poll_answer is not None
