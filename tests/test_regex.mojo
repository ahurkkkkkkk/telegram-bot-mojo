from std.testing import assert_equal, assert_raises

from telegram._utils.regex import regex_match_from_start, regex_search


def main() raises:
    assert_equal(regex_match_from_start("^cat[0-9]+$", "cat42"), True)
    assert_equal(regex_match_from_start("^cat[0-9]+$", "xcat42"), False)
    assert_equal(regex_match_from_start("^\\d+$", "٤٢"), True)
    assert_equal(regex_search("help", "please help me"), True)
    assert_equal(regex_search("^help", "please help me"), False)
    with assert_raises():
        _ = regex_match_from_start("[", "anything")
