#!/usr/bin/env mojo
#
# Native Unicode regular-expression matching for the Mojo PTB port.
# LGPL-3.0-or-later; see LICENSE.

"""Small PCRE2-backed regex operations used by native update handlers."""

from std.ffi import OwnedDLHandle
from std.memory import Pointer


def _regex_match(pattern: String, subject: String, options: UInt32) raises -> Bool:
    """Run a Unicode regex with PCRE2 options and report whether it matched."""
    var regex_library = OwnedDLHandle("libpcre2-8.so.0")
    var compile_regex = regex_library.get_function[UInt]("pcre2_compile_8")
    var code_free = regex_library.get_function[NoneType]("pcre2_code_free_8")
    var match_data_create = regex_library.get_function[UInt](
        "pcre2_match_data_create_from_pattern_8"
    )
    var match_data_free = regex_library.get_function[NoneType]("pcre2_match_data_free_8")
    var match_regex = regex_library.get_function[Int32]("pcre2_match_8")

    var pattern_text = pattern.copy()
    var subject_text = subject.copy()
    var compile_error = Int32(0)
    var error_offset = UInt(0)
    # PCRE2_UTF | PCRE2_UCP. Pattern and subject are valid UTF-8 Mojo strings.
    var code = compile_regex(
        pattern_text.unsafe_ptr(),
        UInt(pattern_text.byte_length()),
        UInt32(0x000A0000),
        Pointer(to=compile_error),
        Pointer(to=error_offset),
        UInt(0),
    )
    if code == 0:
        raise Error(
            String(
                "Invalid regular expression (PCRE2 error ",
                compile_error,
                " at byte ",
                error_offset,
                ")",
            )
        )

    var match_data = match_data_create(code, UInt(0))
    if match_data == 0:
        code_free(code)
        raise Error("PCRE2 could not allocate match data")
    var result = match_regex(
        code,
        subject_text.unsafe_ptr(),
        UInt(subject_text.byte_length()),
        UInt(0),
        options,
        match_data,
        UInt(0),
    )
    match_data_free(match_data)
    code_free(code)
    if result < -1:
        raise Error(String("PCRE2 matching failed with error ", result))
    return result > 0


def regex_match_from_start(pattern: String, subject: String) raises -> Bool:
    """Return whether a Unicode regex matches at subject offset zero.

    PCRE2 is used because Mojo 1.1 has no standard regex module. UTF and Unicode
    character-property modes are enabled to match Python's Unicode-oriented
    default as closely as the PCRE2 syntax allows.
    """
    # PCRE2_ANCHORED reproduces Python re.match's offset-zero constraint.
    return _regex_match(pattern, subject, UInt32(0x80000000))


def regex_search(pattern: String, subject: String) raises -> Bool:
    """Return whether a Unicode regex matches anywhere in the subject."""
    return _regex_match(pattern, subject, UInt32(0))
