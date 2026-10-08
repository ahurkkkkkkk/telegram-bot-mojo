#!/usr/bin/env mojo
#
# Native HTTP response handling corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Parse Telegram HTTP responses and map API failures into Telegram errors."""

from std.collections import List
from std.collections.optional import Optional

from telegram.error import (
    BadRequest,
    ChatMigrated,
    Conflict,
    Forbidden,
    InvalidToken,
    NetworkError,
    RetryAfter,
    TelegramError,
)
from telegram._utils.json import JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json, parse_json


def _status_phrase(status_code: Int) -> String:
    if status_code == 400:
        return "Bad Request"
    if status_code == 401:
        return "Unauthorized"
    if status_code == 403:
        return "Forbidden"
    if status_code == 404:
        return "Not Found"
    if status_code == 408:
        return "Request Timeout"
    if status_code == 409:
        return "Conflict"
    if status_code == 413:
        return "Payload Too Large"
    if status_code == 429:
        return "Too Many Requests"
    if status_code == 500:
        return "Internal Server Error"
    if status_code == 501:
        return "Not Implemented"
    if status_code == 502:
        return "Bad Gateway"
    if status_code == 503:
        return "Service Unavailable"
    if status_code == 504:
        return "Gateway Timeout"
    return "Unknown HTTPError"


def parse_json_payload(payload: List[UInt8]) raises -> JsonDocument:
    """Decode a UTF-8 response body as JSON, replacing invalid UTF-8 bytes."""
    var decoded = String(from_utf8_lossy=Span(payload))
    try:
        return parse_json(decoded)
    except:
        raise TelegramError("Invalid server response")


def _subdocument(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


struct HttpResponseOutcome(Copyable):
    """Successful JSON response or a Telegram API error value."""

    var is_success: Bool
    var response: JsonDocument
    var error: Optional[TelegramError]

    def __init__(out self, response: JsonDocument):
        self.is_success = True
        self.response = response.copy()
        self.error = None

    def __init__(out self, error: TelegramError):
        self.is_success = False
        self.response = JsonDocument()
        self.error = Optional[TelegramError](error.copy())

    def __copyinit__(out self, existing: Self):
        self.is_success = existing.is_success
        self.response = existing.response.copy()
        if existing.error is None:
            self.error = None
        else:
            self.error = Optional[TelegramError](existing.error.value().copy())


def _retry_after(data: JsonDocument, index: Int) raises -> TelegramError:
    var number = data.number_text(index)
    var has_decimal = False
    for byte in number.as_bytes():
        if byte == 46 or byte == 101 or byte == 69:
            has_decimal = True
    if has_decimal:
        return RetryAfter(atof(number))
    return RetryAfter(data.integer_value(index))


def handle_http_response(
    status_code: Int, payload: List[UInt8]
) raises -> HttpResponseOutcome:
    """Parse a response into success data or its source-mapped error value."""
    if status_code >= 200 and status_code <= 299:
        try:
            return HttpResponseOutcome(parse_json_payload(payload))
        except:
            return HttpResponseOutcome(TelegramError("Invalid server response"))

    var message = String(_status_phrase(status_code), " (", status_code, ")")
    var response_data = JsonDocument()
    var parsed = False
    var payload_text = String(from_utf8_lossy=Span(payload))
    try:
        response_data = parse_json(payload_text)
        parsed = True
    except:
        message += String(". Parsing the server response ", payload_text, " failed")

    if parsed and response_data.root >= 0 and response_data.root < len(response_data.nodes):
        if response_data.nodes[response_data.root].kind == JSON_OBJECT:
            var description_index = response_data.object_get(response_data.root, "description")
            if description_index != -1 and not response_data.is_null(description_index):
                if response_data.nodes[description_index].kind == JSON_STRING:
                    var description = response_data.string_value(description_index)
                    if description.byte_length() > 0:
                        message = description

            var parameters_index = response_data.object_get(response_data.root, "parameters")
            if (
                parameters_index != -1
                and response_data.nodes[parameters_index].kind == JSON_OBJECT
            ):
                var migrate_index = response_data.object_get(
                    parameters_index, "migrate_to_chat_id"
                )
                if migrate_index != -1 and not response_data.is_null(migrate_index):
                    var new_chat_id = response_data.integer_value(migrate_index)
                    if new_chat_id != 0:
                        return HttpResponseOutcome(ChatMigrated(new_chat_id))

                var retry_index = response_data.object_get(parameters_index, "retry_after")
                if retry_index != -1 and not response_data.is_null(retry_index):
                    var retry_value = response_data.number_text(retry_index)
                    if retry_value != "0" and retry_value != "0.0":
                        return HttpResponseOutcome(_retry_after(response_data, retry_index))

                if response_data.child_count(parameters_index) > 0:
                    message += String(
                        ". The server response contained unknown parameters: ",
                        dumps_json(_subdocument(response_data, parameters_index)),
                    )

    if status_code == 403:
        return HttpResponseOutcome(Forbidden(message))
    if status_code == 401 or status_code == 404:
        return HttpResponseOutcome(InvalidToken(Optional[String](message)))
    if status_code == 400:
        return HttpResponseOutcome(BadRequest(message))
    if status_code == 409:
        return HttpResponseOutcome(Conflict(message))
    return HttpResponseOutcome(NetworkError(message))


def raise_response_error(outcome: HttpResponseOutcome) raises TelegramError:
    """Raise the tagged error stored in a failed response outcome."""
    if outcome.error is not None:
        raise outcome.error.value().copy()


def extract_post_result(response: JsonDocument) raises -> JsonDocument:
    """Return the Bot API ``result`` member from a successful response object."""
    if response.root < 0 or response.root >= len(response.nodes):
        raise TelegramError("Invalid server response")
    if response.nodes[response.root].kind != JSON_OBJECT:
        raise TelegramError("Invalid server response")
    var result_index = response.object_get(response.root, "result")
    if result_index == -1:
        raise TelegramError("Invalid server response")
    return _subdocument(response, result_index)
