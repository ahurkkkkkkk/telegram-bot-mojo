from std.collections.optional import Optional
from std.testing import assert_equal

from telegram.error import (
    BadRequest,
    ChatMigrated,
    Conflict,
    EndPointNotFound,
    Forbidden,
    InvalidToken,
    NetworkError,
    PassportDecryptionError,
    RetryAfter,
    TelegramError,
    TimedOut,
)


def _raise_migrated() raises TelegramError -> Int:
    raise ChatMigrated(1234)


def _raise_retry_after() raises TelegramError -> Int:
    raise RetryAfter(12)


def main() raises:
    var generic = TelegramError("Bad Request: TEST MESSAGE")
    assert_equal(generic.message, "Test message")
    assert_equal(generic.to_string(), "Test message")
    assert_equal(generic.__repr__(), "TelegramError('Test message')")
    assert_equal(TelegramError("a'b").__repr__(), "TelegramError('a\\'b')")
    assert_equal(TelegramError("first\nsecond").__repr__(), "TelegramError('first\\nsecond')")

    var forbidden = Forbidden("[Error]: Access DENIED")
    assert_equal(forbidden.kind, TelegramError.FORBIDDEN)
    assert_equal(forbidden.message, "Access denied")
    assert_equal(forbidden.__repr__(), "Forbidden('Access denied')")

    assert_equal(InvalidToken().message, "Invalid token")
    assert_equal(NetworkError("Error: CONNECTION LOST").message, "Connection lost")
    assert_equal(BadRequest("Bad Request: BAD INPUT").message, "Bad input")
    assert_equal(TimedOut().message, "Timed out")
    assert_equal(TimedOut(Optional[String](String())).message, "Timed out")

    var migrated = ChatMigrated(-100123)
    assert_equal(migrated.new_chat_id, -100123)
    assert_equal(migrated.message, "Group migrated to supergroup. New chat id: -100123")

    var retry = RetryAfter(12)
    assert_equal(retry.retry_after, 12.0)
    assert_equal(retry.message, "Flood control exceeded. Retry in 12 seconds")
    var fractional_retry = RetryAfter(Float64(2.5))
    assert_equal(fractional_retry.retry_after, 2.5)

    assert_equal(Conflict("conflict").kind, TelegramError.CONFLICT)
    assert_equal(EndPointNotFound("unknown endpoint").kind, TelegramError.ENDPOINT_NOT_FOUND)
    var passport_error = PassportDecryptionError("bad key")
    assert_equal(passport_error.detail, "bad key")
    assert_equal(passport_error.message, "PassportDecryptionError: bad key")

    try:
        _ = _raise_migrated()
    except caught:
        assert_equal(caught.kind, TelegramError.CHAT_MIGRATED)
        assert_equal(caught.new_chat_id, 1234)

    try:
        _ = _raise_retry_after()
    except caught:
        assert_equal(caught.kind, TelegramError.RETRY_AFTER)
        assert_equal(caught.retry_after, 12.0)
