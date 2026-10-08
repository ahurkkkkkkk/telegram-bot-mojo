#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 PaidMediaPurchasedHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match paid-media purchase updates, optionally filtered by purchasing user."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


struct PaidMediaPurchasedHandler(Copyable):
    """Typed update predicate for PaidMediaPurchased events.

    This native predicate accepts normalized Mojo sets for the optional user filters.
    Callback storage and Application dispatch remain incomplete in the base API.
    """

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
        """Match paid-media purchases whose user passes either identity filter."""
        if update is None:
            return False
        if update.value().purchased_paid_media is None:
            return False
        var user = update.value().purchased_paid_media.value().from_user.copy()
        if len(self._user_ids) == 0 and len(self._usernames) == 0:
            return True
        for user_id in self._user_ids:
            if user.id == user_id:
                return True
        if user.username is not None:
            for username in self._usernames:
                if user.username.value() == username:
                    return True
        return False
