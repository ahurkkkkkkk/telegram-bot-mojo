#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 MessageHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Apply a native Telegram message filter to incoming Update values."""

from std.collections.optional import Optional

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext.filters import ALL, BaseFilter


struct MessageHandler(Copyable):
    """Native Boolean-filter portion of MessageHandler.

    Data-filter context merging and callback dispatch require the not-yet-ported
    CallbackContext and Application surfaces.
    """

    var base_handler: BaseHandler
    var filters: BaseFilter

    def __init__(
        out self,
        filters: Optional[BaseFilter] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        if filters is None:
            self.filters = ALL
        else:
            self.filters = filters.value()

    def __init__(out self, filters: Optional[BaseFilter], block: Bool):
        self.base_handler = BaseHandler(block)
        if filters is None:
            self.filters = ALL
        else:
            self.filters = filters.value()

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) raises -> Optional[Bool]:
        """Return filter acceptance; an absent statically typed update stays absent."""
        if update is None:
            return None
        return Optional[Bool](self.filters.check_update(update.value()))
