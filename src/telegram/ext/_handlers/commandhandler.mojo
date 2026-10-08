#!/usr/bin/env mojo
#
# Native command predicate corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Match Telegram bot-command entities and retain parsed command arguments."""

from std.collections import List, Set
from std.collections.optional import Optional

from telegram import Update
from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram._utils.regex import regex_match_from_start
from telegram.ext._handlers.basehandler import BaseHandler
from telegram.ext._handlers.prefixhandler import _prefix_split_whitespace
from telegram.ext.filters import BaseFilter, UpdateType


struct CommandHandlerResult(Copyable):
    """Native tri-state check result: no match, filter rejected, or accepted with args."""

    comptime NO_MATCH = 0
    comptime FILTERED_OUT = 1
    comptime MATCH = 2

    var status: Int
    var args: List[String]

    def __init__(out self, status: Int, args: List[String]):
        self.status = status
        self.args = args.copy()


def _command_is_valid(command: String) raises -> Bool:
    # Mirrors upstream `^[\da-z_]{1,32}$`; PCRE2 UCP makes \d Unicode-decimal.
    return regex_match_from_start("^[\\da-z_]{1,32}$", command)


def _command_slice(text: String, start: Int, end: Int) -> String:
    var result = String()
    var index = 0
    for character in text.codepoint_slices():
        if index >= start and index < end:
            result.write_string(character)
        index += 1
    return result^


def _command_split_at(value: String, separator: String) -> List[String]:
    var result = List[String]()
    var current = String()
    for character in value.codepoint_slices():
        if String(character) == separator:
            result.append(current.copy())
            current = String()
        else:
            current.write_string(character)
    result.append(current^)
    return result^


def _command_resolve_filter(filters: Optional[BaseFilter]) -> BaseFilter:
    if filters is None:
        return UpdateType.MESSAGES
    return filters.value().copy()


struct CommandHandler(Copyable):
    """Native command matching, argument filtering, and block-default behavior.

    The Mojo message model does not yet retain the Bot associated with a Message. Set the bot
    username after application initialization before matching commands addressed as ``/cmd@bot``.
    """

    comptime HAS_ARGS_ANY = 0
    comptime HAS_ARGS_NONEMPTY = 1
    comptime HAS_ARGS_EMPTY = 2
    comptime HAS_ARGS_EXACT = 3

    var base_handler: BaseHandler
    var commands: Set[String]
    var filters: BaseFilter
    var bot_username: Optional[String]
    var has_args_mode: Int
    var has_args_count: Int

    def __init__(
        out self,
        command: String,
        bot_username: Optional[String] = None,
        filters: Optional[BaseFilter] = None,
        has_args: Optional[Int] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        self.bot_username = bot_username.copy()
        self.has_args_mode = Self.HAS_ARGS_ANY
        self.has_args_count = 0
        self.filters = _command_resolve_filter(filters)
        self._add_command(command)
        if has_args is not None:
            self._set_exact_args(has_args.value())

    def __init__(
        out self,
        command: String,
        bot_username: Optional[String],
        filters: Optional[BaseFilter],
        has_args: Optional[Int],
        block: Bool,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        self.bot_username = bot_username.copy()
        self.has_args_mode = Self.HAS_ARGS_ANY
        self.has_args_count = 0
        self.filters = _command_resolve_filter(filters)
        self._add_command(command)
        if has_args is not None:
            self._set_exact_args(has_args.value())

    def __init__(
        out self,
        command: String,
        bot_username: Optional[String],
        filters: Optional[BaseFilter],
        has_args: Bool,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        self.bot_username = bot_username.copy()
        self.has_args_count = 0
        if has_args:
            self.has_args_mode = Self.HAS_ARGS_NONEMPTY
        else:
            self.has_args_mode = Self.HAS_ARGS_EMPTY
        self.filters = _command_resolve_filter(filters)
        self._add_command(command)

    def __init__(
        out self,
        command: String,
        bot_username: Optional[String],
        filters: Optional[BaseFilter],
        has_args: Bool,
        block: Bool,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        self.bot_username = bot_username.copy()
        self.has_args_count = 0
        if has_args:
            self.has_args_mode = Self.HAS_ARGS_NONEMPTY
        else:
            self.has_args_mode = Self.HAS_ARGS_EMPTY
        self.filters = _command_resolve_filter(filters)
        self._add_command(command)

    def __init__(
        out self,
        command_names: List[String],
        bot_username: Optional[String] = None,
        filters: Optional[BaseFilter] = None,
        has_args: Optional[Int] = None,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ) raises:
        self.base_handler = BaseHandler(block)
        self.commands = Set[String]()
        self.bot_username = bot_username.copy()
        self.has_args_mode = Self.HAS_ARGS_ANY
        self.has_args_count = 0
        self.filters = _command_resolve_filter(filters)
        for command in command_names:
            self._add_command(command)
        if has_args is not None:
            self._set_exact_args(has_args.value())

    def _add_command(mut self, command: String) raises:
        var normalized = command.lower()
        if not _command_is_valid(normalized):
            raise Error(String("Command `", normalized, "` is not a valid bot command"))
        _ = self.commands.insert(normalized^)

    def _set_exact_args(mut self, count: Int) raises:
        if count < 0:
            raise Error("CommandHandler argument has_args cannot be a negative integer")
        self.has_args_mode = Self.HAS_ARGS_EXACT
        self.has_args_count = count

    def set_bot_username(mut self, username: Optional[String]):
        """Attach the initialized application's bot username for targeted commands."""
        self.bot_username = username.copy()

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def _check_args(self, args: List[String]) -> Bool:
        if self.has_args_mode == Self.HAS_ARGS_ANY:
            return True
        if self.has_args_mode == Self.HAS_ARGS_NONEMPTY:
            return len(args) > 0
        if self.has_args_mode == Self.HAS_ARGS_EMPTY:
            return len(args) == 0
        return len(args) == self.has_args_count

    def check_update(self, update: Optional[Update]) raises -> CommandHandlerResult:
        """Check the first command entity, target bot, argument count, and message filters."""
        var empty_args = List[String]()
        if update is None:
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)

        var message_optional = update.value().effective_message()
        if message_optional is None:
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)
        var message = message_optional.value().copy()
        if len(message.entities) == 0 or message.text is None:
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)

        var first_entity = message.entities[0].copy()
        if (
            first_entity.type != "bot_command"
            or first_entity.offset != 0
            or message.text.value().byte_length() == 0
            or self.bot_username is None
        ):
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)

        var command = _command_slice(message.text.value(), 1, first_entity.length)
        var command_parts = _command_split_at(command, "@")
        var command_found = False
        if len(command_parts) > 0:
            var normalized_command = command_parts[0].lower()
            for allowed_command in self.commands:
                if normalized_command == allowed_command:
                    command_found = True
                    break
        if not command_found:
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)

        var target_username = self.bot_username.value().lower()
        if len(command_parts) > 1 and command_parts[1].lower() != target_username:
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)

        var all_words = _prefix_split_whitespace(message.text.value())
        var args = List[String]()
        for index in range(1, len(all_words)):
            args.append(all_words[index].copy())
        if not self._check_args(args):
            return CommandHandlerResult(CommandHandlerResult.NO_MATCH, empty_args)

        if not self.filters.check_update(update.value()):
            return CommandHandlerResult(CommandHandlerResult.FILTERED_OUT, empty_args)
        return CommandHandlerResult(CommandHandlerResult.MATCH, args)
