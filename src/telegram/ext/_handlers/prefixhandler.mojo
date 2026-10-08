#!/usr/bin/env mojo
#
# Native predicate for python-telegram-bot v22.8 PrefixHandler.
# LGPL-3.0-or-later; see LICENSE.

"""Match prefixed message commands and retain Python-style whitespace args."""

from std.collections import List
from std.collections.optional import Optional
from std.collections.set import Set

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext.filters import BaseFilter, UpdateType


def _prefix_is_whitespace(character: String) -> Bool:
    """Match Python's Unicode whitespace set used by ``str.split()``."""
    if character.isspace():
        return True
    return (
        character == "\u00a0" or character == "\u1680"
        or character == "\u2000" or character == "\u2001"
        or character == "\u2002" or character == "\u2003"
        or character == "\u2004" or character == "\u2005"
        or character == "\u2006" or character == "\u2007"
        or character == "\u2008" or character == "\u2009"
        or character == "\u200a" or character == "\u202f"
        or character == "\u205f" or character == "\u3000"
    )


def _prefix_split_whitespace(text: String) -> List[String]:
    """Split on runs of Python whitespace, omitting empty leading/trailing fields."""
    var result = List[String]()
    var current = String()
    for character in text.codepoint_slices():
        var value = String(character)
        if _prefix_is_whitespace(value):
            if current.byte_length() > 0:
                result.append(current.copy())
                current = String()
        else:
            current.write_string(character)
    if current.byte_length() > 0:
        result.append(current.copy())
    return result^


struct PrefixHandlerResult:
    """Native tri-state equivalent of a PrefixHandler check result.

    ``status`` is 0 for no command match, 1 for a command rejected by its filter,
    and 2 for an accepted command. Args are populated only for accepted matches.
    """

    comptime NO_MATCH = 0
    comptime FILTERED_OUT = 1
    comptime MATCH = 2

    var status: Int
    var args: List[String]

    def __init__(out self, status: Int, args: List[String]):
        self.status = status
        self.args = args.copy()


struct PrefixHandler(Copyable):
    """Native matching and argument parsing portion of PrefixHandler."""

    var base_handler: BaseHandler
    var commands: Set[String]
    var filters: BaseFilter

    def __init__(
        out self,
        prefixes: List[String],
        command_names: List[String],
        filters: Optional[BaseFilter] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        for prefix in prefixes:
            for command in command_names:
                _ = self.commands.insert(prefix.lower() + command.lower())
        if filters is None:
            self.filters = UpdateType.MESSAGES
        else:
            self.filters = filters.value()

    def __init__(
        out self,
        prefixes: List[String],
        command_names: List[String],
        filters: Optional[BaseFilter],
        block: Bool,
    ):
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        for prefix in prefixes:
            for command in command_names:
                _ = self.commands.insert(prefix.lower() + command.lower())
        if filters is None:
            self.filters = UpdateType.MESSAGES
        else:
            self.filters = filters.value()

    def __init__(
        out self,
        prefix: String,
        command: String,
        filters: Optional[BaseFilter] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        _ = self.commands.insert(prefix.lower() + command.lower())
        if filters is None:
            self.filters = UpdateType.MESSAGES
        else:
            self.filters = filters.value()

    def __init__(
        out self,
        prefix: String,
        command: String,
        filters: Optional[BaseFilter],
        block: Bool,
    ):
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        _ = self.commands.insert(prefix.lower() + command.lower())
        if filters is None:
            self.filters = UpdateType.MESSAGES
        else:
            self.filters = filters.value()

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[Update]) raises -> PrefixHandlerResult:
        """Return the match state and parsed arguments for an incoming Update."""
        var no_args = List[String]()
        if update is None:
            return PrefixHandlerResult(PrefixHandlerResult.NO_MATCH, no_args)

        var message_optional = update.value().effective_message()
        if message_optional is None:
            return PrefixHandlerResult(PrefixHandlerResult.NO_MATCH, no_args)
        var message = message_optional.value().copy()
        if message.text is None or message.text.value().byte_length() == 0:
            return PrefixHandlerResult(PrefixHandlerResult.NO_MATCH, no_args)

        var words = _prefix_split_whitespace(message.text.value())
        if len(words) == 0:
            # Upstream indexes text_list[0] after checking only that text is
            # truthy, so a whitespace-only message raises IndexError.
            raise Error("PrefixHandler cannot index an empty whitespace split")
        if words[0].lower() not in self.commands:
            return PrefixHandlerResult(PrefixHandlerResult.NO_MATCH, no_args)

        if not self.filters.check_update(update.value()):
            return PrefixHandlerResult(PrefixHandlerResult.FILTERED_OUT, no_args)

        var args = List[String]()
        for i in range(1, len(words)):
            args.append(words[i].copy())
        return PrefixHandlerResult(PrefixHandlerResult.MATCH, args)
