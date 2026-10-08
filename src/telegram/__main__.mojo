#!/usr/bin/env mojo
#
# Native command-line entry point translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Print version information for the native Mojo client."""

from telegram import constants
from telegram._version import version_string


def format_ver_info() raises -> String:
    """Format library and Bot API versions for the native runtime."""
    return String(
        "python-telegram-bot ",
        version_string(),
        "\nBot API ",
        constants.BOT_API_VERSION,
        "\nMojo native runtime",
    )


def print_ver_info() raises:
    """Print the native library, Bot API, and runtime version information."""
    print(format_ver_info())


def main() raises:
    """Entry point for ``mojo run src/telegram/__main__.mojo``."""
    print_ver_info()
