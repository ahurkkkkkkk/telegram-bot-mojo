#!/usr/bin/env mojo
#
# Native HTTP transport corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""HTTP request transport implemented in Mojo over the system libcurl ABI."""

from std.collections import List
from std.collections.optional import Optional
from std.ffi import OwnedDLHandle
from std.memory import Pointer

from telegram.error import NetworkError, TelegramError
from telegram._utils.json import JsonDocument
from telegram.request._baserequest import (
    extract_post_result,
    handle_http_response,
    raise_response_error,
)
from telegram.request._requestdata import RequestData


def _curl_timeout_milliseconds(seconds: Optional[Float64]) -> Int64:
    if seconds is None:
        return 0
    var millis = seconds.value() * 1000.0
    if millis <= 0.0:
        return 0
    return Int64(millis)


struct NativeHttpResponse:
    var status_code: Int
    var body: List[UInt8]

    def __init__(out self, status_code: Int, body: List[UInt8]):
        self.status_code = status_code
        self.body = List[UInt8](copy=body)


struct HTTPXRequest(Copyable):
    """HTTP transport with the upstream timeout and protocol configuration surface.

    The first native implementation uses one curl easy handle per request. The
    libcurl runtime is loaded dynamically; no CPython or HTTPX package is used.
    """

    var connection_pool_size: Int
    var read_timeout: Optional[Float64]
    var write_timeout: Optional[Float64]
    var connect_timeout: Optional[Float64]
    var pool_timeout: Optional[Float64]
    var media_write_timeout: Optional[Float64]
    var http_version: String
    var is_closed: Bool

    def __init__(
        out self,
        connection_pool_size: Int = 256,
        read_timeout: Optional[Float64] = Optional[Float64](5.0),
        write_timeout: Optional[Float64] = Optional[Float64](5.0),
        connect_timeout: Optional[Float64] = Optional[Float64](5.0),
        pool_timeout: Optional[Float64] = Optional[Float64](1.0),
        http_version: String = "1.1",
        media_write_timeout: Optional[Float64] = Optional[Float64](20.0),
    ) raises:
        if connection_pool_size <= 0:
            raise Error("connection_pool_size must be greater than zero")
        if http_version != "1.1" and http_version != "2" and http_version != "2.0":
            raise Error("`http_version` must be either '1.1', '2.0' or '2'.")
        self.connection_pool_size = connection_pool_size
        self.read_timeout = read_timeout.copy()
        self.write_timeout = write_timeout.copy()
        self.connect_timeout = connect_timeout.copy()
        self.pool_timeout = pool_timeout.copy()
        self.media_write_timeout = media_write_timeout.copy()
        self.http_version = http_version.copy()
        self.is_closed = False

    def __copyinit__(out self, existing: Self):
        self.connection_pool_size = existing.connection_pool_size
        self.read_timeout = existing.read_timeout.copy()
        self.write_timeout = existing.write_timeout.copy()
        self.connect_timeout = existing.connect_timeout.copy()
        self.pool_timeout = existing.pool_timeout.copy()
        self.media_write_timeout = existing.media_write_timeout.copy()
        self.http_version = existing.http_version.copy()
        self.is_closed = existing.is_closed

    def initialize(mut self):
        self.is_closed = False

    def shutdown(mut self):
        self.is_closed = True

    def _do_request(
        self,
        url: String,
        method: String,
        request_data: Optional[RequestData] = None,
    ) raises -> NativeHttpResponse:
        if self.is_closed:
            raise Error("HTTPXRequest is not initialized")
        if method != "POST" and method != "GET":
            raise Error("Native HTTPXRequest currently supports GET and POST")
        var has_files = request_data is not None and request_data.value().contains_files
        if has_files and method != "POST":
            raise Error("Multipart file uploads require a POST request")

        var payload_text = String()
        if request_data is not None and method == "POST" and not has_files:
            payload_text = request_data.value().url_encoded_parameters()
        var url_text = url.copy()
        var c_url = url_text.as_c_string_span()
        var c_payload = payload_text.as_c_string_span()

        var curl_library = OwnedDLHandle("libcurl.so.4")
        var c_library = OwnedDLHandle("libc.so.6")
        var global_init = curl_library.get_function[Int32]("curl_global_init")
        var easy_init = curl_library.get_function[UInt]("curl_easy_init")
        var easy_cleanup = curl_library.get_function[NoneType]("curl_easy_cleanup")
        var easy_setopt = curl_library.get_function[Int32]("curl_easy_setopt")
        var easy_getinfo = curl_library.get_function[Int32]("curl_easy_getinfo")
        var easy_perform = curl_library.get_function[Int32]("curl_easy_perform")
        var mime_init = curl_library.get_function[UInt]("curl_mime_init")
        var mime_addpart = curl_library.get_function[UInt]("curl_mime_addpart")
        var mime_name = curl_library.get_function[Int32]("curl_mime_name")
        var mime_data = curl_library.get_function[Int32]("curl_mime_data")
        var mime_filename = curl_library.get_function[Int32]("curl_mime_filename")
        var mime_type = curl_library.get_function[Int32]("curl_mime_type")
        var mime_free = curl_library.get_function[NoneType]("curl_mime_free")
        var open_temp = c_library.get_function[UInt]("tmpfile")
        var close_file = c_library.get_function[Int32]("fclose")
        var seek_file = c_library.get_function[Int32]("fseek")
        var tell_file = c_library.get_function[Int64]("ftell")
        var get_byte = c_library.get_function[Int32]("fgetc")

        if global_init(3) != 0:
            raise NetworkError("libcurl global initialization failed")
        var handle = easy_init()
        if handle == 0:
            raise NetworkError("libcurl could not allocate an HTTP request handle")
        var response_file = open_temp()
        if response_file == 0:
            easy_cleanup(handle)
            raise NetworkError("Could not create a response buffer for libcurl")

        var option_status = easy_setopt(handle, 10002, c_url.ptr())
        var user_agent_text = String(
            "python-telegram-bot v22.8 (https://python-telegram-bot.org)"
        )
        var c_user_agent = user_agent_text.as_c_string_span()
        if option_status == 0:
            option_status = easy_setopt(handle, 10001, response_file)
        if option_status == 0:
            option_status = easy_setopt(handle, 10018, c_user_agent.ptr())
        if option_status == 0:
            option_status = easy_setopt(handle, 99, Int64(1))
        if option_status == 0:
            option_status = easy_setopt(handle, 64, Int64(1))
        if option_status == 0:
            option_status = easy_setopt(handle, 81, Int64(2))
        if option_status == 0:
            option_status = easy_setopt(handle, 52, Int64(1))

        var curl_http_version = Int64(2)
        if self.http_version == "2" or self.http_version == "2.0":
            curl_http_version = 4
        if option_status == 0:
            option_status = easy_setopt(handle, 84, curl_http_version)

        var connect_timeout_ms = _curl_timeout_milliseconds(self.connect_timeout)
        var total_timeout_ms = _curl_timeout_milliseconds(self.connect_timeout)
        total_timeout_ms += _curl_timeout_milliseconds(self.read_timeout)
        total_timeout_ms += _curl_timeout_milliseconds(self.write_timeout)
        if option_status == 0 and connect_timeout_ms > 0:
            option_status = easy_setopt(handle, 156, connect_timeout_ms)
        if option_status == 0 and total_timeout_ms > 0:
            option_status = easy_setopt(handle, 155, total_timeout_ms)
        if option_status == 0 and method == "POST":
            if not has_files:
                option_status = easy_setopt(handle, 47, Int64(1))
        if option_status == 0 and method == "POST" and not has_files:
            option_status = easy_setopt(handle, 10015, c_payload.ptr())
        if option_status == 0 and method == "POST" and not has_files:
            option_status = easy_setopt(handle, 30120, Int64(payload_text.byte_length()))
        var mime: UInt = 0
        if option_status == 0 and has_files:
            mime = mime_init(handle)
            if mime == 0:
                easy_cleanup(handle)
                _ = close_file(response_file)
                raise NetworkError("libcurl could not allocate a multipart request")
            var multipart_parts = request_data.value().multipart_form_data()
            for part in multipart_parts:
                var mime_part = mime_addpart(mime)
                if mime_part == 0:
                    mime_free(mime)
                    easy_cleanup(handle)
                    _ = close_file(response_file)
                    raise NetworkError("libcurl could not allocate a multipart field")
                var field_name = part.name.copy()
                var c_field_name = field_name.as_c_string_span()
                option_status = mime_name(mime_part, c_field_name.ptr())
                if option_status == 0 and part.is_file:
                    if len(part.field.content) == 0:
                        var empty = String()
                        var c_empty = empty.as_c_string_span()
                        option_status = mime_data(mime_part, c_empty.ptr(), UInt(0))
                    else:
                        var content = part.field.content.copy()
                        var content_ptr = content.unsafe_ptr().unsafe_bitcast[NoneType]()
                        option_status = mime_data(
                            mime_part, content_ptr, UInt(len(content))
                        )
                    if option_status == 0:
                        var filename = part.field.filename.copy()
                        var c_filename = filename.as_c_string_span()
                        option_status = mime_filename(mime_part, c_filename.ptr())
                    if option_status == 0:
                        var mimetype = part.field.mimetype.copy()
                        var c_mimetype = mimetype.as_c_string_span()
                        option_status = mime_type(mime_part, c_mimetype.ptr())
                elif option_status == 0:
                    var field_value = part.value.copy()
                    var c_field_value = field_value.as_c_string_span()
                    option_status = mime_data(
                        mime_part, c_field_value.ptr(), UInt(field_value.byte_length())
                    )
                if option_status != 0:
                    mime_free(mime)
                    easy_cleanup(handle)
                    _ = close_file(response_file)
                    raise NetworkError(
                        String("libcurl rejected a multipart field (code ", option_status, ")")
                    )
            option_status = easy_setopt(handle, 10269, mime)

        if option_status != 0:
            if mime != 0:
                mime_free(mime)
            easy_cleanup(handle)
            _ = close_file(response_file)
            raise NetworkError(String("libcurl rejected an HTTP option (code ", option_status, ")"))

        var perform_status = easy_perform(handle)
        var response_code = Int64(0)
        var info_status = easy_getinfo(handle, Int32(0x200002), Pointer(to=response_code))
        easy_cleanup(handle)
        if mime != 0:
            mime_free(mime)
        if info_status != 0:
            _ = close_file(response_file)
            raise NetworkError(String("libcurl could not read the HTTP status (code ", info_status, ")"))
        if perform_status != 0:
            _ = close_file(response_file)
            raise NetworkError(String("libcurl request failed (code ", perform_status, ")"))

        var seek_status = seek_file(response_file, Int64(0), Int32(0))
        if seek_status != 0:
            _ = close_file(response_file)
            raise NetworkError("libcurl response could not be read")
        var response = List[UInt8]()
        while True:
            var next_byte = get_byte(response_file)
            if next_byte < 0:
                break
            response.append(UInt8(next_byte))
        _ = close_file(response_file)
        return NativeHttpResponse(Int(response_code), response^)

    def do_request(
        self,
        url: String,
        method: String,
        request_data: Optional[RequestData] = None,
    ) raises -> Tuple[Int, List[UInt8]]:
        var response = self._do_request(url, method, request_data)
        return (response.status_code, List[UInt8](copy=response.body))

    def post(
        self,
        url: String,
        request_data: Optional[RequestData] = None,
    ) raises -> JsonDocument:
        var response = self._do_request(url, "POST", request_data)
        var outcome = handle_http_response(
            response.status_code, List[UInt8](copy=response.body)
        )
        if not outcome.is_success:
            raise_response_error(outcome)
        return extract_post_result(outcome.response)

    def retrieve(self, url: String) raises -> List[UInt8]:
        """Download a file response while preserving its raw bytes."""
        var response = self._do_request(url, "GET")
        if response.status_code >= 200 and response.status_code <= 299:
            return List[UInt8](copy=response.body)
        var outcome = handle_http_response(
            response.status_code, List[UInt8](copy=response.body)
        )
        if not outcome.is_success:
            raise_response_error(outcome)
        return List[UInt8]()
