#!/usr/bin/env mojo
#
# A library that provides a Mojo interface to the Telegram Bot API
# Copyright (C) 2015-2026
# Leandro Toledo de Souza <devs@python-telegram-bot.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is derived from python-telegram-bot v22.8, which is distributed
# under the GNU Lesser General Public License version 3. See LICENSE.

"""Version metadata corresponding to telegram._version."""


@fieldwise_init
struct Version(Equatable, ImplicitlyCopyable):
    """Copies the behavior of sys.version_info.

    serial is always 0 for stable releases.
    """

    var major: Int
    var minor: Int
    var micro: Int
    var releaselevel: String
    var serial: Int

    def _rl_shorthand(self) raises -> String:
        if self.releaselevel == "alpha":
            return "a"
        if self.releaselevel == "beta":
            return "b"
        if self.releaselevel == "candidate":
            return "rc"
        raise Error("unknown release level: " + self.releaselevel)

    def format(self) raises -> String:
        var version = String(self.major) + "." + String(self.minor)
        if self.micro != 0:
            version += "." + String(self.micro)
        if self.releaselevel != "final":
            version += self._rl_shorthand() + String(self.serial)
        return version

    def __str__(self) raises -> String:
        """Match python-telegram-bot's display of its named-tuple version."""
        return self.format()

    def to_tuple(self) -> Tuple[Int, Int, Int, String, Int]:
        return (self.major, self.minor, self.micro, self.releaselevel, self.serial)

    def __lt__(self, other: Self) -> Bool:
        """Compare fields lexicographically, like the upstream NamedTuple."""
        if self.major != other.major:
            return self.major < other.major
        if self.minor != other.minor:
            return self.minor < other.minor
        if self.micro != other.micro:
            return self.micro < other.micro
        if self.releaselevel != other.releaselevel:
            return self.releaselevel < other.releaselevel
        return self.serial < other.serial

    def __le__(self, other: Self) -> Bool:
        return self < other or self == other

    def __gt__(self, other: Self) -> Bool:
        return other < self

    def __ge__(self, other: Self) -> Bool:
        return other < self or self == other

    def __repr__(self) -> String:
        return (
            "Version(major="
            + String(self.major)
            + ", minor="
            + String(self.minor)
            + ", micro="
            + String(self.micro)
            + ", releaselevel='"
            + self.releaselevel
            + "', serial="
            + String(self.serial)
            + ")"
        )


def version_info() -> Version:
    """Return the PTB version record."""
    return Version(22, 8, 0, "final", 0)


def version_string() raises -> String:
    """Return the public version string."""
    return version_info().format()


comptime __version_info__ = Version(22, 8, 0, "final", 0)
comptime __version__ = "22.8"
