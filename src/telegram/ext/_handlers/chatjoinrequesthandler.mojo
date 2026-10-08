#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 ChatJoinRequestHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match chat-join-request updates with optional chat ID and requester username filters."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


struct ChatJoinRequestHandler(Copyable):
    """Typed update predicate for ChatJoinRequest events."""

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
        """Match join requests by chat ID or the requesting user's username."""
        if update is None:
            return False
        if update.value().chat_join_request is None:
            return False
        var request = update.value().chat_join_request.value().copy()
        if len(self._chat_ids) == 0 and len(self._usernames) == 0:
            return True
        for chat_id in self._chat_ids:
            if request.chat.id == chat_id:
                return True
        if request.from_user.username is not None:
            for username in self._usernames:
                if request.from_user.username.value() == username:
                    return True
        return False
