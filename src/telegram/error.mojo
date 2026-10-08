#!/usr/bin/env mojo
#
# Native Telegram error values translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Error values and constructors for Telegram Bot API failures."""

from std.collections.optional import Optional
from std.io import Writer

from telegram._utils._unicode_case import _lowercase_character, _titlecase_character


def _has_prefix(value: String, prefix: String) -> Bool:
    if value.byte_length() < prefix.byte_length():
        return False
    for index in range(prefix.byte_length()):
        if value[byte=index] != prefix[byte=index]:
            return False
    return True


def _capitalize(value: String) -> String:
    var result = String()
    var first = True
    for character in value.codepoint_slices():
        if first:
            result.write_string(_titlecase_character(character))
            first = False
        else:
            result.write_string(_lowercase_character(character))
    return result^


def _normalized_message(message: String) -> String:
    var prefix: String
    if _has_prefix(message, "Error: "):
        prefix = "Error: "
    elif _has_prefix(message, "[Error]: "):
        prefix = "[Error]: "
    elif _has_prefix(message, "Bad Request: "):
        prefix = "Bad Request: "
    else:
        return message.copy()

    var stripped = String()
    var index = 0
    for character in message.codepoint_slices():
        if index >= prefix.byte_length():
            stripped.write_string(character)
        index += 1
    return _capitalize(stripped)


def _repr_string(value: String) -> String:
    var result = String()
    for character in value.codepoint_slices():
        if character == "\\":
            result.write_string("\\\\")
        elif character == "'":
            result.write_string("\\'")
        elif character == "\n":
            result.write_string("\\n")
        elif character == "\r":
            result.write_string("\\r")
        elif character == "\t":
            result.write_string("\\t")
        else:
            result.write_string(character)
    return result^


struct TelegramError(Copyable, Writable):
    """Tagged native error corresponding to the TelegramError hierarchy."""

    comptime GENERIC = 0
    comptime FORBIDDEN = 1
    comptime INVALID_TOKEN = 2
    comptime ENDPOINT_NOT_FOUND = 3
    comptime NETWORK = 4
    comptime BAD_REQUEST = 5
    comptime TIMED_OUT = 6
    comptime CHAT_MIGRATED = 7
    comptime RETRY_AFTER = 8
    comptime CONFLICT = 9
    comptime PASSPORT_DECRYPTION = 10

    var kind: Int
    var error_class: String
    var message: String
    var new_chat_id: Int
    var retry_after: Float64
    var has_retry_after: Bool
    var detail: String

    def __init__(out self, message: String):
        self.kind = Self.GENERIC
        self.error_class = "TelegramError"
        self.message = _normalized_message(message)
        self.new_chat_id = 0
        self.retry_after = 0.0
        self.has_retry_after = False
        self.detail = String()

    def __copyinit__(out self, existing: Self):
        self.kind = existing.kind
        self.error_class = existing.error_class.copy()
        self.message = existing.message.copy()
        self.new_chat_id = existing.new_chat_id
        self.retry_after = existing.retry_after
        self.has_retry_after = existing.has_retry_after
        self.detail = existing.detail.copy()

    def write_to(self, mut writer: Some[Writer]):
        writer.write(self.message)

    def __repr__(self) -> String:
        return String(self.error_class, "('", _repr_string(self.message), "')")

    def to_string(self) -> String:
        return self.message.copy()


def _make_error(kind: Int, class_name: String, message: String) -> TelegramError:
    var error = TelegramError(message)
    error.kind = kind
    error.error_class = class_name
    return error^


def Forbidden(message: String) -> TelegramError:
    return _make_error(TelegramError.FORBIDDEN, "Forbidden", message)


def InvalidToken(message: Optional[String] = None) -> TelegramError:
    if message is None:
        return _make_error(TelegramError.INVALID_TOKEN, "InvalidToken", "Invalid token")
    return _make_error(TelegramError.INVALID_TOKEN, "InvalidToken", message.value())


def EndPointNotFound(message: String) -> TelegramError:
    return _make_error(TelegramError.ENDPOINT_NOT_FOUND, "EndPointNotFound", message)


def NetworkError(message: String) -> TelegramError:
    return _make_error(TelegramError.NETWORK, "NetworkError", message)


def BadRequest(message: String) -> TelegramError:
    return _make_error(TelegramError.BAD_REQUEST, "BadRequest", message)


def TimedOut(message: Optional[String] = None) -> TelegramError:
    if message is None or message.value().byte_length() == 0:
        return _make_error(TelegramError.TIMED_OUT, "TimedOut", "Timed out")
    return _make_error(TelegramError.TIMED_OUT, "TimedOut", message.value())


def ChatMigrated(new_chat_id: Int) -> TelegramError:
    var error = _make_error(
        TelegramError.CHAT_MIGRATED,
        "ChatMigrated",
        String("Group migrated to supergroup. New chat id: ", new_chat_id),
    )
    error.new_chat_id = new_chat_id
    return error^


def RetryAfter(seconds: Int) -> TelegramError:
    var error = _make_error(
        TelegramError.RETRY_AFTER,
        "RetryAfter",
        String("Flood control exceeded. Retry in ", seconds, " seconds"),
    )
    error.retry_after = Float64(seconds)
    error.has_retry_after = True
    return error^


def RetryAfter(seconds: Float64) -> TelegramError:
    var error = _make_error(
        TelegramError.RETRY_AFTER,
        "RetryAfter",
        String("Flood control exceeded. Retry in ", seconds, " seconds"),
    )
    error.retry_after = seconds
    error.has_retry_after = True
    return error^


def Conflict(message: String) -> TelegramError:
    return _make_error(TelegramError.CONFLICT, "Conflict", message)


def PassportDecryptionError(message: String) -> TelegramError:
    var error = _make_error(
        TelegramError.PASSPORT_DECRYPTION,
        "PassportDecryptionError",
        String("PassportDecryptionError: ", message),
    )
    error.detail = message.copy()
    return error^
