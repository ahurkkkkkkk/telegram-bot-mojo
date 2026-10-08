#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This file is derived from python-telegram-bot v22.8, distributed under
# the GNU Lesser General Public License version 3. See LICENSE.

"""A command and description that can be assigned to a Telegram bot."""

from telegram import constants
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher


struct BotCommand(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A bot command; equality uses both command text and description."""

    var command: String
    var description: String
    var api_kwargs: JsonDocument

    comptime MIN_COMMAND = constants.BotCommandLimit.MIN_COMMAND.value
    comptime MAX_COMMAND = constants.BotCommandLimit.MAX_COMMAND.value
    comptime MIN_DESCRIPTION = constants.BotCommandLimit.MIN_DESCRIPTION.value
    comptime MAX_DESCRIPTION = constants.BotCommandLimit.MAX_DESCRIPTION.value

    def __init__(out self, command: String, description: String):
        self.command = command
        self.description = description
        self.api_kwargs = empty_json_object()

    def __init__(out self, command: String, description: String, api_kwargs: JsonDocument):
        self.command = command
        self.description = description
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.command = existing.command.copy()
        self.description = existing.description.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.command == other.command and self.description == other.description

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.command.as_bytes())
        var separator = String("\0")
        hasher.update(separator.as_bytes())
        hasher.update(self.description.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "command", self.command)
        result.set_string(result.root, "description", self.description)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BotCommand JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BotCommand JSON value is not an object")
        var command_index = data.object_get(data.root, "command")
        var description_index = data.object_get(data.root, "description")
        if command_index == -1 or description_index == -1:
            raise Error("BotCommand JSON object is missing a required field")
        var command = data.string_value(command_index)
        var description = data.string_value(description_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "command" and key != "description":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return BotCommand(command, description, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(BotCommand.de_json(items[index].copy()))
        return result^
