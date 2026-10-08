#!/usr/bin/env mojo
#
# Native JSON support for the Mojo port of python-telegram-bot v22.8.
# Copyright (C) 2015-2026 Leandro Toledo de Souza and contributors.
# Licensed under LGPL-3.0-or-later; see LICENSE.

"""A UTF-8 JSON parser and writer backed by an indexed native Mojo tree."""

comptime JSON_NULL = 0
comptime JSON_BOOL = 1
comptime JSON_NUMBER = 2
comptime JSON_STRING = 3
comptime JSON_ARRAY = 4
comptime JSON_OBJECT = 5


@fieldwise_init
struct JsonNode(Copyable, ImplicitlyCopyable):
    var kind: Int
    var text: String
    var boolean: Bool
    var name: String
    var first_child: Int
    var last_child: Int
    var next_sibling: Int


struct JsonDocument(Copyable):
    """JSON data stored in a flat arena with child/sibling links."""

    var nodes: List[JsonNode]
    var root: Int

    def __init__(out self):
        self.nodes = List[JsonNode]()
        self.root = -1

    def __copyinit__(out self, existing: Self):
        self.nodes = existing.nodes.copy()
        self.root = existing.root

    def add_node(mut self, node: JsonNode) -> Int:
        var index = len(self.nodes)
        self.nodes.append(node)
        return index

    def add_null(mut self) -> Int:
        return self.add_node(_node(JSON_NULL))

    def add_boolean(mut self, value: Bool) -> Int:
        return self.add_node(_node(JSON_BOOL, String(), value))

    def add_number(mut self, value: String) -> Int:
        return self.add_node(_node(JSON_NUMBER, value))

    def add_string(mut self, value: String) -> Int:
        return self.add_node(_node(JSON_STRING, value))

    def add_array(mut self) -> Int:
        return self.add_node(_node(JSON_ARRAY))

    def add_object(mut self) -> Int:
        return self.add_node(_node(JSON_OBJECT))

    def set_root(mut self, index: Int) raises:
        if index < 0 or index >= len(self.nodes):
            raise Error("JSON root index out of range")
        self.root = index

    def set_string(mut self, object_index: Int, key: String, value: String) raises:
        var child = self.add_string(value)
        self.object_set(object_index, key, child)

    def set_number(mut self, object_index: Int, key: String, value: String) raises:
        var child = self.add_number(value)
        self.object_set(object_index, key, child)

    def set_boolean(mut self, object_index: Int, key: String, value: Bool) raises:
        var child = self.add_boolean(value)
        self.object_set(object_index, key, child)

    def set_null(mut self, object_index: Int, key: String) raises:
        var child = self.add_null()
        self.object_set(object_index, key, child)

    def copy_subtree_from(mut self, source: JsonDocument, source_index: Int, depth: Int = 0) raises -> Int:
        if depth > 1024:
            raise Error("JSON nesting depth exceeds 1024")
        if source_index < 0 or source_index >= len(source.nodes):
            raise Error("JSON node index out of range")
        var source_node = source.nodes[source_index]
        var copied_node = source_node.copy()
        copied_node.first_child = -1
        copied_node.last_child = -1
        copied_node.next_sibling = -1
        var destination_index = self.add_node(copied_node)
        var child = source_node.first_child
        while child != -1:
            var copied_child = self.copy_subtree_from(source, child, depth + 1)
            self.nodes[copied_child].name = source.nodes[child].name.copy()
            self.append_child(destination_index, copied_child)
            child = source.nodes[child].next_sibling
        return destination_index

    def merge_object(mut self, target: Int, source: JsonDocument, source_index: Int) raises:
        if target < 0 or target >= len(self.nodes) or self.nodes[target].kind != JSON_OBJECT:
            raise Error("JSON merge target is not an object")
        if source_index < 0 or source_index >= len(source.nodes) or source.nodes[source_index].kind != JSON_OBJECT:
            raise Error("JSON merge source is not an object")
        var child = source.nodes[source_index].first_child
        while child != -1:
            var copied_child = self.copy_subtree_from(source, child)
            self.object_set(target, source.nodes[child].name.copy(), copied_child)
            child = source.nodes[child].next_sibling

    def append_child(mut self, parent: Int, child: Int) raises:
        if parent < 0 or parent >= len(self.nodes):
            raise Error("JSON parent index out of range")
        if child < 0 or child >= len(self.nodes):
            raise Error("JSON child index out of range")
        if self.nodes[parent].first_child == -1:
            self.nodes[parent].first_child = child
        else:
            var previous = self.nodes[parent].last_child
            self.nodes[previous].next_sibling = child
        self.nodes[parent].last_child = child

    def object_set(mut self, object_index: Int, key: String, child: Int) raises:
        """Insert or replace an object member while retaining first-insertion order."""
        if object_index < 0 or object_index >= len(self.nodes):
            raise Error("JSON object index out of range")
        if self.nodes[object_index].kind != JSON_OBJECT:
            raise Error("JSON value is not an object")
        if child < 0 or child >= len(self.nodes):
            raise Error("JSON child index out of range")
        var existing = self.object_get(object_index, key)
        if existing == -1:
            self.nodes[child].name = key
            self.append_child(object_index, child)
            return
        var replacement = self.nodes[child].copy()
        replacement.name = key
        replacement.next_sibling = self.nodes[existing].next_sibling
        self.nodes[existing] = replacement

    def object_get(self, object_index: Int, key: String) raises -> Int:
        if object_index < 0 or object_index >= len(self.nodes):
            raise Error("JSON object index out of range")
        if self.nodes[object_index].kind != JSON_OBJECT:
            raise Error("JSON value is not an object")
        var child = self.nodes[object_index].first_child
        while child != -1:
            if self.nodes[child].name == key:
                return child
            child = self.nodes[child].next_sibling
        return -1

    def array_get(self, array_index: Int, item_index: Int) raises -> Int:
        if array_index < 0 or array_index >= len(self.nodes):
            raise Error("JSON array index out of range")
        if self.nodes[array_index].kind != JSON_ARRAY:
            raise Error("JSON value is not an array")
        if item_index < 0:
            raise Error("JSON array index out of range")
        var child = self.nodes[array_index].first_child
        var position = 0
        while child != -1:
            if position == item_index:
                return child
            position += 1
            child = self.nodes[child].next_sibling
        raise Error("JSON array index out of range")

    def array_documents(self, array_index: Int) raises -> List[JsonDocument]:
        if array_index < 0 or array_index >= len(self.nodes):
            raise Error("JSON array index out of range")
        if self.nodes[array_index].kind != JSON_ARRAY:
            raise Error("JSON value is not an array")
        var result = List[JsonDocument]()
        var child = self.nodes[array_index].first_child
        while child != -1:
            var element = JsonDocument()
            element.root = element.copy_subtree_from(self, child)
            result.append(element^)
            child = self.nodes[child].next_sibling
        return result^

    def child_count(self, parent: Int) raises -> Int:
        if parent < 0 or parent >= len(self.nodes):
            raise Error("JSON parent index out of range")
        var count = 0
        var child = self.nodes[parent].first_child
        while child != -1:
            count += 1
            child = self.nodes[child].next_sibling
        return count

    def string_value(self, index: Int) raises -> String:
        if index < 0 or index >= len(self.nodes):
            raise Error("JSON node index out of range")
        if self.nodes[index].kind != JSON_STRING:
            raise Error("JSON value is not a string")
        return self.nodes[index].text.copy()

    def number_text(self, index: Int) raises -> String:
        if index < 0 or index >= len(self.nodes):
            raise Error("JSON node index out of range")
        if self.nodes[index].kind != JSON_NUMBER:
            raise Error("JSON value is not a number")
        return self.nodes[index].text.copy()

    def boolean_value(self, index: Int) raises -> Bool:
        if index < 0 or index >= len(self.nodes):
            raise Error("JSON node index out of range")
        if self.nodes[index].kind != JSON_BOOL:
            raise Error("JSON value is not a Boolean")
        return self.nodes[index].boolean

    def integer_value(self, index: Int) raises -> Int:
        if index < 0 or index >= len(self.nodes):
            raise Error("JSON node index out of range")
        if self.nodes[index].kind != JSON_NUMBER:
            raise Error("JSON value is not a number")
        var text = self.nodes[index].text
        var position = 0
        var sign = 1
        if text[byte=0] == "-":
            sign = -1
            position = 1
        var value = 0
        while position < text.byte_length():
            var byte = text.as_bytes()[position]
            if byte < 0x30 or byte > 0x39:
                raise Error("JSON number is not an integer")
            value = value * 10 + Int(byte - 0x30)
            position += 1
        return sign * value

    def is_null(self, index: Int) raises -> Bool:
        if index < 0 or index >= len(self.nodes):
            raise Error("JSON node index out of range")
        return self.nodes[index].kind == JSON_NULL

    def to_json(self, compact: Bool = False, ensure_ascii: Bool = True) raises -> String:
        if self.root < 0 or self.root >= len(self.nodes):
            raise Error("JSON document has no root value")
        var result = String()
        _write_node(result, self, self.root, compact, ensure_ascii, 0)
        return result


def _node(kind: Int, text: String = String(), boolean: Bool = False) -> JsonNode:
    return JsonNode(kind, text, boolean, String(), -1, -1, -1)


struct _Parser:
    var bytes: List[UInt8]
    var position: Int
    var document: JsonDocument

    def __init__(out self, source: String):
        self.bytes = List[UInt8]()
        for byte in source.as_bytes():
            self.bytes.append(byte)
        self.position = 0
        self.document = JsonDocument()

    def _skip_whitespace(mut self):
        while self.position < len(self.bytes):
            var byte = self.bytes[self.position]
            if byte == 0x20 or byte == 0x09 or byte == 0x0A or byte == 0x0D:
                self.position += 1
            else:
                return

    def _expect(mut self, expected: UInt8) raises:
        if self.position >= len(self.bytes) or self.bytes[self.position] != expected:
            raise Error("invalid JSON syntax")
        self.position += 1

    def _hex_digit(self, byte: UInt8) raises -> Int:
        if byte >= 0x30 and byte <= 0x39:
            return Int(byte - 0x30)
        if byte >= 0x41 and byte <= 0x46:
            return Int(byte - 0x41 + 10)
        if byte >= 0x61 and byte <= 0x66:
            return Int(byte - 0x61 + 10)
        raise Error("invalid hexadecimal digit in JSON string escape")

    def _hex_quad(mut self) raises -> Int:
        var result = 0
        for _ in range(4):
            if self.position >= len(self.bytes):
                raise Error("incomplete Unicode escape in JSON string")
            result = result * 16 + self._hex_digit(self.bytes[self.position])
            self.position += 1
        return result

    def _append_utf8(mut self, mut out_bytes: List[UInt8], codepoint: Int):
        if codepoint <= 0x7F:
            out_bytes.append(UInt8(codepoint))
        elif codepoint <= 0x7FF:
            out_bytes.append(UInt8(0xC0 | (codepoint >> 6)))
            out_bytes.append(UInt8(0x80 | (codepoint & 0x3F)))
        elif codepoint <= 0xFFFF:
            out_bytes.append(UInt8(0xE0 | (codepoint >> 12)))
            out_bytes.append(UInt8(0x80 | ((codepoint >> 6) & 0x3F)))
            out_bytes.append(UInt8(0x80 | (codepoint & 0x3F)))
        else:
            out_bytes.append(UInt8(0xF0 | (codepoint >> 18)))
            out_bytes.append(UInt8(0x80 | ((codepoint >> 12) & 0x3F)))
            out_bytes.append(UInt8(0x80 | ((codepoint >> 6) & 0x3F)))
            out_bytes.append(UInt8(0x80 | (codepoint & 0x3F)))

    def _parse_string(mut self) raises -> String:
        self._expect(0x22)
        var result = List[UInt8]()
        while self.position < len(self.bytes):
            var byte = self.bytes[self.position]
            self.position += 1
            if byte == 0x22:
                return String(from_utf8=result)
            if byte < 0x20:
                raise Error("unescaped control character in JSON string")
            if byte != 0x5C:
                result.append(byte)
                continue
            if self.position >= len(self.bytes):
                raise Error("incomplete escape in JSON string")
            var escaped = self.bytes[self.position]
            self.position += 1
            if escaped == 0x22 or escaped == 0x5C or escaped == 0x2F:
                result.append(escaped)
            elif escaped == 0x62:
                result.append(UInt8(0x08))
            elif escaped == 0x66:
                result.append(UInt8(0x0C))
            elif escaped == 0x6E:
                result.append(UInt8(0x0A))
            elif escaped == 0x72:
                result.append(UInt8(0x0D))
            elif escaped == 0x74:
                result.append(UInt8(0x09))
            elif escaped == 0x75:
                var codepoint = self._hex_quad()
                if codepoint >= 0xD800 and codepoint <= 0xDBFF:
                    if self.position + 2 > len(self.bytes):
                        raise Error("missing low surrogate in JSON string")
                    if self.bytes[self.position] != 0x5C or self.bytes[self.position + 1] != 0x75:
                        raise Error("missing low surrogate in JSON string")
                    self.position += 2
                    var low = self._hex_quad()
                    if low < 0xDC00 or low > 0xDFFF:
                        raise Error("invalid low surrogate in JSON string")
                    codepoint = 0x10000 + ((codepoint - 0xD800) << 10) + (low - 0xDC00)
                elif codepoint >= 0xDC00 and codepoint <= 0xDFFF:
                    raise Error("unexpected low surrogate in JSON string")
                self._append_utf8(result, codepoint)
            else:
                raise Error("invalid escape in JSON string")
        raise Error("unterminated JSON string")

    def _parse_number(mut self) raises -> Int:
        var encoded = List[UInt8]()
        if self.bytes[self.position] == 0x2D:
            encoded.append(self.bytes[self.position])
            self.position += 1
            if self.position >= len(self.bytes):
                raise Error("incomplete JSON number")
        if self.bytes[self.position] == 0x30:
            encoded.append(self.bytes[self.position])
            self.position += 1
            if self.position < len(self.bytes) and self.bytes[self.position] >= 0x30 and self.bytes[self.position] <= 0x39:
                raise Error("leading zero in JSON number")
        elif self.bytes[self.position] >= 0x31 and self.bytes[self.position] <= 0x39:
            while self.position < len(self.bytes) and self.bytes[self.position] >= 0x30 and self.bytes[self.position] <= 0x39:
                encoded.append(self.bytes[self.position])
                self.position += 1
        else:
            raise Error("invalid JSON number")
        if self.position < len(self.bytes) and self.bytes[self.position] == 0x2E:
            encoded.append(self.bytes[self.position])
            self.position += 1
            if self.position >= len(self.bytes) or self.bytes[self.position] < 0x30 or self.bytes[self.position] > 0x39:
                raise Error("invalid fraction in JSON number")
            while self.position < len(self.bytes) and self.bytes[self.position] >= 0x30 and self.bytes[self.position] <= 0x39:
                encoded.append(self.bytes[self.position])
                self.position += 1
        if self.position < len(self.bytes) and (self.bytes[self.position] == 0x45 or self.bytes[self.position] == 0x65):
            encoded.append(self.bytes[self.position])
            self.position += 1
            if self.position < len(self.bytes) and (self.bytes[self.position] == 0x2B or self.bytes[self.position] == 0x2D):
                encoded.append(self.bytes[self.position])
                self.position += 1
            if self.position >= len(self.bytes) or self.bytes[self.position] < 0x30 or self.bytes[self.position] > 0x39:
                raise Error("invalid exponent in JSON number")
            while self.position < len(self.bytes) and self.bytes[self.position] >= 0x30 and self.bytes[self.position] <= 0x39:
                encoded.append(self.bytes[self.position])
                self.position += 1
        var node = _node(JSON_NUMBER, String(from_utf8=encoded))
        return self.document.add_node(node)

    def _parse_literal(mut self, literal: StaticString, kind: Int, boolean: Bool = False) raises -> Int:
        for byte in literal.as_bytes():
            if self.position >= len(self.bytes) or self.bytes[self.position] != byte:
                raise Error("invalid JSON literal")
            self.position += 1
        var node = _node(kind, String(), boolean)
        return self.document.add_node(node)

    def _parse_array(mut self, depth: Int) raises -> Int:
        self._expect(0x5B)
        var index = self.document.add_node(_node(JSON_ARRAY))
        self._skip_whitespace()
        if self.position < len(self.bytes) and self.bytes[self.position] == 0x5D:
            self.position += 1
            return index
        while True:
            var child = self._parse_value(depth + 1)
            self.document.append_child(index, child)
            self._skip_whitespace()
            if self.position >= len(self.bytes):
                raise Error("unterminated JSON array")
            var delimiter = self.bytes[self.position]
            self.position += 1
            if delimiter == 0x5D:
                return index
            if delimiter != 0x2C:
                raise Error("expected comma or closing bracket in JSON array")
            self._skip_whitespace()

    def _parse_object(mut self, depth: Int) raises -> Int:
        self._expect(0x7B)
        var index = self.document.add_node(_node(JSON_OBJECT))
        self._skip_whitespace()
        if self.position < len(self.bytes) and self.bytes[self.position] == 0x7D:
            self.position += 1
            return index
        while True:
            if self.position >= len(self.bytes) or self.bytes[self.position] != 0x22:
                raise Error("JSON object key must be a string")
            var key = self._parse_string()
            self._skip_whitespace()
            self._expect(0x3A)
            self._skip_whitespace()
            var child = self._parse_value(depth + 1)
            self.document.object_set(index, key, child)
            self._skip_whitespace()
            if self.position >= len(self.bytes):
                raise Error("unterminated JSON object")
            var delimiter = self.bytes[self.position]
            self.position += 1
            if delimiter == 0x7D:
                return index
            if delimiter != 0x2C:
                raise Error("expected comma or closing brace in JSON object")
            self._skip_whitespace()

    def _parse_value(mut self, depth: Int) raises -> Int:
        if depth > 1024:
            raise Error("JSON nesting depth exceeds 1024")
        self._skip_whitespace()
        if self.position >= len(self.bytes):
            raise Error("unexpected end of JSON input")
        var byte = self.bytes[self.position]
        if byte == 0x22:
            var node = _node(JSON_STRING, self._parse_string())
            return self.document.add_node(node)
        if byte == 0x7B:
            return self._parse_object(depth)
        if byte == 0x5B:
            return self._parse_array(depth)
        if byte == 0x74:
            return self._parse_literal("true", JSON_BOOL, True)
        if byte == 0x66:
            return self._parse_literal("false", JSON_BOOL, False)
        if byte == 0x6E:
            return self._parse_literal("null", JSON_NULL)
        if byte == 0x2D or (byte >= 0x30 and byte <= 0x39):
            return self._parse_number()
        raise Error("invalid JSON value")


def parse_json(source: String) raises -> JsonDocument:
    """Parse one complete JSON value; rejects invalid UTF-8 and trailing data."""
    var parser = _Parser(source)
    parser.document.root = parser._parse_value(0)
    parser._skip_whitespace()
    if parser.position != len(parser.bytes):
        raise Error("trailing data after JSON value")
    return parser.document.copy()


def _append_hex4(mut output: String, value: Int):
    output.write_string("\\u")
    var digits = "0123456789abcdef"
    for position in range(4):
        var shift = 12 - position * 4
        var digit = (value >> shift) & 0xF
        output.write_string(digits[byte=digit])


def _write_quoted(mut output: String, value: String, ensure_ascii: Bool):
    output.write_string("\"")
    for codepoint in value.codepoints():
        var scalar = Int(codepoint.to_u32())
        if scalar == 0x22:
            output.write_string("\\\"")
        elif scalar == 0x5C:
            output.write_string("\\\\")
        elif scalar == 0x08:
            output.write_string("\\b")
        elif scalar == 0x0C:
            output.write_string("\\f")
        elif scalar == 0x0A:
            output.write_string("\\n")
        elif scalar == 0x0D:
            output.write_string("\\r")
        elif scalar == 0x09:
            output.write_string("\\t")
        elif scalar < 0x20:
            _append_hex4(output, scalar)
        elif ensure_ascii and scalar > 0x7F:
            if scalar <= 0xFFFF:
                _append_hex4(output, scalar)
            else:
                var adjusted = scalar - 0x10000
                _append_hex4(output, 0xD800 + (adjusted >> 10))
                _append_hex4(output, 0xDC00 + (adjusted & 0x3FF))
        else:
            output.write_string(chr(scalar))
    output.write_string("\"")


def _write_node(
    mut output: String,
    document: JsonDocument,
    index: Int,
    compact: Bool,
    ensure_ascii: Bool,
    depth: Int,
) raises:
    if depth > 1024:
        raise Error("JSON nesting depth exceeds 1024")
    if index < 0 or index >= len(document.nodes):
        raise Error("JSON node index out of range")
    var node = document.nodes[index]
    if node.kind == JSON_NULL:
        output.write_string("null")
    elif node.kind == JSON_BOOL:
        if node.boolean:
            output.write_string("true")
        else:
            output.write_string("false")
    elif node.kind == JSON_NUMBER:
        output.write_string(node.text)
    elif node.kind == JSON_STRING:
        _write_quoted(output, node.text, ensure_ascii)
    elif node.kind == JSON_ARRAY:
        output.write_string("[")
        var child = node.first_child
        var first = True
        while child != -1:
            if not first:
                if compact:
                    output.write_string(",")
                else:
                    output.write_string(", ")
            _write_node(output, document, child, compact, ensure_ascii, depth + 1)
            first = False
            child = document.nodes[child].next_sibling
        output.write_string("]")
    elif node.kind == JSON_OBJECT:
        output.write_string("{")
        var child = node.first_child
        var first = True
        while child != -1:
            if not first:
                if compact:
                    output.write_string(",")
                else:
                    output.write_string(", ")
            _write_quoted(output, document.nodes[child].name, ensure_ascii)
            if compact:
                output.write_string(":")
            else:
                output.write_string(": ")
            _write_node(output, document, child, compact, ensure_ascii, depth + 1)
            first = False
            child = document.nodes[child].next_sibling
        output.write_string("}")
    else:
        raise Error("unknown JSON node kind")


def dumps_json(
    document: JsonDocument,
    compact: Bool = False,
    ensure_ascii: Bool = True,
) raises -> String:
    """Serialize a parsed or constructed JSON document."""
    return document.to_json(compact, ensure_ascii)
