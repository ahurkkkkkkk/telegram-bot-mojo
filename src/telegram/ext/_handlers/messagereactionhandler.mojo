#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 MessageReactionHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match reaction updates by event kind, chat identity, and actor identity."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id, parse_username


struct MessageReactionHandler(Copyable):
    """Typed predicate for message-reaction and reaction-count updates."""

    comptime MESSAGE_REACTION_UPDATED = -1
    comptime MESSAGE_REACTION_COUNT_UPDATED = 0
    comptime MESSAGE_REACTION = 1

    var base_handler: BaseHandler
    var _chat_ids: Set[Int]
    var _chat_usernames: Set[String]
    var _user_ids: Set[Int]
    var _user_usernames: Set[String]
    var message_reaction_types: Int

    def __init__(
        out self,
        chat_ids: Optional[Set[Int]] = None,
        chat_usernames: Optional[Set[String]] = None,
        user_ids: Optional[Set[Int]] = None,
        user_usernames: Optional[Set[String]] = None,
        message_reaction_types: Int = Self.MESSAGE_REACTION,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ) raises:
        self.base_handler = BaseHandler(block)
        self._chat_ids = Set[Int]()
        self._chat_usernames = Set[String]()
        self._user_ids = Set[Int]()
        self._user_usernames = Set[String]()
        if chat_ids is not None:
            self._chat_ids = parse_chat_id(chat_ids.value().copy())
        if chat_usernames is not None:
            self._chat_usernames = parse_username(chat_usernames.value().copy())
        if user_ids is not None:
            self._user_ids = parse_chat_id(user_ids.value().copy())
        if user_usernames is not None:
            self._user_usernames = parse_username(user_usernames.value().copy())
        self.message_reaction_types = message_reaction_types
        self._validate_user_filter(self.message_reaction_types)

    def __init__(out self, block: Bool):
        self.base_handler = BaseHandler(block)
        self._chat_ids = Set[Int]()
        self._chat_usernames = Set[String]()
        self._user_ids = Set[Int]()
        self._user_usernames = Set[String]()
        self.message_reaction_types = Self.MESSAGE_REACTION

    def __init__(
        out self,
        chat_ids: Optional[Set[Int]],
        chat_usernames: Optional[Set[String]],
        user_ids: Optional[Set[Int]],
        user_usernames: Optional[Set[String]],
        message_reaction_types: Int,
        block: Bool,
    ) raises:
        self.base_handler = BaseHandler(block)
        self._chat_ids = Set[Int]()
        self._chat_usernames = Set[String]()
        self._user_ids = Set[Int]()
        self._user_usernames = Set[String]()
        if chat_ids is not None:
            self._chat_ids = parse_chat_id(chat_ids.value().copy())
        if chat_usernames is not None:
            self._chat_usernames = parse_username(chat_usernames.value().copy())
        if user_ids is not None:
            self._user_ids = parse_chat_id(user_ids.value().copy())
        if user_usernames is not None:
            self._user_usernames = parse_username(user_usernames.value().copy())
        self.message_reaction_types = message_reaction_types
        self._validate_user_filter(self.message_reaction_types)

    def _validate_user_filter(self, reaction_types: Int) raises:
        var has_user_filter = len(self._user_ids) > 0 or len(self._user_usernames) > 0
        if has_user_filter and (
            reaction_types == Self.MESSAGE_REACTION
            or reaction_types == Self.MESSAGE_REACTION_COUNT_UPDATED
        ):
            raise Error(
                "User filters require MESSAGE_REACTION_UPDATED; anonymous reaction events are included"
            )

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) -> Bool:
        """Match an event and return true when any configured identity filter matches."""
        if update is None:
            return False
        var has_reaction_update = update.value().message_reaction is not None
        var has_count_update = update.value().message_reaction_count is not None
        if not has_reaction_update and not has_count_update:
            return False
        if (
            self.message_reaction_types == Self.MESSAGE_REACTION_UPDATED
            and has_count_update
        ):
            return False
        if (
            self.message_reaction_types == Self.MESSAGE_REACTION_COUNT_UPDATED
            and has_reaction_update
        ):
            return False

        var has_filters = (
            len(self._chat_ids) > 0 or len(self._chat_usernames) > 0
            or len(self._user_ids) > 0 or len(self._user_usernames) > 0
        )
        if not has_filters:
            return True

        var chat_id: Int
        var chat_username: Optional[String]
        if has_reaction_update:
            chat_id = update.value().message_reaction.value().chat.id
            chat_username = update.value().message_reaction.value().chat.username.copy()
        else:
            chat_id = update.value().message_reaction_count.value().chat.id
            chat_username = update.value().message_reaction_count.value().chat.username.copy()

        for allowed_id in self._chat_ids:
            if chat_id == allowed_id:
                return True
        if chat_username is not None:
            for allowed_username in self._chat_usernames:
                if chat_username.value() == allowed_username:
                    return True

        if has_reaction_update and update.value().message_reaction.value().user is not None:
            var user = update.value().message_reaction.value().user.value().copy()
            for allowed_id in self._user_ids:
                if user.id == allowed_id:
                    return True
            if user.username is not None:
                for allowed_username in self._user_usernames:
                    if user.username.value() == allowed_username:
                        return True
        return False
