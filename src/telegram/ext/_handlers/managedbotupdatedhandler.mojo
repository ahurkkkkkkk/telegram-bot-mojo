#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 ManagedBotUpdatedHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match managed-bot update events by creator or managed-bot identity."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


struct ManagedBotUpdatedHandler(Copyable):
    """Typed update predicate for ManagedBotUpdated events."""

    var base_handler: BaseHandler
    var _user_ids: Set[Int]
    var _usernames: Set[String]

    def __init__(out self, block: DefaultValue[Bool] = DEFAULT_TRUE):
        self.base_handler = BaseHandler(block)
        self._user_ids = Set[Int]()
        self._usernames = Set[String]()

    def __init__(out self, block: Bool):
        self.base_handler = BaseHandler(block)
        self._user_ids = Set[Int]()
        self._usernames = Set[String]()

    def __init__(
        out self,
        user_ids: Set[Int],
        usernames: Set[String],
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self._user_ids = parse_chat_id(user_ids)
        self._usernames = parse_username(usernames)

    def __init__(
        out self,
        user_ids: Set[Int],
        usernames: Set[String],
        block: Bool,
    ):
        self.base_handler = BaseHandler(block)
        self._user_ids = parse_chat_id(user_ids)
        self._usernames = parse_username(usernames)

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) -> Bool:
        """Match when either the creator or managed bot passes either filter."""
        if update is None:
            return False
        if update.value().managed_bot is None:
            return False
        var event = update.value().managed_bot.value().copy()
        if len(self._user_ids) == 0 and len(self._usernames) == 0:
            return True
        if _user_matches(event.user.id, event.user.username, self._user_ids, self._usernames):
            return True
        return _user_matches(event.bot.id, event.bot.username, self._user_ids, self._usernames)


def _user_matches(
    user_id: Int,
    username: Optional[String],
    user_ids: Set[Int],
    usernames: Set[String],
) -> Bool:
    for configured_id in user_ids:
        if user_id == configured_id:
            return True
    if username is not None:
        for configured_username in usernames:
            if username.value() == configured_username:
                return True
    return False
