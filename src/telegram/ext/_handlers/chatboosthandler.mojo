#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 ChatBoostHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match boost-added/changed and boost-removed updates by type and chat."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


struct ChatBoostHandler(Copyable):
    """Typed predicate for chat-boost update events."""

    comptime CHAT_BOOST = -1
    comptime REMOVED_CHAT_BOOST = 0
    comptime ANY_CHAT_BOOST = 1

    var base_handler: BaseHandler
    var chat_boost_types: Int
    var _chat_ids: Set[Int]
    var _chat_usernames: Set[String]

    def __init__(
        out self,
        chat_boost_types: Int = Self.CHAT_BOOST,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.chat_boost_types = chat_boost_types
        self._chat_ids = Set[Int]()
        self._chat_usernames = Set[String]()

    def __init__(out self, chat_boost_types: Int, block: Bool):
        self.base_handler = BaseHandler(block)
        self.chat_boost_types = chat_boost_types
        self._chat_ids = Set[Int]()
        self._chat_usernames = Set[String]()

    def __init__(
        out self,
        chat_boost_types: Int,
        chat_ids: Set[Int],
        chat_usernames: Set[String],
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.chat_boost_types = chat_boost_types
        self._chat_ids = parse_chat_id(chat_ids)
        self._chat_usernames = parse_username(chat_usernames)

    def __init__(
        out self,
        chat_boost_types: Int,
        chat_ids: Set[Int],
        chat_usernames: Set[String],
        block: Bool,
    ):
        self.base_handler = BaseHandler(block)
        self.chat_boost_types = chat_boost_types
        self._chat_ids = parse_chat_id(chat_ids)
        self._chat_usernames = parse_username(chat_usernames)

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) -> Bool:
        """Return whether event type and optional chat identity match."""
        if update is None:
            return False
        if update.value().chat_boost is None and update.value().removed_chat_boost is None:
            return False
        if self.chat_boost_types == Self.CHAT_BOOST and update.value().chat_boost is None:
            return False
        if (
            self.chat_boost_types == Self.REMOVED_CHAT_BOOST
            and update.value().removed_chat_boost is None
        ):
            return False

        if len(self._chat_ids) == 0 and len(self._chat_usernames) == 0:
            return True

        var chat_id: Int
        var chat_username: Optional[String]
        if update.value().chat_boost is not None:
            chat_id = update.value().chat_boost.value().chat.id
            chat_username = update.value().chat_boost.value().chat.username.copy()
        else:
            chat_id = update.value().removed_chat_boost.value().chat.id
            chat_username = update.value().removed_chat_boost.value().chat.username.copy()

        for allowed_id in self._chat_ids:
            if chat_id == allowed_id:
                return True
        if chat_username is not None:
            for allowed_username in self._chat_usernames:
                if chat_username.value() == allowed_username:
                    return True
        return False
