#!/usr/bin/env mojo
# Native StringCommandHandler predicate corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Match slash-prefixed string commands and retain their argument fields."""

from std.collections import List
from std.collections.optional import Optional

from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue
from telegram.ext._handlers.basehandler import BaseHandler


struct StringCommandHandler(Copyable):
    var command: String
    var base_handler: BaseHandler

    def __init__(
        out self,
        command: String,
        block: DefaultValue[Bool] = DEFAULT_TRUE,
    ):
        self.command = command.copy()
        self.base_handler = BaseHandler(block)

    def __init__(out self, command: String, block: Bool):
        self.command = command.copy()
        self.base_handler = BaseHandler(block)

    def resolve_block(self, application_default: Bool) -> Bool:
        return self.base_handler.resolve_block(application_default)

    def check_update(self, update: Optional[String]) -> Optional[List[String]]:
        """Return the text after a matching command split on literal spaces."""
        if update is None:
            return None

        var args = List[String]()
        var current = String()
        var saw_first_character = False
        for character in update.value().codepoint_slices():
            if not saw_first_character:
                saw_first_character = True
                if String(character) != "/":
                    return None
                continue
            if String(character) == " ":
                args.append(current.copy())
                current = String()
            else:
                current.write_string(character)
        if not saw_first_character:
            return None
        args.append(current)

        if len(args) == 0 or args[0] != self.command:
            return None
        var result = List[String]()
        for index in range(1, len(args)):
            result.append(args[index].copy())
        return Optional[List[String]](result^)
