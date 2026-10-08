#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 ChatMemberHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match membership updates with optional chat and event-type filters."""

from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._utils._update_parsing import parse_chat_id


struct ChatMemberHandler(Copyable):
    """Typed predicate for ``chat_member`` and ``my_chat_member`` updates."""

    comptime MY_CHAT_MEMBER = -1
    comptime CHAT_MEMBER = 0
    comptime ANY_CHAT_MEMBER = 1

    var base_handler: BaseHandler
    var chat_member_types: Int
    var _chat_ids: Set[Int]

    def __init__(
        out self,
        chat_member_types: Int = Self.MY_CHAT_MEMBER,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.chat_member_types = chat_member_types
        self._chat_ids = Set[Int]()

    def __init__(out self, chat_member_types: Int, block: Bool):
        self.base_handler = BaseHandler(block)
        self.chat_member_types = chat_member_types
        self._chat_ids = Set[Int]()

    def __init__(
        out self,
        chat_member_types: Int,
        chat_ids: Set[Int],
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.chat_member_types = chat_member_types
        self._chat_ids = parse_chat_id(chat_ids)

    def __init__(
        out self,
        chat_member_types: Int,
        chat_ids: Set[Int],
        block: Bool,
    ):
        self.base_handler = BaseHandler(block)
        self.chat_member_types = chat_member_types
        self._chat_ids = parse_chat_id(chat_ids)

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) -> Bool:
        """Return whether the event type and optional chat ID match."""
        if update is None:
            return False
        if update.value().my_chat_member is None and update.value().chat_member is None:
            return False

        var chat_id: Int
        if update.value().my_chat_member is not None:
            chat_id = update.value().my_chat_member.value().chat.id
        else:
            chat_id = update.value().chat_member.value().chat.id

        if len(self._chat_ids) > 0:
            var matching_chat = False
            for allowed_id in self._chat_ids:
                if chat_id == allowed_id:
                    matching_chat = True
                    break
            if not matching_chat:
                return False

        if self.chat_member_types == Self.ANY_CHAT_MEMBER:
            return True
        if self.chat_member_types == Self.CHAT_MEMBER:
            return update.value().chat_member is not None
        return update.value().my_chat_member is not None
