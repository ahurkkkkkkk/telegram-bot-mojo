#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 BusinessMessagesDeletedHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match deleted-business-message updates, optionally filtered by chat identity."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


struct BusinessMessagesDeletedHandler(Copyable):
    """Typed update predicate for BusinessMessagesDeleted events.

    This native predicate accepts normalized Mojo sets for optional chat filters.
    Callback storage and Application dispatch are handled by the still-incomplete base API.
    """

    var base_handler: BaseHandler
    var _chat_ids: Set[Int]
    var _usernames: Set[String]

    def __init__(out self, block: DefaultValue[Bool] = DEFAULT_TRUE):
        self.base_handler = BaseHandler(block)
        self._chat_ids = Set[Int]()
        self._usernames = Set[String]()

    def __init__(out self, block: Bool):
        self.base_handler = BaseHandler(block)
        self._chat_ids = Set[Int]()
        self._usernames = Set[String]()

    def __init__(
        out self,
        chat_ids: Set[Int],
        usernames: Set[String],
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self._chat_ids = parse_chat_id(chat_ids)
        self._usernames = parse_username(usernames)

    def __init__(
        out self,
        chat_ids: Set[Int],
        usernames: Set[String],
        block: Bool,
    ):
        self.base_handler = BaseHandler(block)
        self._chat_ids = parse_chat_id(chat_ids)
        self._usernames = parse_username(usernames)

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) -> Bool:
        """Match only deleted-business-message events passing either chat filter."""
        if update is None:
            return False
        if update.value().deleted_business_messages is None:
            return False
        var chat = update.value().deleted_business_messages.value().chat.copy()
        if len(self._chat_ids) == 0 and len(self._usernames) == 0:
            return True
        for chat_id in self._chat_ids:
            if chat.id == chat_id:
                return True
        if chat.username is not None:
            for username in self._usernames:
                if chat.username.value() == username:
                    return True
        return False
