#!/usr/bin/env mojo
#
# Native request collection and encoding corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Collects Bot API parameter values and multipart upload parts."""

from std.collections import List
from std.collections.optional import Optional

from telegram._utils.json import JSON_NULL, JsonDocument, dumps_json
from telegram.request._requestparameter import MultipartPart, RequestParameter


def _hex_digit(value: Int) -> String:
    if value == 0:
        return "0"
    if value == 1:
        return "1"
    if value == 2:
        return "2"
    if value == 3:
        return "3"
    if value == 4:
        return "4"
    if value == 5:
        return "5"
    if value == 6:
        return "6"
    if value == 7:
        return "7"
    if value == 8:
        return "8"
    if value == 9:
        return "9"
    if value == 10:
        return "A"
    if value == 11:
        return "B"
    if value == 12:
        return "C"
    if value == 13:
        return "D"
    if value == 14:
        return "E"
    return "F"


def _url_encode_component(value: String) -> String:
    var result = String()
    for byte in value.as_bytes():
        if (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) or (byte >= 48 and byte <= 57):
            result += chr(Int(byte))
        elif byte == 45 or byte == 95 or byte == 46 or byte == 126:
            result += chr(Int(byte))
        elif byte == 32:
            result += "+"
        else:
            result += "%"
            result += _hex_digit(Int(byte) // 16)
            result += _hex_digit(Int(byte) % 16)
    return result


struct RequestData(Copyable):
    """Parameters and uploads for one Bot API request."""

    var _parameters: List[RequestParameter]
    var contains_files: Bool

    def __init__(out self):
        self._parameters = List[RequestParameter]()
        self.contains_files = False

    def __init__(out self, parameters: List[RequestParameter]):
        self._parameters = List[RequestParameter](copy=parameters)
        self.contains_files = False
        for parameter in self._parameters:
            if len(parameter.input_files) > 0:
                self.contains_files = True

    def __copyinit__(out self, existing: Self):
        self._parameters = List[RequestParameter](copy=existing._parameters)
        self.contains_files = existing.contains_files

    def parameters(self) raises -> JsonDocument:
        var result = JsonDocument()
        result.root = result.add_object()
        for parameter in self._parameters:
            if parameter.value is None:
                continue
            var value_document = parameter.value.value().copy()
            if value_document.nodes[value_document.root].kind == JSON_NULL:
                continue
            var value_node = result.copy_subtree_from(value_document.copy(), value_document.root)
            result.object_set(result.root, parameter.name.copy(), value_node)
        return result^

    def json_parameters(self) raises -> JsonDocument:
        var result = JsonDocument()
        result.root = result.add_object()
        for parameter in self._parameters:
            var encoded = parameter.json_value()
            if encoded is not None:
                result.set_string(result.root, parameter.name, encoded.value())
        return result^

    def url_encoded_parameters(self) raises -> String:
        var result = String()
        var first = True
        for parameter in self._parameters:
            var encoded = parameter.json_value()
            if encoded is None:
                continue
            if not first:
                result += "&"
            first = False
            result += _url_encode_component(parameter.name)
            result += "="
            result += _url_encode_component(encoded.value())
        return result

    def parametrized_url(self, url: String) raises -> String:
        return String(url, "?", self.url_encoded_parameters())

    def json_payload(self) raises -> List[UInt8]:
        var encoded = dumps_json(self.json_parameters())
        var result = List[UInt8]()
        for byte in encoded.as_bytes():
            result.append(byte)
        return result^

    def multipart_data(self) -> List[MultipartPart]:
        var result = List[MultipartPart]()
        for parameter in self._parameters:
            for candidate in parameter.multipart_data():
                var found = False
                for index in range(len(result)):
                    if result[index].name == candidate.name:
                        result[index] = candidate.copy()
                        found = True
                        break
                if not found:
                    result.append(candidate.copy())
        return result^

    def multipart_form_data(self) raises -> List[MultipartPart]:
        """Return form fields and file parts for a multipart HTTP request."""
        var result = List[MultipartPart]()
        for parameter in self._parameters:
            var encoded = parameter.json_value()
            if encoded is not None:
                result.append(MultipartPart(parameter.name, encoded.value()))
            for candidate in parameter.multipart_data():
                var found = False
                for index in range(len(result)):
                    if result[index].is_file and result[index].name == candidate.name:
                        result[index] = candidate.copy()
                        found = True
                        break
                if not found:
                    result.append(candidate.copy())
        return result^
