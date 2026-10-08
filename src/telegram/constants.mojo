#!/usr/bin/env mojo
#
# Native Mojo translation of python-telegram-bot v22.8 telegram.constants.
# Copyright (C) 2015-2026 Leandro Toledo de Souza and contributors.
# Licensed under LGPL-3.0-or-later; see LICENSE and LICENSE.lesser.
"""Bot API constants and enum-compatible value types."""

@fieldwise_init
struct BotAPIVersionInfo(Equatable, ImplicitlyCopyable):
    var major: Int
    var minor: Int

    def __str__(self) -> String:
        return String(self.major) + "." + String(self.minor)

    def __repr__(self) -> String:
        return "BotAPIVersion(major=" + String(self.major) + ", minor=" + String(self.minor) + ")"

@fieldwise_init
struct DateTime(Equatable, ImplicitlyCopyable):
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
    var microsecond: Int
    var utc_offset_seconds: Int

@fieldwise_init
struct _ColorTuple(Equatable, ImplicitlyCopyable):
    var first: Int
    var second: Int
    var third: Int
    var count: Int

    def __len__(self) -> Int:
        return self.count

    def at(self, index: Int) -> Int:
        if index == 0:
            return self.first
        if index == 1:
            return self.second
        return self.third

@fieldwise_init
struct _AccentColor(Equatable, ImplicitlyCopyable):
    var identifier: Int
    var name: String
    var has_name: Bool
    var light_colors: _ColorTuple
    var dark_colors: _ColorTuple

comptime BOT_API_VERSION_INFO = BotAPIVersionInfo(10, 0)
comptime BOT_API_VERSION = "10.0"
comptime SUPPORTED_WEBHOOK_PORTS = (443, 80, 88, 8443)
comptime ZERO_DATE = DateTime(1970, 1, 1, 0, 0, 0, 0, 0)

@fieldwise_init
struct AccentColor(Equatable, ImplicitlyCopyable):
    var value: _AccentColor
    var name: String

    comptime COLOR_000 = AccentColor(_AccentColor(0, "red", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_000")
    comptime COLOR_001 = AccentColor(_AccentColor(1, "orange", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_001")
    comptime COLOR_002 = AccentColor(_AccentColor(2, "purple/violet", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_002")
    comptime COLOR_003 = AccentColor(_AccentColor(3, "green", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_003")
    comptime COLOR_004 = AccentColor(_AccentColor(4, "cyan", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_004")
    comptime COLOR_005 = AccentColor(_AccentColor(5, "blue", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_005")
    comptime COLOR_006 = AccentColor(_AccentColor(6, "pink", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)), "COLOR_006")
    comptime COLOR_007 = AccentColor(_AccentColor(7, "", False, _ColorTuple(14766162, 16363107, 0, 2), _ColorTuple(16749440, 10039095, 0, 2)), "COLOR_007")
    comptime COLOR_008 = AccentColor(_AccentColor(8, "", False, _ColorTuple(14712875, 16434484, 0, 2), _ColorTuple(15511630, 12801812, 0, 2)), "COLOR_008")
    comptime COLOR_009 = AccentColor(_AccentColor(9, "", False, _ColorTuple(10510323, 16027647, 0, 2), _ColorTuple(13015039, 6173128, 0, 2)), "COLOR_009")
    comptime COLOR_010 = AccentColor(_AccentColor(10, "", False, _ColorTuple(2599184, 11000919, 0, 2), _ColorTuple(11004782, 1474093, 0, 2)), "COLOR_010")
    comptime COLOR_011 = AccentColor(_AccentColor(11, "", False, _ColorTuple(2600142, 8579286, 0, 2), _ColorTuple(4249808, 285823, 0, 2)), "COLOR_011")
    comptime COLOR_012 = AccentColor(_AccentColor(12, "", False, _ColorTuple(3379668, 8246256, 0, 2), _ColorTuple(5423103, 742548, 0, 2)), "COLOR_012")
    comptime COLOR_013 = AccentColor(_AccentColor(13, "", False, _ColorTuple(14500721, 16760479, 0, 2), _ColorTuple(16746150, 9320046, 0, 2)), "COLOR_013")
    comptime COLOR_014 = AccentColor(_AccentColor(14, "", False, _ColorTuple(2391021, 15747158, 16777215, 3), _ColorTuple(4170494, 15024719, 16777215, 3)), "COLOR_014")
    comptime COLOR_015 = AccentColor(_AccentColor(15, "", False, _ColorTuple(14055202, 2007057, 16777215, 3), _ColorTuple(16748638, 3319079, 16777215, 3)), "COLOR_015")
    comptime COLOR_016 = AccentColor(_AccentColor(16, "", False, _ColorTuple(1547842, 15223359, 16777215, 3), _ColorTuple(6738788, 13976655, 16777215, 3)), "COLOR_016")
    comptime COLOR_017 = AccentColor(_AccentColor(17, "", False, _ColorTuple(2659503, 7324758, 16777215, 3), _ColorTuple(2276578, 4039232, 16777215, 3)), "COLOR_017")
    comptime COLOR_018 = AccentColor(_AccentColor(18, "", False, _ColorTuple(826035, 16756117, 16770741, 3), _ColorTuple(2276578, 16750456, 16767595, 3)), "COLOR_018")
    comptime COLOR_019 = AccentColor(_AccentColor(19, "", False, _ColorTuple(7821270, 16225808, 16768654, 3), _ColorTuple(9933311, 15889181, 16767833, 3)), "COLOR_019")
    comptime COLOR_020 = AccentColor(_AccentColor(20, "", False, _ColorTuple(1410511, 15903517, 16777215, 3), _ColorTuple(4040427, 15639837, 16777215, 3)), "COLOR_020")

    def __init__(out self, value: _AccentColor) raises:
        if value == _AccentColor(0, "red", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_000"
            return
        if value == _AccentColor(1, "orange", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_001"
            return
        if value == _AccentColor(2, "purple/violet", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_002"
            return
        if value == _AccentColor(3, "green", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_003"
            return
        if value == _AccentColor(4, "cyan", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_004"
            return
        if value == _AccentColor(5, "blue", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_005"
            return
        if value == _AccentColor(6, "pink", True, _ColorTuple(0, 0, 0, 0), _ColorTuple(0, 0, 0, 0)):
            self.value = value.copy()
            self.name = "COLOR_006"
            return
        if value == _AccentColor(7, "", False, _ColorTuple(14766162, 16363107, 0, 2), _ColorTuple(16749440, 10039095, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_007"
            return
        if value == _AccentColor(8, "", False, _ColorTuple(14712875, 16434484, 0, 2), _ColorTuple(15511630, 12801812, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_008"
            return
        if value == _AccentColor(9, "", False, _ColorTuple(10510323, 16027647, 0, 2), _ColorTuple(13015039, 6173128, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_009"
            return
        if value == _AccentColor(10, "", False, _ColorTuple(2599184, 11000919, 0, 2), _ColorTuple(11004782, 1474093, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_010"
            return
        if value == _AccentColor(11, "", False, _ColorTuple(2600142, 8579286, 0, 2), _ColorTuple(4249808, 285823, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_011"
            return
        if value == _AccentColor(12, "", False, _ColorTuple(3379668, 8246256, 0, 2), _ColorTuple(5423103, 742548, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_012"
            return
        if value == _AccentColor(13, "", False, _ColorTuple(14500721, 16760479, 0, 2), _ColorTuple(16746150, 9320046, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_013"
            return
        if value == _AccentColor(14, "", False, _ColorTuple(2391021, 15747158, 16777215, 3), _ColorTuple(4170494, 15024719, 16777215, 3)):
            self.value = value.copy()
            self.name = "COLOR_014"
            return
        if value == _AccentColor(15, "", False, _ColorTuple(14055202, 2007057, 16777215, 3), _ColorTuple(16748638, 3319079, 16777215, 3)):
            self.value = value.copy()
            self.name = "COLOR_015"
            return
        if value == _AccentColor(16, "", False, _ColorTuple(1547842, 15223359, 16777215, 3), _ColorTuple(6738788, 13976655, 16777215, 3)):
            self.value = value.copy()
            self.name = "COLOR_016"
            return
        if value == _AccentColor(17, "", False, _ColorTuple(2659503, 7324758, 16777215, 3), _ColorTuple(2276578, 4039232, 16777215, 3)):
            self.value = value.copy()
            self.name = "COLOR_017"
            return
        if value == _AccentColor(18, "", False, _ColorTuple(826035, 16756117, 16770741, 3), _ColorTuple(2276578, 16750456, 16767595, 3)):
            self.value = value.copy()
            self.name = "COLOR_018"
            return
        if value == _AccentColor(19, "", False, _ColorTuple(7821270, 16225808, 16768654, 3), _ColorTuple(9933311, 15889181, 16767833, 3)):
            self.value = value.copy()
            self.name = "COLOR_019"
            return
        if value == _AccentColor(20, "", False, _ColorTuple(1410511, 15903517, 16777215, 3), _ColorTuple(4040427, 15639837, 16777215, 3)):
            self.value = value.copy()
            self.name = "COLOR_020"
            return
        raise Error("AccentColor: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __repr__(self) -> String:
        return "<AccentColor." + self.name + ">"

@fieldwise_init
struct BackgroundFillLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_ROTATION_ANGLE = BackgroundFillLimit(359, "MAX_ROTATION_ANGLE")

    def __init__(out self, value: Int) raises:
        if value == 359:
            self.value = 359
            self.name = "MAX_ROTATION_ANGLE"
            return
        raise Error("BackgroundFillLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BackgroundFillLimit." + self.name + ">"

@fieldwise_init
struct BackgroundFillType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime SOLID = BackgroundFillType("solid", "SOLID")
    comptime GRADIENT = BackgroundFillType("gradient", "GRADIENT")
    comptime FREEFORM_GRADIENT = BackgroundFillType("freeform_gradient", "FREEFORM_GRADIENT")

    def __init__(out self, value: String) raises:
        if value == "solid":
            self.value = "solid"
            self.name = "SOLID"
            return
        if value == "gradient":
            self.value = "gradient"
            self.name = "GRADIENT"
            return
        if value == "freeform_gradient":
            self.value = "freeform_gradient"
            self.name = "FREEFORM_GRADIENT"
            return
        raise Error("BackgroundFillType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<BackgroundFillType." + self.name + ">"

@fieldwise_init
struct BackgroundTypeLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_DIMMING = BackgroundTypeLimit(100, "MAX_DIMMING")
    comptime MAX_INTENSITY = BackgroundTypeLimit(100, "MAX_DIMMING")

    def __init__(out self, value: Int) raises:
        if value == 100:
            self.value = 100
            self.name = "MAX_DIMMING"
            return
        raise Error("BackgroundTypeLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BackgroundTypeLimit." + self.name + ">"

@fieldwise_init
struct BackgroundTypeType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime FILL = BackgroundTypeType("fill", "FILL")
    comptime WALLPAPER = BackgroundTypeType("wallpaper", "WALLPAPER")
    comptime PATTERN = BackgroundTypeType("pattern", "PATTERN")
    comptime CHAT_THEME = BackgroundTypeType("chat_theme", "CHAT_THEME")

    def __init__(out self, value: String) raises:
        if value == "fill":
            self.value = "fill"
            self.name = "FILL"
            return
        if value == "wallpaper":
            self.value = "wallpaper"
            self.name = "WALLPAPER"
            return
        if value == "pattern":
            self.value = "pattern"
            self.name = "PATTERN"
            return
        if value == "chat_theme":
            self.value = "chat_theme"
            self.name = "CHAT_THEME"
            return
        raise Error("BackgroundTypeType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<BackgroundTypeType." + self.name + ">"

@fieldwise_init
struct BaseInputMediaType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime ANIMATION = BaseInputMediaType("animation", "ANIMATION")
    comptime DOCUMENT = BaseInputMediaType("document", "DOCUMENT")
    comptime AUDIO = BaseInputMediaType("audio", "AUDIO")
    comptime PHOTO = BaseInputMediaType("photo", "PHOTO")
    comptime VIDEO = BaseInputMediaType("video", "VIDEO")
    comptime LOCATION = BaseInputMediaType("location", "LOCATION")
    comptime STICKER = BaseInputMediaType("sticker", "STICKER")
    comptime VENUE = BaseInputMediaType("venue", "VENUE")
    comptime LIVE_PHOTO = BaseInputMediaType("live_photo", "LIVE_PHOTO")

    def __init__(out self, value: String) raises:
        if value == "animation":
            self.value = "animation"
            self.name = "ANIMATION"
            return
        if value == "document":
            self.value = "document"
            self.name = "DOCUMENT"
            return
        if value == "audio":
            self.value = "audio"
            self.name = "AUDIO"
            return
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "location":
            self.value = "location"
            self.name = "LOCATION"
            return
        if value == "sticker":
            self.value = "sticker"
            self.name = "STICKER"
            return
        if value == "venue":
            self.value = "venue"
            self.name = "VENUE"
            return
        if value == "live_photo":
            self.value = "live_photo"
            self.name = "LIVE_PHOTO"
            return
        raise Error("BaseInputMediaType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<BaseInputMediaType." + self.name + ">"

@fieldwise_init
struct BotCommandLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_COMMAND = BotCommandLimit(1, "MIN_COMMAND")
    comptime MAX_COMMAND = BotCommandLimit(32, "MAX_COMMAND")
    comptime MIN_DESCRIPTION = BotCommandLimit(1, "MIN_COMMAND")
    comptime MAX_DESCRIPTION = BotCommandLimit(256, "MAX_DESCRIPTION")
    comptime MAX_COMMAND_NUMBER = BotCommandLimit(100, "MAX_COMMAND_NUMBER")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_COMMAND"
            return
        if value == 32:
            self.value = 32
            self.name = "MAX_COMMAND"
            return
        if value == 256:
            self.value = 256
            self.name = "MAX_DESCRIPTION"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_COMMAND_NUMBER"
            return
        raise Error("BotCommandLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BotCommandLimit." + self.name + ">"

@fieldwise_init
struct BotCommandScopeType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime DEFAULT = BotCommandScopeType("default", "DEFAULT")
    comptime ALL_PRIVATE_CHATS = BotCommandScopeType("all_private_chats", "ALL_PRIVATE_CHATS")
    comptime ALL_GROUP_CHATS = BotCommandScopeType("all_group_chats", "ALL_GROUP_CHATS")
    comptime ALL_CHAT_ADMINISTRATORS = BotCommandScopeType("all_chat_administrators", "ALL_CHAT_ADMINISTRATORS")
    comptime CHAT = BotCommandScopeType("chat", "CHAT")
    comptime CHAT_ADMINISTRATORS = BotCommandScopeType("chat_administrators", "CHAT_ADMINISTRATORS")
    comptime CHAT_MEMBER = BotCommandScopeType("chat_member", "CHAT_MEMBER")

    def __init__(out self, value: String) raises:
        if value == "default":
            self.value = "default"
            self.name = "DEFAULT"
            return
        if value == "all_private_chats":
            self.value = "all_private_chats"
            self.name = "ALL_PRIVATE_CHATS"
            return
        if value == "all_group_chats":
            self.value = "all_group_chats"
            self.name = "ALL_GROUP_CHATS"
            return
        if value == "all_chat_administrators":
            self.value = "all_chat_administrators"
            self.name = "ALL_CHAT_ADMINISTRATORS"
            return
        if value == "chat":
            self.value = "chat"
            self.name = "CHAT"
            return
        if value == "chat_administrators":
            self.value = "chat_administrators"
            self.name = "CHAT_ADMINISTRATORS"
            return
        if value == "chat_member":
            self.value = "chat_member"
            self.name = "CHAT_MEMBER"
            return
        raise Error("BotCommandScopeType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<BotCommandScopeType." + self.name + ">"

@fieldwise_init
struct BotDescriptionLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_DESCRIPTION_LENGTH = BotDescriptionLimit(512, "MAX_DESCRIPTION_LENGTH")
    comptime MAX_SHORT_DESCRIPTION_LENGTH = BotDescriptionLimit(120, "MAX_SHORT_DESCRIPTION_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 512:
            self.value = 512
            self.name = "MAX_DESCRIPTION_LENGTH"
            return
        if value == 120:
            self.value = 120
            self.name = "MAX_SHORT_DESCRIPTION_LENGTH"
            return
        raise Error("BotDescriptionLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BotDescriptionLimit." + self.name + ">"

@fieldwise_init
struct BotNameLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_NAME_LENGTH = BotNameLimit(64, "MAX_NAME_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 64:
            self.value = 64
            self.name = "MAX_NAME_LENGTH"
            return
        raise Error("BotNameLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BotNameLimit." + self.name + ">"

@fieldwise_init
struct BulkRequestLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_LIMIT = BulkRequestLimit(1, "MIN_LIMIT")
    comptime MAX_LIMIT = BulkRequestLimit(100, "MAX_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_LIMIT"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_LIMIT"
            return
        raise Error("BulkRequestLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BulkRequestLimit." + self.name + ">"

@fieldwise_init
struct BusinessLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime CHAT_ACTIVITY_TIMEOUT = BusinessLimit(86400, "CHAT_ACTIVITY_TIMEOUT")
    comptime MIN_NAME_LENGTH = BusinessLimit(1, "MIN_NAME_LENGTH")
    comptime MAX_NAME_LENGTH = BusinessLimit(64, "MAX_NAME_LENGTH")
    comptime MAX_USERNAME_LENGTH = BusinessLimit(32, "MAX_USERNAME_LENGTH")
    comptime MAX_BIO_LENGTH = BusinessLimit(140, "MAX_BIO_LENGTH")
    comptime MIN_GIFT_RESULTS = BusinessLimit(1, "MIN_NAME_LENGTH")
    comptime MAX_GIFT_RESULTS = BusinessLimit(100, "MAX_GIFT_RESULTS")
    comptime MIN_STAR_COUNT = BusinessLimit(1, "MIN_NAME_LENGTH")
    comptime MAX_STAR_COUNT = BusinessLimit(10000, "MAX_STAR_COUNT")

    def __init__(out self, value: Int) raises:
        if value == 86400:
            self.value = 86400
            self.name = "CHAT_ACTIVITY_TIMEOUT"
            return
        if value == 1:
            self.value = 1
            self.name = "MIN_NAME_LENGTH"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_NAME_LENGTH"
            return
        if value == 32:
            self.value = 32
            self.name = "MAX_USERNAME_LENGTH"
            return
        if value == 140:
            self.value = 140
            self.name = "MAX_BIO_LENGTH"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_GIFT_RESULTS"
            return
        if value == 10000:
            self.value = 10000
            self.name = "MAX_STAR_COUNT"
            return
        raise Error("BusinessLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<BusinessLimit." + self.name + ">"

@fieldwise_init
struct CallbackQueryLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime ANSWER_CALLBACK_QUERY_TEXT_LENGTH = CallbackQueryLimit(200, "ANSWER_CALLBACK_QUERY_TEXT_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 200:
            self.value = 200
            self.name = "ANSWER_CALLBACK_QUERY_TEXT_LENGTH"
            return
        raise Error("CallbackQueryLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<CallbackQueryLimit." + self.name + ">"

@fieldwise_init
struct ChatAction(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime CHOOSE_STICKER = ChatAction("choose_sticker", "CHOOSE_STICKER")
    comptime FIND_LOCATION = ChatAction("find_location", "FIND_LOCATION")
    comptime RECORD_VOICE = ChatAction("record_voice", "RECORD_VOICE")
    comptime RECORD_VIDEO = ChatAction("record_video", "RECORD_VIDEO")
    comptime RECORD_VIDEO_NOTE = ChatAction("record_video_note", "RECORD_VIDEO_NOTE")
    comptime TYPING = ChatAction("typing", "TYPING")
    comptime UPLOAD_VOICE = ChatAction("upload_voice", "UPLOAD_VOICE")
    comptime UPLOAD_DOCUMENT = ChatAction("upload_document", "UPLOAD_DOCUMENT")
    comptime UPLOAD_PHOTO = ChatAction("upload_photo", "UPLOAD_PHOTO")
    comptime UPLOAD_VIDEO = ChatAction("upload_video", "UPLOAD_VIDEO")
    comptime UPLOAD_VIDEO_NOTE = ChatAction("upload_video_note", "UPLOAD_VIDEO_NOTE")

    def __init__(out self, value: String) raises:
        if value == "choose_sticker":
            self.value = "choose_sticker"
            self.name = "CHOOSE_STICKER"
            return
        if value == "find_location":
            self.value = "find_location"
            self.name = "FIND_LOCATION"
            return
        if value == "record_voice":
            self.value = "record_voice"
            self.name = "RECORD_VOICE"
            return
        if value == "record_video":
            self.value = "record_video"
            self.name = "RECORD_VIDEO"
            return
        if value == "record_video_note":
            self.value = "record_video_note"
            self.name = "RECORD_VIDEO_NOTE"
            return
        if value == "typing":
            self.value = "typing"
            self.name = "TYPING"
            return
        if value == "upload_voice":
            self.value = "upload_voice"
            self.name = "UPLOAD_VOICE"
            return
        if value == "upload_document":
            self.value = "upload_document"
            self.name = "UPLOAD_DOCUMENT"
            return
        if value == "upload_photo":
            self.value = "upload_photo"
            self.name = "UPLOAD_PHOTO"
            return
        if value == "upload_video":
            self.value = "upload_video"
            self.name = "UPLOAD_VIDEO"
            return
        if value == "upload_video_note":
            self.value = "upload_video_note"
            self.name = "UPLOAD_VIDEO_NOTE"
            return
        raise Error("ChatAction: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ChatAction." + self.name + ">"

@fieldwise_init
struct ChatBoostSources(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime GIFT_CODE = ChatBoostSources("gift_code", "GIFT_CODE")
    comptime GIVEAWAY = ChatBoostSources("giveaway", "GIVEAWAY")
    comptime PREMIUM = ChatBoostSources("premium", "PREMIUM")

    def __init__(out self, value: String) raises:
        if value == "gift_code":
            self.value = "gift_code"
            self.name = "GIFT_CODE"
            return
        if value == "giveaway":
            self.value = "giveaway"
            self.name = "GIVEAWAY"
            return
        if value == "premium":
            self.value = "premium"
            self.name = "PREMIUM"
            return
        raise Error("ChatBoostSources: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ChatBoostSources." + self.name + ">"

@fieldwise_init
struct ChatID(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime ANONYMOUS_ADMIN = ChatID(1087968824, "ANONYMOUS_ADMIN")
    comptime SERVICE_CHAT = ChatID(777000, "SERVICE_CHAT")
    comptime FAKE_CHANNEL = ChatID(136817688, "FAKE_CHANNEL")

    def __init__(out self, value: Int) raises:
        if value == 1087968824:
            self.value = 1087968824
            self.name = "ANONYMOUS_ADMIN"
            return
        if value == 777000:
            self.value = 777000
            self.name = "SERVICE_CHAT"
            return
        if value == 136817688:
            self.value = 136817688
            self.name = "FAKE_CHANNEL"
            return
        raise Error("ChatID: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ChatID." + self.name + ">"

@fieldwise_init
struct ChatInviteLinkLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_MEMBER_LIMIT = ChatInviteLinkLimit(1, "MIN_MEMBER_LIMIT")
    comptime MAX_MEMBER_LIMIT = ChatInviteLinkLimit(99999, "MAX_MEMBER_LIMIT")
    comptime NAME_LENGTH = ChatInviteLinkLimit(32, "NAME_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_MEMBER_LIMIT"
            return
        if value == 99999:
            self.value = 99999
            self.name = "MAX_MEMBER_LIMIT"
            return
        if value == 32:
            self.value = 32
            self.name = "NAME_LENGTH"
            return
        raise Error("ChatInviteLinkLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ChatInviteLinkLimit." + self.name + ">"

@fieldwise_init
struct ChatLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime CHAT_ADMINISTRATOR_CUSTOM_TITLE_LENGTH = ChatLimit(16, "CHAT_ADMINISTRATOR_CUSTOM_TITLE_LENGTH")
    comptime CHAT_DESCRIPTION_LENGTH = ChatLimit(255, "CHAT_DESCRIPTION_LENGTH")
    comptime MIN_CHAT_TITLE_LENGTH = ChatLimit(1, "MIN_CHAT_TITLE_LENGTH")
    comptime MAX_CHAT_TITLE_LENGTH = ChatLimit(128, "MAX_CHAT_TITLE_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 16:
            self.value = 16
            self.name = "CHAT_ADMINISTRATOR_CUSTOM_TITLE_LENGTH"
            return
        if value == 255:
            self.value = 255
            self.name = "CHAT_DESCRIPTION_LENGTH"
            return
        if value == 1:
            self.value = 1
            self.name = "MIN_CHAT_TITLE_LENGTH"
            return
        if value == 128:
            self.value = 128
            self.name = "MAX_CHAT_TITLE_LENGTH"
            return
        raise Error("ChatLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ChatLimit." + self.name + ">"

@fieldwise_init
struct ChatMemberStatus(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime ADMINISTRATOR = ChatMemberStatus("administrator", "ADMINISTRATOR")
    comptime OWNER = ChatMemberStatus("creator", "OWNER")
    comptime BANNED = ChatMemberStatus("kicked", "BANNED")
    comptime LEFT = ChatMemberStatus("left", "LEFT")
    comptime MEMBER = ChatMemberStatus("member", "MEMBER")
    comptime RESTRICTED = ChatMemberStatus("restricted", "RESTRICTED")

    def __init__(out self, value: String) raises:
        if value == "administrator":
            self.value = "administrator"
            self.name = "ADMINISTRATOR"
            return
        if value == "creator":
            self.value = "creator"
            self.name = "OWNER"
            return
        if value == "kicked":
            self.value = "kicked"
            self.name = "BANNED"
            return
        if value == "left":
            self.value = "left"
            self.name = "LEFT"
            return
        if value == "member":
            self.value = "member"
            self.name = "MEMBER"
            return
        if value == "restricted":
            self.value = "restricted"
            self.name = "RESTRICTED"
            return
        raise Error("ChatMemberStatus: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ChatMemberStatus." + self.name + ">"

@fieldwise_init
struct ChatPhotoSize(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime SMALL = ChatPhotoSize(160, "SMALL")
    comptime BIG = ChatPhotoSize(640, "BIG")

    def __init__(out self, value: Int) raises:
        if value == 160:
            self.value = 160
            self.name = "SMALL"
            return
        if value == 640:
            self.value = 640
            self.name = "BIG"
            return
        raise Error("ChatPhotoSize: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ChatPhotoSize." + self.name + ">"

@fieldwise_init
struct ChatSubscriptionLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime SUBSCRIPTION_PERIOD = ChatSubscriptionLimit(2592000, "SUBSCRIPTION_PERIOD")
    comptime MIN_PRICE = ChatSubscriptionLimit(1, "MIN_PRICE")
    comptime MAX_PRICE = ChatSubscriptionLimit(10000, "MAX_PRICE")

    def __init__(out self, value: Int) raises:
        if value == 2592000:
            self.value = 2592000
            self.name = "SUBSCRIPTION_PERIOD"
            return
        if value == 1:
            self.value = 1
            self.name = "MIN_PRICE"
            return
        if value == 10000:
            self.value = 10000
            self.name = "MAX_PRICE"
            return
        raise Error("ChatSubscriptionLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ChatSubscriptionLimit." + self.name + ">"

@fieldwise_init
struct ChatType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime SENDER = ChatType("sender", "SENDER")
    comptime PRIVATE = ChatType("private", "PRIVATE")
    comptime GROUP = ChatType("group", "GROUP")
    comptime SUPERGROUP = ChatType("supergroup", "SUPERGROUP")
    comptime CHANNEL = ChatType("channel", "CHANNEL")

    def __init__(out self, value: String) raises:
        if value == "sender":
            self.value = "sender"
            self.name = "SENDER"
            return
        if value == "private":
            self.value = "private"
            self.name = "PRIVATE"
            return
        if value == "group":
            self.value = "group"
            self.name = "GROUP"
            return
        if value == "supergroup":
            self.value = "supergroup"
            self.name = "SUPERGROUP"
            return
        if value == "channel":
            self.value = "channel"
            self.name = "CHANNEL"
            return
        raise Error("ChatType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ChatType." + self.name + ">"

@fieldwise_init
struct ContactLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime VCARD = ContactLimit(2048, "VCARD")

    def __init__(out self, value: Int) raises:
        if value == 2048:
            self.value = 2048
            self.name = "VCARD"
            return
        raise Error("ContactLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ContactLimit." + self.name + ">"

@fieldwise_init
struct CustomEmojiStickerLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime CUSTOM_EMOJI_IDENTIFIER_LIMIT = CustomEmojiStickerLimit(200, "CUSTOM_EMOJI_IDENTIFIER_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 200:
            self.value = 200
            self.name = "CUSTOM_EMOJI_IDENTIFIER_LIMIT"
            return
        raise Error("CustomEmojiStickerLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<CustomEmojiStickerLimit." + self.name + ">"

@fieldwise_init
struct DiceEmoji(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime DICE = DiceEmoji("🎲", "DICE")
    comptime DARTS = DiceEmoji("🎯", "DARTS")
    comptime BASKETBALL = DiceEmoji("🏀", "BASKETBALL")
    comptime FOOTBALL = DiceEmoji("⚽", "FOOTBALL")
    comptime SLOT_MACHINE = DiceEmoji("🎰", "SLOT_MACHINE")
    comptime BOWLING = DiceEmoji("🎳", "BOWLING")

    def __init__(out self, value: String) raises:
        if value == "🎲":
            self.value = "🎲"
            self.name = "DICE"
            return
        if value == "🎯":
            self.value = "🎯"
            self.name = "DARTS"
            return
        if value == "🏀":
            self.value = "🏀"
            self.name = "BASKETBALL"
            return
        if value == "⚽":
            self.value = "⚽"
            self.name = "FOOTBALL"
            return
        if value == "🎰":
            self.value = "🎰"
            self.name = "SLOT_MACHINE"
            return
        if value == "🎳":
            self.value = "🎳"
            self.name = "BOWLING"
            return
        raise Error("DiceEmoji: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<DiceEmoji." + self.name + ">"

@fieldwise_init
struct DiceLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_VALUE = DiceLimit(1, "MIN_VALUE")
    comptime MAX_VALUE_BASKETBALL = DiceLimit(5, "MAX_VALUE_BASKETBALL")
    comptime MAX_VALUE_BOWLING = DiceLimit(6, "MAX_VALUE_BOWLING")
    comptime MAX_VALUE_DARTS = DiceLimit(6, "MAX_VALUE_BOWLING")
    comptime MAX_VALUE_DICE = DiceLimit(6, "MAX_VALUE_BOWLING")
    comptime MAX_VALUE_FOOTBALL = DiceLimit(5, "MAX_VALUE_BASKETBALL")
    comptime MAX_VALUE_SLOT_MACHINE = DiceLimit(64, "MAX_VALUE_SLOT_MACHINE")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_VALUE"
            return
        if value == 5:
            self.value = 5
            self.name = "MAX_VALUE_BASKETBALL"
            return
        if value == 6:
            self.value = 6
            self.name = "MAX_VALUE_BOWLING"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_VALUE_SLOT_MACHINE"
            return
        raise Error("DiceLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<DiceLimit." + self.name + ">"

@fieldwise_init
struct FileSizeLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime FILESIZE_DOWNLOAD = FileSizeLimit(20000000, "FILESIZE_DOWNLOAD")
    comptime FILESIZE_UPLOAD = FileSizeLimit(50000000, "FILESIZE_UPLOAD")
    comptime FILESIZE_UPLOAD_LOCAL_MODE = FileSizeLimit(2000000000, "FILESIZE_UPLOAD_LOCAL_MODE")
    comptime FILESIZE_DOWNLOAD_LOCAL_MODE = FileSizeLimit(9223372036854775807, "FILESIZE_DOWNLOAD_LOCAL_MODE")
    comptime PHOTOSIZE_UPLOAD = FileSizeLimit(10000000, "PHOTOSIZE_UPLOAD")
    comptime VOICE_NOTE_FILE_SIZE = FileSizeLimit(1000000, "VOICE_NOTE_FILE_SIZE")

    def __init__(out self, value: Int) raises:
        if value == 20000000:
            self.value = 20000000
            self.name = "FILESIZE_DOWNLOAD"
            return
        if value == 50000000:
            self.value = 50000000
            self.name = "FILESIZE_UPLOAD"
            return
        if value == 2000000000:
            self.value = 2000000000
            self.name = "FILESIZE_UPLOAD_LOCAL_MODE"
            return
        if value == 9223372036854775807:
            self.value = 9223372036854775807
            self.name = "FILESIZE_DOWNLOAD_LOCAL_MODE"
            return
        if value == 10000000:
            self.value = 10000000
            self.name = "PHOTOSIZE_UPLOAD"
            return
        if value == 1000000:
            self.value = 1000000
            self.name = "VOICE_NOTE_FILE_SIZE"
            return
        raise Error("FileSizeLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<FileSizeLimit." + self.name + ">"

@fieldwise_init
struct FloodLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MESSAGES_PER_SECOND_PER_CHAT = FloodLimit(1, "MESSAGES_PER_SECOND_PER_CHAT")
    comptime MESSAGES_PER_SECOND = FloodLimit(30, "MESSAGES_PER_SECOND")
    comptime MESSAGES_PER_MINUTE_PER_GROUP = FloodLimit(20, "MESSAGES_PER_MINUTE_PER_GROUP")
    comptime PAID_MESSAGES_PER_SECOND = FloodLimit(1000, "PAID_MESSAGES_PER_SECOND")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MESSAGES_PER_SECOND_PER_CHAT"
            return
        if value == 30:
            self.value = 30
            self.name = "MESSAGES_PER_SECOND"
            return
        if value == 20:
            self.value = 20
            self.name = "MESSAGES_PER_MINUTE_PER_GROUP"
            return
        if value == 1000:
            self.value = 1000
            self.name = "PAID_MESSAGES_PER_SECOND"
            return
        raise Error("FloodLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<FloodLimit." + self.name + ">"

@fieldwise_init
struct ForumIconColor(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime BLUE = ForumIconColor(7322096, "BLUE")
    comptime YELLOW = ForumIconColor(16766590, "YELLOW")
    comptime PURPLE = ForumIconColor(13338331, "PURPLE")
    comptime GREEN = ForumIconColor(9367192, "GREEN")
    comptime PINK = ForumIconColor(16749490, "PINK")
    comptime RED = ForumIconColor(16478047, "RED")

    def __init__(out self, value: Int) raises:
        if value == 7322096:
            self.value = 7322096
            self.name = "BLUE"
            return
        if value == 16766590:
            self.value = 16766590
            self.name = "YELLOW"
            return
        if value == 13338331:
            self.value = 13338331
            self.name = "PURPLE"
            return
        if value == 9367192:
            self.value = 9367192
            self.name = "GREEN"
            return
        if value == 16749490:
            self.value = 16749490
            self.name = "PINK"
            return
        if value == 16478047:
            self.value = 16478047
            self.name = "RED"
            return
        raise Error("ForumIconColor: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ForumIconColor." + self.name + ">"

@fieldwise_init
struct ForumTopicLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_NAME_LENGTH = ForumTopicLimit(1, "MIN_NAME_LENGTH")
    comptime MAX_NAME_LENGTH = ForumTopicLimit(128, "MAX_NAME_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_NAME_LENGTH"
            return
        if value == 128:
            self.value = 128
            self.name = "MAX_NAME_LENGTH"
            return
        raise Error("ForumTopicLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ForumTopicLimit." + self.name + ">"

@fieldwise_init
struct GiftLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_TEXT_LENGTH = GiftLimit(128, "MAX_TEXT_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 128:
            self.value = 128
            self.name = "MAX_TEXT_LENGTH"
            return
        raise Error("GiftLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<GiftLimit." + self.name + ">"

@fieldwise_init
struct GiveawayLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_WINNERS = GiveawayLimit(100, "MAX_WINNERS")

    def __init__(out self, value: Int) raises:
        if value == 100:
            self.value = 100
            self.name = "MAX_WINNERS"
            return
        raise Error("GiveawayLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<GiveawayLimit." + self.name + ">"

@fieldwise_init
struct InlineKeyboardButtonLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_CALLBACK_DATA = InlineKeyboardButtonLimit(1, "MIN_CALLBACK_DATA")
    comptime MAX_CALLBACK_DATA = InlineKeyboardButtonLimit(64, "MAX_CALLBACK_DATA")
    comptime MIN_COPY_TEXT = InlineKeyboardButtonLimit(1, "MIN_CALLBACK_DATA")
    comptime MAX_COPY_TEXT = InlineKeyboardButtonLimit(256, "MAX_COPY_TEXT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_CALLBACK_DATA"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_CALLBACK_DATA"
            return
        if value == 256:
            self.value = 256
            self.name = "MAX_COPY_TEXT"
            return
        raise Error("InlineKeyboardButtonLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InlineKeyboardButtonLimit." + self.name + ">"

@fieldwise_init
struct InlineKeyboardMarkupLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime TOTAL_BUTTON_NUMBER = InlineKeyboardMarkupLimit(100, "TOTAL_BUTTON_NUMBER")
    comptime BUTTONS_PER_ROW = InlineKeyboardMarkupLimit(8, "BUTTONS_PER_ROW")

    def __init__(out self, value: Int) raises:
        if value == 100:
            self.value = 100
            self.name = "TOTAL_BUTTON_NUMBER"
            return
        if value == 8:
            self.value = 8
            self.name = "BUTTONS_PER_ROW"
            return
        raise Error("InlineKeyboardMarkupLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InlineKeyboardMarkupLimit." + self.name + ">"

@fieldwise_init
struct InlineQueryLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime RESULTS = InlineQueryLimit(50, "RESULTS")
    comptime MAX_OFFSET_LENGTH = InlineQueryLimit(64, "MAX_OFFSET_LENGTH")
    comptime MAX_QUERY_LENGTH = InlineQueryLimit(256, "MAX_QUERY_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 50:
            self.value = 50
            self.name = "RESULTS"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_OFFSET_LENGTH"
            return
        if value == 256:
            self.value = 256
            self.name = "MAX_QUERY_LENGTH"
            return
        raise Error("InlineQueryLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InlineQueryLimit." + self.name + ">"

@fieldwise_init
struct InlineQueryResultLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_ID_LENGTH = InlineQueryResultLimit(1, "MIN_ID_LENGTH")
    comptime MAX_ID_LENGTH = InlineQueryResultLimit(64, "MAX_ID_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_ID_LENGTH"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_ID_LENGTH"
            return
        raise Error("InlineQueryResultLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InlineQueryResultLimit." + self.name + ">"

@fieldwise_init
struct InlineQueryResultType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime AUDIO = InlineQueryResultType("audio", "AUDIO")
    comptime DOCUMENT = InlineQueryResultType("document", "DOCUMENT")
    comptime GIF = InlineQueryResultType("gif", "GIF")
    comptime MPEG4GIF = InlineQueryResultType("mpeg4_gif", "MPEG4GIF")
    comptime PHOTO = InlineQueryResultType("photo", "PHOTO")
    comptime STICKER = InlineQueryResultType("sticker", "STICKER")
    comptime VIDEO = InlineQueryResultType("video", "VIDEO")
    comptime VOICE = InlineQueryResultType("voice", "VOICE")
    comptime ARTICLE = InlineQueryResultType("article", "ARTICLE")
    comptime CONTACT = InlineQueryResultType("contact", "CONTACT")
    comptime GAME = InlineQueryResultType("game", "GAME")
    comptime LOCATION = InlineQueryResultType("location", "LOCATION")
    comptime VENUE = InlineQueryResultType("venue", "VENUE")

    def __init__(out self, value: String) raises:
        if value == "audio":
            self.value = "audio"
            self.name = "AUDIO"
            return
        if value == "document":
            self.value = "document"
            self.name = "DOCUMENT"
            return
        if value == "gif":
            self.value = "gif"
            self.name = "GIF"
            return
        if value == "mpeg4_gif":
            self.value = "mpeg4_gif"
            self.name = "MPEG4GIF"
            return
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "sticker":
            self.value = "sticker"
            self.name = "STICKER"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "voice":
            self.value = "voice"
            self.name = "VOICE"
            return
        if value == "article":
            self.value = "article"
            self.name = "ARTICLE"
            return
        if value == "contact":
            self.value = "contact"
            self.name = "CONTACT"
            return
        if value == "game":
            self.value = "game"
            self.name = "GAME"
            return
        if value == "location":
            self.value = "location"
            self.name = "LOCATION"
            return
        if value == "venue":
            self.value = "venue"
            self.name = "VENUE"
            return
        raise Error("InlineQueryResultType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<InlineQueryResultType." + self.name + ">"

@fieldwise_init
struct InlineQueryResultsButtonLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_START_PARAMETER_LENGTH = InlineQueryResultsButtonLimit(1, "MIN_START_PARAMETER_LENGTH")
    comptime MAX_START_PARAMETER_LENGTH = InlineQueryResultsButtonLimit(64, "MAX_START_PARAMETER_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_START_PARAMETER_LENGTH"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_START_PARAMETER_LENGTH"
            return
        raise Error("InlineQueryResultsButtonLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InlineQueryResultsButtonLimit." + self.name + ">"

@fieldwise_init
struct InputChecklistLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_TITLE_LENGTH = InputChecklistLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_TITLE_LENGTH = InputChecklistLimit(255, "MAX_TITLE_LENGTH")
    comptime MIN_TEXT_LENGTH = InputChecklistLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_TEXT_LENGTH = InputChecklistLimit(100, "MAX_TEXT_LENGTH")
    comptime MIN_TASK_NUMBER = InputChecklistLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_TASK_NUMBER = InputChecklistLimit(30, "MAX_TASK_NUMBER")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_TITLE_LENGTH"
            return
        if value == 255:
            self.value = 255
            self.name = "MAX_TITLE_LENGTH"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_TEXT_LENGTH"
            return
        if value == 30:
            self.value = 30
            self.name = "MAX_TASK_NUMBER"
            return
        raise Error("InputChecklistLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InputChecklistLimit." + self.name + ">"

@fieldwise_init
struct InputMediaType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime ANIMATION = InputMediaType("animation", "ANIMATION")
    comptime DOCUMENT = InputMediaType("document", "DOCUMENT")
    comptime AUDIO = InputMediaType("audio", "AUDIO")
    comptime PHOTO = InputMediaType("photo", "PHOTO")
    comptime VIDEO = InputMediaType("video", "VIDEO")
    comptime LIVE_PHOTO = InputMediaType("live_photo", "LIVE_PHOTO")

    def __init__(out self, value: String) raises:
        if value == "animation":
            self.value = "animation"
            self.name = "ANIMATION"
            return
        if value == "document":
            self.value = "document"
            self.name = "DOCUMENT"
            return
        if value == "audio":
            self.value = "audio"
            self.name = "AUDIO"
            return
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "live_photo":
            self.value = "live_photo"
            self.name = "LIVE_PHOTO"
            return
        raise Error("InputMediaType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<InputMediaType." + self.name + ">"

@fieldwise_init
struct InputPaidMediaType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PHOTO = InputPaidMediaType("photo", "PHOTO")
    comptime VIDEO = InputPaidMediaType("video", "VIDEO")
    comptime LIVE_PHOTO = InputPaidMediaType("live_photo", "LIVE_PHOTO")

    def __init__(out self, value: String) raises:
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "live_photo":
            self.value = "live_photo"
            self.name = "LIVE_PHOTO"
            return
        raise Error("InputPaidMediaType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<InputPaidMediaType." + self.name + ">"

@fieldwise_init
struct InputProfilePhotoType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime STATIC = InputProfilePhotoType("static", "STATIC")
    comptime ANIMATED = InputProfilePhotoType("animated", "ANIMATED")

    def __init__(out self, value: String) raises:
        if value == "static":
            self.value = "static"
            self.name = "STATIC"
            return
        if value == "animated":
            self.value = "animated"
            self.name = "ANIMATED"
            return
        raise Error("InputProfilePhotoType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<InputProfilePhotoType." + self.name + ">"

@fieldwise_init
struct InputStoryContentLimit(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PHOTOSIZE_UPLOAD = InputStoryContentLimit("10000000", "PHOTOSIZE_UPLOAD")
    comptime PHOTO_WIDTH = InputStoryContentLimit("1080", "PHOTO_WIDTH")
    comptime PHOTO_HEIGHT = InputStoryContentLimit("1920", "PHOTO_HEIGHT")
    comptime VIDEOSIZE_UPLOAD = InputStoryContentLimit("30000000", "VIDEOSIZE_UPLOAD")
    comptime VIDEO_WIDTH = InputStoryContentLimit("720", "VIDEO_WIDTH")
    comptime VIDEO_HEIGHT = InputStoryContentLimit("1080", "PHOTO_WIDTH")
    comptime MAX_VIDEO_DURATION = InputStoryContentLimit("60", "MAX_VIDEO_DURATION")

    def __init__(out self, value: String) raises:
        if value == "10000000":
            self.value = "10000000"
            self.name = "PHOTOSIZE_UPLOAD"
            return
        if value == "1080":
            self.value = "1080"
            self.name = "PHOTO_WIDTH"
            return
        if value == "1920":
            self.value = "1920"
            self.name = "PHOTO_HEIGHT"
            return
        if value == "30000000":
            self.value = "30000000"
            self.name = "VIDEOSIZE_UPLOAD"
            return
        if value == "720":
            self.value = "720"
            self.name = "VIDEO_WIDTH"
            return
        if value == "60":
            self.value = "60"
            self.name = "MAX_VIDEO_DURATION"
            return
        raise Error("InputStoryContentLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<InputStoryContentLimit." + self.name + ">"

@fieldwise_init
struct InputStoryContentType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PHOTO = InputStoryContentType("photo", "PHOTO")
    comptime VIDEO = InputStoryContentType("video", "VIDEO")

    def __init__(out self, value: String) raises:
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        raise Error("InputStoryContentType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<InputStoryContentType." + self.name + ">"

@fieldwise_init
struct InvoiceLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_TITLE_LENGTH = InvoiceLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_TITLE_LENGTH = InvoiceLimit(32, "MAX_TITLE_LENGTH")
    comptime MIN_DESCRIPTION_LENGTH = InvoiceLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_DESCRIPTION_LENGTH = InvoiceLimit(255, "MAX_DESCRIPTION_LENGTH")
    comptime MIN_PAYLOAD_LENGTH = InvoiceLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_PAYLOAD_LENGTH = InvoiceLimit(128, "MAX_PAYLOAD_LENGTH")
    comptime MAX_TIP_AMOUNTS = InvoiceLimit(4, "MAX_TIP_AMOUNTS")
    comptime MIN_STAR_COUNT = InvoiceLimit(1, "MIN_TITLE_LENGTH")
    comptime MAX_STAR_COUNT = InvoiceLimit(25000, "MAX_STAR_COUNT")
    comptime SUBSCRIPTION_PERIOD = InvoiceLimit(2592000, "SUBSCRIPTION_PERIOD")
    comptime SUBSCRIPTION_MAX_PRICE = InvoiceLimit(10000, "SUBSCRIPTION_MAX_PRICE")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_TITLE_LENGTH"
            return
        if value == 32:
            self.value = 32
            self.name = "MAX_TITLE_LENGTH"
            return
        if value == 255:
            self.value = 255
            self.name = "MAX_DESCRIPTION_LENGTH"
            return
        if value == 128:
            self.value = 128
            self.name = "MAX_PAYLOAD_LENGTH"
            return
        if value == 4:
            self.value = 4
            self.name = "MAX_TIP_AMOUNTS"
            return
        if value == 25000:
            self.value = 25000
            self.name = "MAX_STAR_COUNT"
            return
        if value == 2592000:
            self.value = 2592000
            self.name = "SUBSCRIPTION_PERIOD"
            return
        if value == 10000:
            self.value = 10000
            self.name = "SUBSCRIPTION_MAX_PRICE"
            return
        raise Error("InvoiceLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<InvoiceLimit." + self.name + ">"

@fieldwise_init
struct KeyboardButtonRequestUsersLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_QUANTITY = KeyboardButtonRequestUsersLimit(1, "MIN_QUANTITY")
    comptime MAX_QUANTITY = KeyboardButtonRequestUsersLimit(10, "MAX_QUANTITY")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_QUANTITY"
            return
        if value == 10:
            self.value = 10
            self.name = "MAX_QUANTITY"
            return
        raise Error("KeyboardButtonRequestUsersLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<KeyboardButtonRequestUsersLimit." + self.name + ">"

@fieldwise_init
struct KeyboardButtonStyle(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PRIMARY = KeyboardButtonStyle("primary", "PRIMARY")
    comptime SUCCESS = KeyboardButtonStyle("success", "SUCCESS")
    comptime DANGER = KeyboardButtonStyle("danger", "DANGER")
    comptime BLUE = KeyboardButtonStyle("primary", "PRIMARY")
    comptime GREEN = KeyboardButtonStyle("success", "SUCCESS")
    comptime RED = KeyboardButtonStyle("danger", "DANGER")

    def __init__(out self, value: String) raises:
        if value == "primary":
            self.value = "primary"
            self.name = "PRIMARY"
            return
        if value == "success":
            self.value = "success"
            self.name = "SUCCESS"
            return
        if value == "danger":
            self.value = "danger"
            self.name = "DANGER"
            return
        raise Error("KeyboardButtonStyle: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<KeyboardButtonStyle." + self.name + ">"

@fieldwise_init
struct LocationLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_CHAT_LOCATION_ADDRESS = LocationLimit(1, "MIN_CHAT_LOCATION_ADDRESS")
    comptime MAX_CHAT_LOCATION_ADDRESS = LocationLimit(64, "MAX_CHAT_LOCATION_ADDRESS")
    comptime HORIZONTAL_ACCURACY = LocationLimit(1500, "HORIZONTAL_ACCURACY")
    comptime MIN_HEADING = LocationLimit(1, "MIN_CHAT_LOCATION_ADDRESS")
    comptime MAX_HEADING = LocationLimit(360, "MAX_HEADING")
    comptime MIN_LIVE_PERIOD = LocationLimit(60, "MIN_LIVE_PERIOD")
    comptime MAX_LIVE_PERIOD = LocationLimit(86400, "MAX_LIVE_PERIOD")
    comptime LIVE_PERIOD_FOREVER = LocationLimit(2147483647, "LIVE_PERIOD_FOREVER")
    comptime MIN_PROXIMITY_ALERT_RADIUS = LocationLimit(1, "MIN_CHAT_LOCATION_ADDRESS")
    comptime MAX_PROXIMITY_ALERT_RADIUS = LocationLimit(100000, "MAX_PROXIMITY_ALERT_RADIUS")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_CHAT_LOCATION_ADDRESS"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_CHAT_LOCATION_ADDRESS"
            return
        if value == 1500:
            self.value = 1500
            self.name = "HORIZONTAL_ACCURACY"
            return
        if value == 360:
            self.value = 360
            self.name = "MAX_HEADING"
            return
        if value == 60:
            self.value = 60
            self.name = "MIN_LIVE_PERIOD"
            return
        if value == 86400:
            self.value = 86400
            self.name = "MAX_LIVE_PERIOD"
            return
        if value == 2147483647:
            self.value = 2147483647
            self.name = "LIVE_PERIOD_FOREVER"
            return
        if value == 100000:
            self.value = 100000
            self.name = "MAX_PROXIMITY_ALERT_RADIUS"
            return
        raise Error("LocationLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<LocationLimit." + self.name + ">"

@fieldwise_init
struct ManagedBotAccessLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_ALLOWED_USERS = ManagedBotAccessLimit(10, "MAX_ALLOWED_USERS")

    def __init__(out self, value: Int) raises:
        if value == 10:
            self.value = 10
            self.name = "MAX_ALLOWED_USERS"
            return
        raise Error("ManagedBotAccessLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ManagedBotAccessLimit." + self.name + ">"

@fieldwise_init
struct MaskPosition(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime FOREHEAD = MaskPosition("forehead", "FOREHEAD")
    comptime EYES = MaskPosition("eyes", "EYES")
    comptime MOUTH = MaskPosition("mouth", "MOUTH")
    comptime CHIN = MaskPosition("chin", "CHIN")

    def __init__(out self, value: String) raises:
        if value == "forehead":
            self.value = "forehead"
            self.name = "FOREHEAD"
            return
        if value == "eyes":
            self.value = "eyes"
            self.name = "EYES"
            return
        if value == "mouth":
            self.value = "mouth"
            self.name = "MOUTH"
            return
        if value == "chin":
            self.value = "chin"
            self.name = "CHIN"
            return
        raise Error("MaskPosition: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MaskPosition." + self.name + ">"

@fieldwise_init
struct MediaGroupLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_MEDIA_LENGTH = MediaGroupLimit(2, "MIN_MEDIA_LENGTH")
    comptime MAX_MEDIA_LENGTH = MediaGroupLimit(10, "MAX_MEDIA_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 2:
            self.value = 2
            self.name = "MIN_MEDIA_LENGTH"
            return
        if value == 10:
            self.value = 10
            self.name = "MAX_MEDIA_LENGTH"
            return
        raise Error("MediaGroupLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<MediaGroupLimit." + self.name + ">"

@fieldwise_init
struct MenuButtonType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime COMMANDS = MenuButtonType("commands", "COMMANDS")
    comptime WEB_APP = MenuButtonType("web_app", "WEB_APP")
    comptime DEFAULT = MenuButtonType("default", "DEFAULT")

    def __init__(out self, value: String) raises:
        if value == "commands":
            self.value = "commands"
            self.name = "COMMANDS"
            return
        if value == "web_app":
            self.value = "web_app"
            self.name = "WEB_APP"
            return
        if value == "default":
            self.value = "default"
            self.name = "DEFAULT"
            return
        raise Error("MenuButtonType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MenuButtonType." + self.name + ">"

@fieldwise_init
struct MessageAttachmentType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime ANIMATION = MessageAttachmentType("animation", "ANIMATION")
    comptime AUDIO = MessageAttachmentType("audio", "AUDIO")
    comptime CONTACT = MessageAttachmentType("contact", "CONTACT")
    comptime DICE = MessageAttachmentType("dice", "DICE")
    comptime DOCUMENT = MessageAttachmentType("document", "DOCUMENT")
    comptime GAME = MessageAttachmentType("game", "GAME")
    comptime INVOICE = MessageAttachmentType("invoice", "INVOICE")
    comptime LIVE_PHOTO = MessageAttachmentType("live_photo", "LIVE_PHOTO")
    comptime LOCATION = MessageAttachmentType("location", "LOCATION")
    comptime PAID_MEDIA = MessageAttachmentType("paid_media", "PAID_MEDIA")
    comptime PASSPORT_DATA = MessageAttachmentType("passport_data", "PASSPORT_DATA")
    comptime PHOTO = MessageAttachmentType("photo", "PHOTO")
    comptime POLL = MessageAttachmentType("poll", "POLL")
    comptime STICKER = MessageAttachmentType("sticker", "STICKER")
    comptime STORY = MessageAttachmentType("story", "STORY")
    comptime SUCCESSFUL_PAYMENT = MessageAttachmentType("successful_payment", "SUCCESSFUL_PAYMENT")
    comptime VIDEO = MessageAttachmentType("video", "VIDEO")
    comptime VIDEO_NOTE = MessageAttachmentType("video_note", "VIDEO_NOTE")
    comptime VOICE = MessageAttachmentType("voice", "VOICE")
    comptime VENUE = MessageAttachmentType("venue", "VENUE")

    def __init__(out self, value: String) raises:
        if value == "animation":
            self.value = "animation"
            self.name = "ANIMATION"
            return
        if value == "audio":
            self.value = "audio"
            self.name = "AUDIO"
            return
        if value == "contact":
            self.value = "contact"
            self.name = "CONTACT"
            return
        if value == "dice":
            self.value = "dice"
            self.name = "DICE"
            return
        if value == "document":
            self.value = "document"
            self.name = "DOCUMENT"
            return
        if value == "game":
            self.value = "game"
            self.name = "GAME"
            return
        if value == "invoice":
            self.value = "invoice"
            self.name = "INVOICE"
            return
        if value == "live_photo":
            self.value = "live_photo"
            self.name = "LIVE_PHOTO"
            return
        if value == "location":
            self.value = "location"
            self.name = "LOCATION"
            return
        if value == "paid_media":
            self.value = "paid_media"
            self.name = "PAID_MEDIA"
            return
        if value == "passport_data":
            self.value = "passport_data"
            self.name = "PASSPORT_DATA"
            return
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "poll":
            self.value = "poll"
            self.name = "POLL"
            return
        if value == "sticker":
            self.value = "sticker"
            self.name = "STICKER"
            return
        if value == "story":
            self.value = "story"
            self.name = "STORY"
            return
        if value == "successful_payment":
            self.value = "successful_payment"
            self.name = "SUCCESSFUL_PAYMENT"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "video_note":
            self.value = "video_note"
            self.name = "VIDEO_NOTE"
            return
        if value == "voice":
            self.value = "voice"
            self.name = "VOICE"
            return
        if value == "venue":
            self.value = "venue"
            self.name = "VENUE"
            return
        raise Error("MessageAttachmentType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MessageAttachmentType." + self.name + ">"

@fieldwise_init
struct MessageEntityDateTimeFormats(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime RELATIVE = MessageEntityDateTimeFormats("r", "RELATIVE")
    comptime LOCALIZED_WEEKDAY = MessageEntityDateTimeFormats("w", "LOCALIZED_WEEKDAY")
    comptime SHORT_DATE = MessageEntityDateTimeFormats("d", "SHORT_DATE")
    comptime LONG_DATE = MessageEntityDateTimeFormats("D", "LONG_DATE")
    comptime SHORT_TIME = MessageEntityDateTimeFormats("t", "SHORT_TIME")
    comptime LONG_TIME = MessageEntityDateTimeFormats("T", "LONG_TIME")
    comptime LOCALIZED_WEEKDAY_SHORT_DATE = MessageEntityDateTimeFormats("wd", "LOCALIZED_WEEKDAY_SHORT_DATE")
    comptime LOCALIZED_WEEKDAY_LONG_DATE = MessageEntityDateTimeFormats("wD", "LOCALIZED_WEEKDAY_LONG_DATE")
    comptime LOCALIZED_WEEKDAY_SHORT_TIME = MessageEntityDateTimeFormats("wt", "LOCALIZED_WEEKDAY_SHORT_TIME")
    comptime LOCALIZED_WEEKDAY_LONG_TIME = MessageEntityDateTimeFormats("wT", "LOCALIZED_WEEKDAY_LONG_TIME")
    comptime LOCALIZED_WEEKDAY_SHORT_DATE_SHORT_TIME = MessageEntityDateTimeFormats("wdt", "LOCALIZED_WEEKDAY_SHORT_DATE_SHORT_TIME")
    comptime LOCALIZED_WEEKDAY_SHORT_DATE_LONG_TIME = MessageEntityDateTimeFormats("wdT", "LOCALIZED_WEEKDAY_SHORT_DATE_LONG_TIME")
    comptime LOCALIZED_WEEKDAY_LONG_DATE_SHORT_TIME = MessageEntityDateTimeFormats("wDt", "LOCALIZED_WEEKDAY_LONG_DATE_SHORT_TIME")
    comptime LOCALIZED_WEEKDAY_LONG_DATE_LONG_TIME = MessageEntityDateTimeFormats("wDT", "LOCALIZED_WEEKDAY_LONG_DATE_LONG_TIME")
    comptime SHORT_DATE_SHORT_TIME = MessageEntityDateTimeFormats("dt", "SHORT_DATE_SHORT_TIME")
    comptime SHORT_DATE_LONG_TIME = MessageEntityDateTimeFormats("dT", "SHORT_DATE_LONG_TIME")
    comptime LONG_DATE_SHORT_TIME = MessageEntityDateTimeFormats("Dt", "LONG_DATE_SHORT_TIME")
    comptime LONG_DATE_LONG_TIME = MessageEntityDateTimeFormats("DT", "LONG_DATE_LONG_TIME")

    def __init__(out self, value: String) raises:
        if value == "r":
            self.value = "r"
            self.name = "RELATIVE"
            return
        if value == "w":
            self.value = "w"
            self.name = "LOCALIZED_WEEKDAY"
            return
        if value == "d":
            self.value = "d"
            self.name = "SHORT_DATE"
            return
        if value == "D":
            self.value = "D"
            self.name = "LONG_DATE"
            return
        if value == "t":
            self.value = "t"
            self.name = "SHORT_TIME"
            return
        if value == "T":
            self.value = "T"
            self.name = "LONG_TIME"
            return
        if value == "wd":
            self.value = "wd"
            self.name = "LOCALIZED_WEEKDAY_SHORT_DATE"
            return
        if value == "wD":
            self.value = "wD"
            self.name = "LOCALIZED_WEEKDAY_LONG_DATE"
            return
        if value == "wt":
            self.value = "wt"
            self.name = "LOCALIZED_WEEKDAY_SHORT_TIME"
            return
        if value == "wT":
            self.value = "wT"
            self.name = "LOCALIZED_WEEKDAY_LONG_TIME"
            return
        if value == "wdt":
            self.value = "wdt"
            self.name = "LOCALIZED_WEEKDAY_SHORT_DATE_SHORT_TIME"
            return
        if value == "wdT":
            self.value = "wdT"
            self.name = "LOCALIZED_WEEKDAY_SHORT_DATE_LONG_TIME"
            return
        if value == "wDt":
            self.value = "wDt"
            self.name = "LOCALIZED_WEEKDAY_LONG_DATE_SHORT_TIME"
            return
        if value == "wDT":
            self.value = "wDT"
            self.name = "LOCALIZED_WEEKDAY_LONG_DATE_LONG_TIME"
            return
        if value == "dt":
            self.value = "dt"
            self.name = "SHORT_DATE_SHORT_TIME"
            return
        if value == "dT":
            self.value = "dT"
            self.name = "SHORT_DATE_LONG_TIME"
            return
        if value == "Dt":
            self.value = "Dt"
            self.name = "LONG_DATE_SHORT_TIME"
            return
        if value == "DT":
            self.value = "DT"
            self.name = "LONG_DATE_LONG_TIME"
            return
        raise Error("MessageEntityDateTimeFormats: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MessageEntityDateTimeFormats." + self.name + ">"

@fieldwise_init
struct MessageEntityType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime BLOCKQUOTE = MessageEntityType("blockquote", "BLOCKQUOTE")
    comptime BOLD = MessageEntityType("bold", "BOLD")
    comptime BOT_COMMAND = MessageEntityType("bot_command", "BOT_COMMAND")
    comptime CASHTAG = MessageEntityType("cashtag", "CASHTAG")
    comptime CODE = MessageEntityType("code", "CODE")
    comptime CUSTOM_EMOJI = MessageEntityType("custom_emoji", "CUSTOM_EMOJI")
    comptime DATE_TIME = MessageEntityType("date_time", "DATE_TIME")
    comptime EMAIL = MessageEntityType("email", "EMAIL")
    comptime EXPANDABLE_BLOCKQUOTE = MessageEntityType("expandable_blockquote", "EXPANDABLE_BLOCKQUOTE")
    comptime HASHTAG = MessageEntityType("hashtag", "HASHTAG")
    comptime ITALIC = MessageEntityType("italic", "ITALIC")
    comptime MENTION = MessageEntityType("mention", "MENTION")
    comptime PHONE_NUMBER = MessageEntityType("phone_number", "PHONE_NUMBER")
    comptime PRE = MessageEntityType("pre", "PRE")
    comptime SPOILER = MessageEntityType("spoiler", "SPOILER")
    comptime STRIKETHROUGH = MessageEntityType("strikethrough", "STRIKETHROUGH")
    comptime TEXT_LINK = MessageEntityType("text_link", "TEXT_LINK")
    comptime TEXT_MENTION = MessageEntityType("text_mention", "TEXT_MENTION")
    comptime UNDERLINE = MessageEntityType("underline", "UNDERLINE")
    comptime URL = MessageEntityType("url", "URL")

    def __init__(out self, value: String) raises:
        if value == "blockquote":
            self.value = "blockquote"
            self.name = "BLOCKQUOTE"
            return
        if value == "bold":
            self.value = "bold"
            self.name = "BOLD"
            return
        if value == "bot_command":
            self.value = "bot_command"
            self.name = "BOT_COMMAND"
            return
        if value == "cashtag":
            self.value = "cashtag"
            self.name = "CASHTAG"
            return
        if value == "code":
            self.value = "code"
            self.name = "CODE"
            return
        if value == "custom_emoji":
            self.value = "custom_emoji"
            self.name = "CUSTOM_EMOJI"
            return
        if value == "date_time":
            self.value = "date_time"
            self.name = "DATE_TIME"
            return
        if value == "email":
            self.value = "email"
            self.name = "EMAIL"
            return
        if value == "expandable_blockquote":
            self.value = "expandable_blockquote"
            self.name = "EXPANDABLE_BLOCKQUOTE"
            return
        if value == "hashtag":
            self.value = "hashtag"
            self.name = "HASHTAG"
            return
        if value == "italic":
            self.value = "italic"
            self.name = "ITALIC"
            return
        if value == "mention":
            self.value = "mention"
            self.name = "MENTION"
            return
        if value == "phone_number":
            self.value = "phone_number"
            self.name = "PHONE_NUMBER"
            return
        if value == "pre":
            self.value = "pre"
            self.name = "PRE"
            return
        if value == "spoiler":
            self.value = "spoiler"
            self.name = "SPOILER"
            return
        if value == "strikethrough":
            self.value = "strikethrough"
            self.name = "STRIKETHROUGH"
            return
        if value == "text_link":
            self.value = "text_link"
            self.name = "TEXT_LINK"
            return
        if value == "text_mention":
            self.value = "text_mention"
            self.name = "TEXT_MENTION"
            return
        if value == "underline":
            self.value = "underline"
            self.name = "UNDERLINE"
            return
        if value == "url":
            self.value = "url"
            self.name = "URL"
            return
        raise Error("MessageEntityType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MessageEntityType." + self.name + ">"

@fieldwise_init
struct MessageLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_TEXT_LENGTH = MessageLimit(4096, "MAX_TEXT_LENGTH")
    comptime CAPTION_LENGTH = MessageLimit(1024, "CAPTION_LENGTH")
    comptime MIN_TEXT_LENGTH = MessageLimit(1, "MIN_TEXT_LENGTH")
    comptime DEEP_LINK_LENGTH = MessageLimit(64, "DEEP_LINK_LENGTH")
    comptime MESSAGE_ENTITIES = MessageLimit(100, "MESSAGE_ENTITIES")

    def __init__(out self, value: Int) raises:
        if value == 4096:
            self.value = 4096
            self.name = "MAX_TEXT_LENGTH"
            return
        if value == 1024:
            self.value = 1024
            self.name = "CAPTION_LENGTH"
            return
        if value == 1:
            self.value = 1
            self.name = "MIN_TEXT_LENGTH"
            return
        if value == 64:
            self.value = 64
            self.name = "DEEP_LINK_LENGTH"
            return
        if value == 100:
            self.value = 100
            self.name = "MESSAGE_ENTITIES"
            return
        raise Error("MessageLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<MessageLimit." + self.name + ">"

@fieldwise_init
struct MessageOriginType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime USER = MessageOriginType("user", "USER")
    comptime HIDDEN_USER = MessageOriginType("hidden_user", "HIDDEN_USER")
    comptime CHAT = MessageOriginType("chat", "CHAT")
    comptime CHANNEL = MessageOriginType("channel", "CHANNEL")

    def __init__(out self, value: String) raises:
        if value == "user":
            self.value = "user"
            self.name = "USER"
            return
        if value == "hidden_user":
            self.value = "hidden_user"
            self.name = "HIDDEN_USER"
            return
        if value == "chat":
            self.value = "chat"
            self.name = "CHAT"
            return
        if value == "channel":
            self.value = "channel"
            self.name = "CHANNEL"
            return
        raise Error("MessageOriginType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MessageOriginType." + self.name + ">"

@fieldwise_init
struct MessageType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime ANIMATION = MessageType("animation", "ANIMATION")
    comptime AUDIO = MessageType("audio", "AUDIO")
    comptime BOOST_ADDED = MessageType("boost_added", "BOOST_ADDED")
    comptime BUSINESS_CONNECTION_ID = MessageType("business_connection_id", "BUSINESS_CONNECTION_ID")
    comptime CHANNEL_CHAT_CREATED = MessageType("channel_chat_created", "CHANNEL_CHAT_CREATED")
    comptime CHAT_BACKGROUND_SET = MessageType("chat_background_set", "CHAT_BACKGROUND_SET")
    comptime CHAT_OWNER_CHANGED = MessageType("chat_owner_changed", "CHAT_OWNER_CHANGED")
    comptime CHAT_OWNER_LEFT = MessageType("chat_owner_left", "CHAT_OWNER_LEFT")
    comptime CHAT_SHARED = MessageType("chat_shared", "CHAT_SHARED")
    comptime CHECKLIST = MessageType("checklist", "CHECKLIST")
    comptime CHECKLIST_TASKS_ADDED = MessageType("checklist_tasks_added", "CHECKLIST_TASKS_ADDED")
    comptime CHECKLIST_TASKS_DONE = MessageType("checklist_tasks_done", "CHECKLIST_TASKS_DONE")
    comptime CONNECTED_WEBSITE = MessageType("connected_website", "CONNECTED_WEBSITE")
    comptime CONTACT = MessageType("contact", "CONTACT")
    comptime DELETE_CHAT_PHOTO = MessageType("delete_chat_photo", "DELETE_CHAT_PHOTO")
    comptime DICE = MessageType("dice", "DICE")
    comptime DIRECT_MESSAGE_PRICE_CHANGED = MessageType("direct_message_price_changed", "DIRECT_MESSAGE_PRICE_CHANGED")
    comptime DOCUMENT = MessageType("document", "DOCUMENT")
    comptime EFFECT_ID = MessageType("effect_id", "EFFECT_ID")
    comptime FORUM_TOPIC_CREATED = MessageType("forum_topic_created", "FORUM_TOPIC_CREATED")
    comptime FORUM_TOPIC_CLOSED = MessageType("forum_topic_closed", "FORUM_TOPIC_CLOSED")
    comptime FORUM_TOPIC_EDITED = MessageType("forum_topic_edited", "FORUM_TOPIC_EDITED")
    comptime FORUM_TOPIC_REOPENED = MessageType("forum_topic_reopened", "FORUM_TOPIC_REOPENED")
    comptime GAME = MessageType("game", "GAME")
    comptime GENERAL_FORUM_TOPIC_HIDDEN = MessageType("general_forum_topic_hidden", "GENERAL_FORUM_TOPIC_HIDDEN")
    comptime GENERAL_FORUM_TOPIC_UNHIDDEN = MessageType("general_forum_topic_unhidden", "GENERAL_FORUM_TOPIC_UNHIDDEN")
    comptime GIFT = MessageType("gift", "GIFT")
    comptime GIFT_UPGRADE_SENT = MessageType("gift_upgrade_sent", "GIFT_UPGRADE_SENT")
    comptime GIVEAWAY = MessageType("giveaway", "GIVEAWAY")
    comptime GIVEAWAY_CREATED = MessageType("giveaway_created", "GIVEAWAY_CREATED")
    comptime GIVEAWAY_WINNERS = MessageType("giveaway_winners", "GIVEAWAY_WINNERS")
    comptime GIVEAWAY_COMPLETED = MessageType("giveaway_completed", "GIVEAWAY_COMPLETED")
    comptime GROUP_CHAT_CREATED = MessageType("group_chat_created", "GROUP_CHAT_CREATED")
    comptime INVOICE = MessageType("invoice", "INVOICE")
    comptime LEFT_CHAT_MEMBER = MessageType("left_chat_member", "LEFT_CHAT_MEMBER")
    comptime LIVE_PHOTO = MessageType("live_photo", "LIVE_PHOTO")
    comptime LOCATION = MessageType("location", "LOCATION")
    comptime MANAGED_BOT_CREATED = MessageType("managed_bot_created", "MANAGED_BOT_CREATED")
    comptime MESSAGE_AUTO_DELETE_TIMER_CHANGED = MessageType("message_auto_delete_timer_changed", "MESSAGE_AUTO_DELETE_TIMER_CHANGED")
    comptime MIGRATE_TO_CHAT_ID = MessageType("migrate_to_chat_id", "MIGRATE_TO_CHAT_ID")
    comptime NEW_CHAT_MEMBERS = MessageType("new_chat_members", "NEW_CHAT_MEMBERS")
    comptime NEW_CHAT_TITLE = MessageType("new_chat_title", "NEW_CHAT_TITLE")
    comptime NEW_CHAT_PHOTO = MessageType("new_chat_photo", "NEW_CHAT_PHOTO")
    comptime PAID_MEDIA = MessageType("paid_media", "PAID_MEDIA")
    comptime PAID_MESSAGE_PRICE_CHANGED = MessageType("paid_message_price_changed", "PAID_MESSAGE_PRICE_CHANGED")
    comptime POLL_OPTION_ADDED = MessageType("poll_option_added", "POLL_OPTION_ADDED")
    comptime POLL_OPTION_DELETED = MessageType("poll_option_deleted", "POLL_OPTION_DELETED")
    comptime SUGGESTED_POST_APPROVAL_FAILED = MessageType("suggested_post_approval_failed", "SUGGESTED_POST_APPROVAL_FAILED")
    comptime SUGGESTED_POST_APPROVED = MessageType("suggested_post_approved", "SUGGESTED_POST_APPROVED")
    comptime SUGGESTED_POST_DECLINED = MessageType("suggested_post_declined", "SUGGESTED_POST_DECLINED")
    comptime SUGGESTED_POST_INFO = MessageType("suggested_post_info", "SUGGESTED_POST_INFO")
    comptime SUGGESTED_POST_PAID = MessageType("suggested_post_paid", "SUGGESTED_POST_PAID")
    comptime SUGGESTED_POST_REFUNDED = MessageType("suggested_post_refunded", "SUGGESTED_POST_REFUNDED")
    comptime PASSPORT_DATA = MessageType("passport_data", "PASSPORT_DATA")
    comptime PHOTO = MessageType("photo", "PHOTO")
    comptime PINNED_MESSAGE = MessageType("pinned_message", "PINNED_MESSAGE")
    comptime POLL = MessageType("poll", "POLL")
    comptime PROXIMITY_ALERT_TRIGGERED = MessageType("proximity_alert_triggered", "PROXIMITY_ALERT_TRIGGERED")
    comptime REFUNDED_PAYMENT = MessageType("refunded_payment", "REFUNDED_PAYMENT")
    comptime REPLY_TO_STORY = MessageType("reply_to_story", "REPLY_TO_STORY")
    comptime SENDER_BOOST_COUNT = MessageType("sender_boost_count", "SENDER_BOOST_COUNT")
    comptime SENDER_BUSINESS_BOT = MessageType("sender_business_bot", "SENDER_BUSINESS_BOT")
    comptime STICKER = MessageType("sticker", "STICKER")
    comptime STORY = MessageType("story", "STORY")
    comptime SUPERGROUP_CHAT_CREATED = MessageType("supergroup_chat_created", "SUPERGROUP_CHAT_CREATED")
    comptime SUCCESSFUL_PAYMENT = MessageType("successful_payment", "SUCCESSFUL_PAYMENT")
    comptime TEXT = MessageType("text", "TEXT")
    comptime UNIQUE_GIFT = MessageType("unique_gift", "UNIQUE_GIFT")
    comptime USERS_SHARED = MessageType("users_shared", "USERS_SHARED")
    comptime VENUE = MessageType("venue", "VENUE")
    comptime VIDEO = MessageType("video", "VIDEO")
    comptime VIDEO_CHAT_SCHEDULED = MessageType("video_chat_scheduled", "VIDEO_CHAT_SCHEDULED")
    comptime VIDEO_CHAT_STARTED = MessageType("video_chat_started", "VIDEO_CHAT_STARTED")
    comptime VIDEO_CHAT_ENDED = MessageType("video_chat_ended", "VIDEO_CHAT_ENDED")
    comptime VIDEO_CHAT_PARTICIPANTS_INVITED = MessageType("video_chat_participants_invited", "VIDEO_CHAT_PARTICIPANTS_INVITED")
    comptime VIDEO_NOTE = MessageType("video_note", "VIDEO_NOTE")
    comptime VOICE = MessageType("voice", "VOICE")
    comptime WEB_APP_DATA = MessageType("web_app_data", "WEB_APP_DATA")
    comptime WRITE_ACCESS_ALLOWED = MessageType("write_access_allowed", "WRITE_ACCESS_ALLOWED")

    def __init__(out self, value: String) raises:
        if value == "animation":
            self.value = "animation"
            self.name = "ANIMATION"
            return
        if value == "audio":
            self.value = "audio"
            self.name = "AUDIO"
            return
        if value == "boost_added":
            self.value = "boost_added"
            self.name = "BOOST_ADDED"
            return
        if value == "business_connection_id":
            self.value = "business_connection_id"
            self.name = "BUSINESS_CONNECTION_ID"
            return
        if value == "channel_chat_created":
            self.value = "channel_chat_created"
            self.name = "CHANNEL_CHAT_CREATED"
            return
        if value == "chat_background_set":
            self.value = "chat_background_set"
            self.name = "CHAT_BACKGROUND_SET"
            return
        if value == "chat_owner_changed":
            self.value = "chat_owner_changed"
            self.name = "CHAT_OWNER_CHANGED"
            return
        if value == "chat_owner_left":
            self.value = "chat_owner_left"
            self.name = "CHAT_OWNER_LEFT"
            return
        if value == "chat_shared":
            self.value = "chat_shared"
            self.name = "CHAT_SHARED"
            return
        if value == "checklist":
            self.value = "checklist"
            self.name = "CHECKLIST"
            return
        if value == "checklist_tasks_added":
            self.value = "checklist_tasks_added"
            self.name = "CHECKLIST_TASKS_ADDED"
            return
        if value == "checklist_tasks_done":
            self.value = "checklist_tasks_done"
            self.name = "CHECKLIST_TASKS_DONE"
            return
        if value == "connected_website":
            self.value = "connected_website"
            self.name = "CONNECTED_WEBSITE"
            return
        if value == "contact":
            self.value = "contact"
            self.name = "CONTACT"
            return
        if value == "delete_chat_photo":
            self.value = "delete_chat_photo"
            self.name = "DELETE_CHAT_PHOTO"
            return
        if value == "dice":
            self.value = "dice"
            self.name = "DICE"
            return
        if value == "direct_message_price_changed":
            self.value = "direct_message_price_changed"
            self.name = "DIRECT_MESSAGE_PRICE_CHANGED"
            return
        if value == "document":
            self.value = "document"
            self.name = "DOCUMENT"
            return
        if value == "effect_id":
            self.value = "effect_id"
            self.name = "EFFECT_ID"
            return
        if value == "forum_topic_created":
            self.value = "forum_topic_created"
            self.name = "FORUM_TOPIC_CREATED"
            return
        if value == "forum_topic_closed":
            self.value = "forum_topic_closed"
            self.name = "FORUM_TOPIC_CLOSED"
            return
        if value == "forum_topic_edited":
            self.value = "forum_topic_edited"
            self.name = "FORUM_TOPIC_EDITED"
            return
        if value == "forum_topic_reopened":
            self.value = "forum_topic_reopened"
            self.name = "FORUM_TOPIC_REOPENED"
            return
        if value == "game":
            self.value = "game"
            self.name = "GAME"
            return
        if value == "general_forum_topic_hidden":
            self.value = "general_forum_topic_hidden"
            self.name = "GENERAL_FORUM_TOPIC_HIDDEN"
            return
        if value == "general_forum_topic_unhidden":
            self.value = "general_forum_topic_unhidden"
            self.name = "GENERAL_FORUM_TOPIC_UNHIDDEN"
            return
        if value == "gift":
            self.value = "gift"
            self.name = "GIFT"
            return
        if value == "gift_upgrade_sent":
            self.value = "gift_upgrade_sent"
            self.name = "GIFT_UPGRADE_SENT"
            return
        if value == "giveaway":
            self.value = "giveaway"
            self.name = "GIVEAWAY"
            return
        if value == "giveaway_created":
            self.value = "giveaway_created"
            self.name = "GIVEAWAY_CREATED"
            return
        if value == "giveaway_winners":
            self.value = "giveaway_winners"
            self.name = "GIVEAWAY_WINNERS"
            return
        if value == "giveaway_completed":
            self.value = "giveaway_completed"
            self.name = "GIVEAWAY_COMPLETED"
            return
        if value == "group_chat_created":
            self.value = "group_chat_created"
            self.name = "GROUP_CHAT_CREATED"
            return
        if value == "invoice":
            self.value = "invoice"
            self.name = "INVOICE"
            return
        if value == "left_chat_member":
            self.value = "left_chat_member"
            self.name = "LEFT_CHAT_MEMBER"
            return
        if value == "live_photo":
            self.value = "live_photo"
            self.name = "LIVE_PHOTO"
            return
        if value == "location":
            self.value = "location"
            self.name = "LOCATION"
            return
        if value == "managed_bot_created":
            self.value = "managed_bot_created"
            self.name = "MANAGED_BOT_CREATED"
            return
        if value == "message_auto_delete_timer_changed":
            self.value = "message_auto_delete_timer_changed"
            self.name = "MESSAGE_AUTO_DELETE_TIMER_CHANGED"
            return
        if value == "migrate_to_chat_id":
            self.value = "migrate_to_chat_id"
            self.name = "MIGRATE_TO_CHAT_ID"
            return
        if value == "new_chat_members":
            self.value = "new_chat_members"
            self.name = "NEW_CHAT_MEMBERS"
            return
        if value == "new_chat_title":
            self.value = "new_chat_title"
            self.name = "NEW_CHAT_TITLE"
            return
        if value == "new_chat_photo":
            self.value = "new_chat_photo"
            self.name = "NEW_CHAT_PHOTO"
            return
        if value == "paid_media":
            self.value = "paid_media"
            self.name = "PAID_MEDIA"
            return
        if value == "paid_message_price_changed":
            self.value = "paid_message_price_changed"
            self.name = "PAID_MESSAGE_PRICE_CHANGED"
            return
        if value == "poll_option_added":
            self.value = "poll_option_added"
            self.name = "POLL_OPTION_ADDED"
            return
        if value == "poll_option_deleted":
            self.value = "poll_option_deleted"
            self.name = "POLL_OPTION_DELETED"
            return
        if value == "suggested_post_approval_failed":
            self.value = "suggested_post_approval_failed"
            self.name = "SUGGESTED_POST_APPROVAL_FAILED"
            return
        if value == "suggested_post_approved":
            self.value = "suggested_post_approved"
            self.name = "SUGGESTED_POST_APPROVED"
            return
        if value == "suggested_post_declined":
            self.value = "suggested_post_declined"
            self.name = "SUGGESTED_POST_DECLINED"
            return
        if value == "suggested_post_info":
            self.value = "suggested_post_info"
            self.name = "SUGGESTED_POST_INFO"
            return
        if value == "suggested_post_paid":
            self.value = "suggested_post_paid"
            self.name = "SUGGESTED_POST_PAID"
            return
        if value == "suggested_post_refunded":
            self.value = "suggested_post_refunded"
            self.name = "SUGGESTED_POST_REFUNDED"
            return
        if value == "passport_data":
            self.value = "passport_data"
            self.name = "PASSPORT_DATA"
            return
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "pinned_message":
            self.value = "pinned_message"
            self.name = "PINNED_MESSAGE"
            return
        if value == "poll":
            self.value = "poll"
            self.name = "POLL"
            return
        if value == "proximity_alert_triggered":
            self.value = "proximity_alert_triggered"
            self.name = "PROXIMITY_ALERT_TRIGGERED"
            return
        if value == "refunded_payment":
            self.value = "refunded_payment"
            self.name = "REFUNDED_PAYMENT"
            return
        if value == "reply_to_story":
            self.value = "reply_to_story"
            self.name = "REPLY_TO_STORY"
            return
        if value == "sender_boost_count":
            self.value = "sender_boost_count"
            self.name = "SENDER_BOOST_COUNT"
            return
        if value == "sender_business_bot":
            self.value = "sender_business_bot"
            self.name = "SENDER_BUSINESS_BOT"
            return
        if value == "sticker":
            self.value = "sticker"
            self.name = "STICKER"
            return
        if value == "story":
            self.value = "story"
            self.name = "STORY"
            return
        if value == "supergroup_chat_created":
            self.value = "supergroup_chat_created"
            self.name = "SUPERGROUP_CHAT_CREATED"
            return
        if value == "successful_payment":
            self.value = "successful_payment"
            self.name = "SUCCESSFUL_PAYMENT"
            return
        if value == "text":
            self.value = "text"
            self.name = "TEXT"
            return
        if value == "unique_gift":
            self.value = "unique_gift"
            self.name = "UNIQUE_GIFT"
            return
        if value == "users_shared":
            self.value = "users_shared"
            self.name = "USERS_SHARED"
            return
        if value == "venue":
            self.value = "venue"
            self.name = "VENUE"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "video_chat_scheduled":
            self.value = "video_chat_scheduled"
            self.name = "VIDEO_CHAT_SCHEDULED"
            return
        if value == "video_chat_started":
            self.value = "video_chat_started"
            self.name = "VIDEO_CHAT_STARTED"
            return
        if value == "video_chat_ended":
            self.value = "video_chat_ended"
            self.name = "VIDEO_CHAT_ENDED"
            return
        if value == "video_chat_participants_invited":
            self.value = "video_chat_participants_invited"
            self.name = "VIDEO_CHAT_PARTICIPANTS_INVITED"
            return
        if value == "video_note":
            self.value = "video_note"
            self.name = "VIDEO_NOTE"
            return
        if value == "voice":
            self.value = "voice"
            self.name = "VOICE"
            return
        if value == "web_app_data":
            self.value = "web_app_data"
            self.name = "WEB_APP_DATA"
            return
        if value == "write_access_allowed":
            self.value = "write_access_allowed"
            self.name = "WRITE_ACCESS_ALLOWED"
            return
        raise Error("MessageType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<MessageType." + self.name + ">"

@fieldwise_init
struct Nanostar(Equatable, ImplicitlyCopyable):
    var value: Float64
    var name: String

    comptime VALUE = Nanostar(1e-09, "VALUE")

    def __init__(out self, value: Float64) raises:
        if value == 1e-09:
            self.value = 1e-09
            self.name = "VALUE"
            return
        raise Error("Nanostar: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Float64) -> Bool:
        return self.value == other

    def __float__(self) -> Float64:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<Nanostar." + self.name + ">"

@fieldwise_init
struct NanostarLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_AMOUNT = NanostarLimit(-999999999, "MIN_AMOUNT")
    comptime MAX_AMOUNT = NanostarLimit(999999999, "MAX_AMOUNT")

    def __init__(out self, value: Int) raises:
        if value == -999999999:
            self.value = -999999999
            self.name = "MIN_AMOUNT"
            return
        if value == 999999999:
            self.value = 999999999
            self.name = "MAX_AMOUNT"
            return
        raise Error("NanostarLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<NanostarLimit." + self.name + ">"

@fieldwise_init
struct OwnedGiftType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime REGULAR = OwnedGiftType("regular", "REGULAR")
    comptime UNIQUE = OwnedGiftType("unique", "UNIQUE")

    def __init__(out self, value: String) raises:
        if value == "regular":
            self.value = "regular"
            self.name = "REGULAR"
            return
        if value == "unique":
            self.value = "unique"
            self.name = "UNIQUE"
            return
        raise Error("OwnedGiftType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<OwnedGiftType." + self.name + ">"

@fieldwise_init
struct PaidMediaType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PREVIEW = PaidMediaType("preview", "PREVIEW")
    comptime VIDEO = PaidMediaType("video", "VIDEO")
    comptime PHOTO = PaidMediaType("photo", "PHOTO")
    comptime LIVE_PHOTO = PaidMediaType("live_photo", "LIVE_PHOTO")

    def __init__(out self, value: String) raises:
        if value == "preview":
            self.value = "preview"
            self.name = "PREVIEW"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        if value == "photo":
            self.value = "photo"
            self.name = "PHOTO"
            return
        if value == "live_photo":
            self.value = "live_photo"
            self.name = "LIVE_PHOTO"
            return
        raise Error("PaidMediaType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<PaidMediaType." + self.name + ">"

@fieldwise_init
struct ParseMode(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime MARKDOWN = ParseMode("Markdown", "MARKDOWN")
    comptime MARKDOWN_V2 = ParseMode("MarkdownV2", "MARKDOWN_V2")
    comptime HTML = ParseMode("HTML", "HTML")

    def __init__(out self, value: String) raises:
        if value == "Markdown":
            self.value = "Markdown"
            self.name = "MARKDOWN"
            return
        if value == "MarkdownV2":
            self.value = "MarkdownV2"
            self.name = "MARKDOWN_V2"
            return
        if value == "HTML":
            self.value = "HTML"
            self.name = "HTML"
            return
        raise Error("ParseMode: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ParseMode." + self.name + ">"

@fieldwise_init
struct PersonalChatMessagesLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_LIMIT = PersonalChatMessagesLimit(1, "MIN_LIMIT")
    comptime MAX_LIMIT = PersonalChatMessagesLimit(20, "MAX_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_LIMIT"
            return
        if value == 20:
            self.value = 20
            self.name = "MAX_LIMIT"
            return
        raise Error("PersonalChatMessagesLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<PersonalChatMessagesLimit." + self.name + ">"

@fieldwise_init
struct PollLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_QUESTION_LENGTH = PollLimit(1, "MIN_QUESTION_LENGTH")
    comptime MAX_QUESTION_LENGTH = PollLimit(300, "MAX_QUESTION_LENGTH")
    comptime MIN_OPTION_LENGTH = PollLimit(1, "MIN_QUESTION_LENGTH")
    comptime MAX_OPTION_LENGTH = PollLimit(100, "MAX_OPTION_LENGTH")
    comptime MIN_OPTION_NUMBER = PollLimit(1, "MIN_QUESTION_LENGTH")
    comptime MAX_OPTION_NUMBER = PollLimit(12, "MAX_OPTION_NUMBER")
    comptime MAX_EXPLANATION_LENGTH = PollLimit(200, "MAX_EXPLANATION_LENGTH")
    comptime MAX_EXPLANATION_LINE_FEEDS = PollLimit(2, "MAX_EXPLANATION_LINE_FEEDS")
    comptime MIN_OPEN_PERIOD = PollLimit(5, "MIN_OPEN_PERIOD")
    comptime MAX_OPEN_PERIOD = PollLimit(2628000, "MAX_OPEN_PERIOD")
    comptime MAX_DESCRIPTION_CHARACTERS = PollLimit(1024, "MAX_DESCRIPTION_CHARACTERS")
    comptime MIN_MEMBERSHIP_HOURS = PollLimit(24, "MIN_MEMBERSHIP_HOURS")
    comptime MAX_COUNTRY_CODES = PollLimit(12, "MAX_OPTION_NUMBER")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_QUESTION_LENGTH"
            return
        if value == 300:
            self.value = 300
            self.name = "MAX_QUESTION_LENGTH"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_OPTION_LENGTH"
            return
        if value == 12:
            self.value = 12
            self.name = "MAX_OPTION_NUMBER"
            return
        if value == 200:
            self.value = 200
            self.name = "MAX_EXPLANATION_LENGTH"
            return
        if value == 2:
            self.value = 2
            self.name = "MAX_EXPLANATION_LINE_FEEDS"
            return
        if value == 5:
            self.value = 5
            self.name = "MIN_OPEN_PERIOD"
            return
        if value == 2628000:
            self.value = 2628000
            self.name = "MAX_OPEN_PERIOD"
            return
        if value == 1024:
            self.value = 1024
            self.name = "MAX_DESCRIPTION_CHARACTERS"
            return
        if value == 24:
            self.value = 24
            self.name = "MIN_MEMBERSHIP_HOURS"
            return
        raise Error("PollLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<PollLimit." + self.name + ">"

@fieldwise_init
struct PollType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime REGULAR = PollType("regular", "REGULAR")
    comptime QUIZ = PollType("quiz", "QUIZ")

    def __init__(out self, value: String) raises:
        if value == "regular":
            self.value = "regular"
            self.name = "REGULAR"
            return
        if value == "quiz":
            self.value = "quiz"
            self.name = "QUIZ"
            return
        raise Error("PollType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<PollType." + self.name + ">"

@fieldwise_init
struct PollingLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_LIMIT = PollingLimit(1, "MIN_LIMIT")
    comptime MAX_LIMIT = PollingLimit(100, "MAX_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_LIMIT"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_LIMIT"
            return
        raise Error("PollingLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<PollingLimit." + self.name + ">"

@fieldwise_init
struct PremiumSubscription(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_TEXT_LENGTH = PremiumSubscription(128, "MAX_TEXT_LENGTH")
    comptime MONTH_COUNT_THREE = PremiumSubscription(3, "MONTH_COUNT_THREE")
    comptime MONTH_COUNT_SIX = PremiumSubscription(6, "MONTH_COUNT_SIX")
    comptime MONTH_COUNT_TWELVE = PremiumSubscription(12, "MONTH_COUNT_TWELVE")
    comptime STARS_THREE_MONTHS = PremiumSubscription(1000, "STARS_THREE_MONTHS")
    comptime STARS_SIX_MONTHS = PremiumSubscription(1500, "STARS_SIX_MONTHS")
    comptime STARS_TWELVE_MONTHS = PremiumSubscription(2500, "STARS_TWELVE_MONTHS")

    def __init__(out self, value: Int) raises:
        if value == 128:
            self.value = 128
            self.name = "MAX_TEXT_LENGTH"
            return
        if value == 3:
            self.value = 3
            self.name = "MONTH_COUNT_THREE"
            return
        if value == 6:
            self.value = 6
            self.name = "MONTH_COUNT_SIX"
            return
        if value == 12:
            self.value = 12
            self.name = "MONTH_COUNT_TWELVE"
            return
        if value == 1000:
            self.value = 1000
            self.name = "STARS_THREE_MONTHS"
            return
        if value == 1500:
            self.value = 1500
            self.name = "STARS_SIX_MONTHS"
            return
        if value == 2500:
            self.value = 2500
            self.name = "STARS_TWELVE_MONTHS"
            return
        raise Error("PremiumSubscription: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<PremiumSubscription." + self.name + ">"

@fieldwise_init
struct ProfileAccentColor(Equatable, ImplicitlyCopyable):
    var value: _AccentColor
    var name: String

    comptime COLOR_000 = ProfileAccentColor(_AccentColor(0, "", False, _ColorTuple(12211792, 0, 0, 1), _ColorTuple(10241344, 0, 0, 1)), "COLOR_000")
    comptime COLOR_001 = ProfileAccentColor(_AccentColor(1, "", False, _ColorTuple(12745790, 0, 0, 1), _ColorTuple(9723436, 0, 0, 1)), "COLOR_001")
    comptime COLOR_002 = ProfileAccentColor(_AccentColor(2, "", False, _ColorTuple(9792200, 0, 0, 1), _ColorTuple(7426201, 0, 0, 1)), "COLOR_002")
    comptime COLOR_003 = ProfileAccentColor(_AccentColor(3, "", False, _ColorTuple(4825941, 0, 0, 1), _ColorTuple(3371323, 0, 0, 1)), "COLOR_003")
    comptime COLOR_004 = ProfileAccentColor(_AccentColor(4, "", False, _ColorTuple(4102061, 0, 0, 1), _ColorTuple(3702407, 0, 0, 1)), "COLOR_004")
    comptime COLOR_005 = ProfileAccentColor(_AccentColor(5, "", False, _ColorTuple(5935035, 0, 0, 1), _ColorTuple(4682132, 0, 0, 1)), "COLOR_005")
    comptime COLOR_006 = ProfileAccentColor(_AccentColor(6, "", False, _ColorTuple(12079992, 0, 0, 1), _ColorTuple(9717603, 0, 0, 1)), "COLOR_006")
    comptime COLOR_007 = ProfileAccentColor(_AccentColor(7, "", False, _ColorTuple(8358805, 0, 0, 1), _ColorTuple(4412001, 0, 0, 1)), "COLOR_007")
    comptime COLOR_008 = ProfileAccentColor(_AccentColor(8, "", False, _ColorTuple(13194845, 14253143, 0, 2), _ColorTuple(10044227, 11294782, 0, 2)), "COLOR_008")
    comptime COLOR_009 = ProfileAccentColor(_AccentColor(9, "", False, _ColorTuple(13595204, 13407283, 0, 2), _ColorTuple(9393455, 10580530, 0, 2)), "COLOR_009")
    comptime COLOR_010 = ProfileAccentColor(_AccentColor(10, "", False, _ColorTuple(9855700, 12150454, 0, 2), _ColorTuple(6506129, 9588898, 0, 2)), "COLOR_010")
    comptime COLOR_011 = ProfileAccentColor(_AccentColor(11, "", False, _ColorTuple(4036437, 9021008, 0, 2), _ColorTuple(2714179, 6262596, 0, 2)), "COLOR_011")
    comptime COLOR_012 = ProfileAccentColor(_AccentColor(12, "", False, _ColorTuple(4036026, 5287320, 0, 2), _ColorTuple(3173500, 4102270, 0, 2)), "COLOR_012")
    comptime COLOR_013 = ProfileAccentColor(_AccentColor(13, "", False, _ColorTuple(5475266, 5089469, 0, 2), _ColorTuple(3694988, 4557729, 0, 2)), "COLOR_013")
    comptime COLOR_014 = ProfileAccentColor(_AccentColor(14, "", False, _ColorTuple(11554676, 13723245, 0, 2), _ColorTuple(8929632, 10900057, 0, 2)), "COLOR_014")
    comptime COLOR_015 = ProfileAccentColor(_AccentColor(15, "", False, _ColorTuple(6517890, 8096407, 0, 2), _ColorTuple(5464174, 3688020, 0, 2)), "COLOR_015")

    def __init__(out self, value: _AccentColor) raises:
        if value == _AccentColor(0, "", False, _ColorTuple(12211792, 0, 0, 1), _ColorTuple(10241344, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_000"
            return
        if value == _AccentColor(1, "", False, _ColorTuple(12745790, 0, 0, 1), _ColorTuple(9723436, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_001"
            return
        if value == _AccentColor(2, "", False, _ColorTuple(9792200, 0, 0, 1), _ColorTuple(7426201, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_002"
            return
        if value == _AccentColor(3, "", False, _ColorTuple(4825941, 0, 0, 1), _ColorTuple(3371323, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_003"
            return
        if value == _AccentColor(4, "", False, _ColorTuple(4102061, 0, 0, 1), _ColorTuple(3702407, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_004"
            return
        if value == _AccentColor(5, "", False, _ColorTuple(5935035, 0, 0, 1), _ColorTuple(4682132, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_005"
            return
        if value == _AccentColor(6, "", False, _ColorTuple(12079992, 0, 0, 1), _ColorTuple(9717603, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_006"
            return
        if value == _AccentColor(7, "", False, _ColorTuple(8358805, 0, 0, 1), _ColorTuple(4412001, 0, 0, 1)):
            self.value = value.copy()
            self.name = "COLOR_007"
            return
        if value == _AccentColor(8, "", False, _ColorTuple(13194845, 14253143, 0, 2), _ColorTuple(10044227, 11294782, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_008"
            return
        if value == _AccentColor(9, "", False, _ColorTuple(13595204, 13407283, 0, 2), _ColorTuple(9393455, 10580530, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_009"
            return
        if value == _AccentColor(10, "", False, _ColorTuple(9855700, 12150454, 0, 2), _ColorTuple(6506129, 9588898, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_010"
            return
        if value == _AccentColor(11, "", False, _ColorTuple(4036437, 9021008, 0, 2), _ColorTuple(2714179, 6262596, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_011"
            return
        if value == _AccentColor(12, "", False, _ColorTuple(4036026, 5287320, 0, 2), _ColorTuple(3173500, 4102270, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_012"
            return
        if value == _AccentColor(13, "", False, _ColorTuple(5475266, 5089469, 0, 2), _ColorTuple(3694988, 4557729, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_013"
            return
        if value == _AccentColor(14, "", False, _ColorTuple(11554676, 13723245, 0, 2), _ColorTuple(8929632, 10900057, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_014"
            return
        if value == _AccentColor(15, "", False, _ColorTuple(6517890, 8096407, 0, 2), _ColorTuple(5464174, 3688020, 0, 2)):
            self.value = value.copy()
            self.name = "COLOR_015"
            return
        raise Error("ProfileAccentColor: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __repr__(self) -> String:
        return "<ProfileAccentColor." + self.name + ">"

@fieldwise_init
struct ReactionEmoji(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime THUMBS_UP = ReactionEmoji("👍", "THUMBS_UP")
    comptime THUMBS_DOWN = ReactionEmoji("👎", "THUMBS_DOWN")
    comptime RED_HEART = ReactionEmoji("❤", "RED_HEART")
    comptime FIRE = ReactionEmoji("🔥", "FIRE")
    comptime SMILING_FACE_WITH_HEARTS = ReactionEmoji("🥰", "SMILING_FACE_WITH_HEARTS")
    comptime CLAPPING_HANDS = ReactionEmoji("👏", "CLAPPING_HANDS")
    comptime GRINNING_FACE_WITH_SMILING_EYES = ReactionEmoji("😁", "GRINNING_FACE_WITH_SMILING_EYES")
    comptime THINKING_FACE = ReactionEmoji("🤔", "THINKING_FACE")
    comptime SHOCKED_FACE_WITH_EXPLODING_HEAD = ReactionEmoji("🤯", "SHOCKED_FACE_WITH_EXPLODING_HEAD")
    comptime FACE_SCREAMING_IN_FEAR = ReactionEmoji("😱", "FACE_SCREAMING_IN_FEAR")
    comptime SERIOUS_FACE_WITH_SYMBOLS_COVERING_MOUTH = ReactionEmoji("🤬", "SERIOUS_FACE_WITH_SYMBOLS_COVERING_MOUTH")
    comptime CRYING_FACE = ReactionEmoji("😢", "CRYING_FACE")
    comptime PARTY_POPPER = ReactionEmoji("🎉", "PARTY_POPPER")
    comptime GRINNING_FACE_WITH_STAR_EYES = ReactionEmoji("🤩", "GRINNING_FACE_WITH_STAR_EYES")
    comptime FACE_WITH_OPEN_MOUTH_VOMITING = ReactionEmoji("🤮", "FACE_WITH_OPEN_MOUTH_VOMITING")
    comptime PILE_OF_POO = ReactionEmoji("💩", "PILE_OF_POO")
    comptime PERSON_WITH_FOLDED_HANDS = ReactionEmoji("🙏", "PERSON_WITH_FOLDED_HANDS")
    comptime OK_HAND_SIGN = ReactionEmoji("👌", "OK_HAND_SIGN")
    comptime DOVE_OF_PEACE = ReactionEmoji("🕊", "DOVE_OF_PEACE")
    comptime CLOWN_FACE = ReactionEmoji("🤡", "CLOWN_FACE")
    comptime YAWNING_FACE = ReactionEmoji("🥱", "YAWNING_FACE")
    comptime FACE_WITH_UNEVEN_EYES_AND_WAVY_MOUTH = ReactionEmoji("🥴", "FACE_WITH_UNEVEN_EYES_AND_WAVY_MOUTH")
    comptime SMILING_FACE_WITH_HEART_SHAPED_EYES = ReactionEmoji("😍", "SMILING_FACE_WITH_HEART_SHAPED_EYES")
    comptime SPOUTING_WHALE = ReactionEmoji("🐳", "SPOUTING_WHALE")
    comptime HEART_ON_FIRE = ReactionEmoji("❤️‍🔥", "HEART_ON_FIRE")
    comptime NEW_MOON_WITH_FACE = ReactionEmoji("🌚", "NEW_MOON_WITH_FACE")
    comptime HOT_DOG = ReactionEmoji("🌭", "HOT_DOG")
    comptime HUNDRED_POINTS_SYMBOL = ReactionEmoji("💯", "HUNDRED_POINTS_SYMBOL")
    comptime ROLLING_ON_THE_FLOOR_LAUGHING = ReactionEmoji("🤣", "ROLLING_ON_THE_FLOOR_LAUGHING")
    comptime HIGH_VOLTAGE_SIGN = ReactionEmoji("⚡", "HIGH_VOLTAGE_SIGN")
    comptime BANANA = ReactionEmoji("🍌", "BANANA")
    comptime TROPHY = ReactionEmoji("🏆", "TROPHY")
    comptime BROKEN_HEART = ReactionEmoji("💔", "BROKEN_HEART")
    comptime FACE_WITH_ONE_EYEBROW_RAISED = ReactionEmoji("🤨", "FACE_WITH_ONE_EYEBROW_RAISED")
    comptime NEUTRAL_FACE = ReactionEmoji("😐", "NEUTRAL_FACE")
    comptime STRAWBERRY = ReactionEmoji("🍓", "STRAWBERRY")
    comptime BOTTLE_WITH_POPPING_CORK = ReactionEmoji("🍾", "BOTTLE_WITH_POPPING_CORK")
    comptime KISS_MARK = ReactionEmoji("💋", "KISS_MARK")
    comptime REVERSED_HAND_WITH_MIDDLE_FINGER_EXTENDED = ReactionEmoji("🖕", "REVERSED_HAND_WITH_MIDDLE_FINGER_EXTENDED")
    comptime SMILING_FACE_WITH_HORNS = ReactionEmoji("😈", "SMILING_FACE_WITH_HORNS")
    comptime SLEEPING_FACE = ReactionEmoji("😴", "SLEEPING_FACE")
    comptime LOUDLY_CRYING_FACE = ReactionEmoji("😭", "LOUDLY_CRYING_FACE")
    comptime NERD_FACE = ReactionEmoji("🤓", "NERD_FACE")
    comptime GHOST = ReactionEmoji("👻", "GHOST")
    comptime MAN_TECHNOLOGIST = ReactionEmoji("👨‍💻", "MAN_TECHNOLOGIST")
    comptime EYES = ReactionEmoji("👀", "EYES")
    comptime JACK_O_LANTERN = ReactionEmoji("🎃", "JACK_O_LANTERN")
    comptime SEE_NO_EVIL_MONKEY = ReactionEmoji("🙈", "SEE_NO_EVIL_MONKEY")
    comptime SMILING_FACE_WITH_HALO = ReactionEmoji("😇", "SMILING_FACE_WITH_HALO")
    comptime FEARFUL_FACE = ReactionEmoji("😨", "FEARFUL_FACE")
    comptime HANDSHAKE = ReactionEmoji("🤝", "HANDSHAKE")
    comptime WRITING_HAND = ReactionEmoji("✍", "WRITING_HAND")
    comptime HUGGING_FACE = ReactionEmoji("🤗", "HUGGING_FACE")
    comptime SALUTING_FACE = ReactionEmoji("🫡", "SALUTING_FACE")
    comptime FATHER_CHRISTMAS = ReactionEmoji("🎅", "FATHER_CHRISTMAS")
    comptime CHRISTMAS_TREE = ReactionEmoji("🎄", "CHRISTMAS_TREE")
    comptime SNOWMAN = ReactionEmoji("☃", "SNOWMAN")
    comptime NAIL_POLISH = ReactionEmoji("💅", "NAIL_POLISH")
    comptime GRINNING_FACE_WITH_ONE_LARGE_AND_ONE_SMALL_EYE = ReactionEmoji("🤪", "GRINNING_FACE_WITH_ONE_LARGE_AND_ONE_SMALL_EYE")
    comptime MOYAI = ReactionEmoji("🗿", "MOYAI")
    comptime SQUARED_COOL = ReactionEmoji("🆒", "SQUARED_COOL")
    comptime HEART_WITH_ARROW = ReactionEmoji("💘", "HEART_WITH_ARROW")
    comptime HEAR_NO_EVIL_MONKEY = ReactionEmoji("🙉", "HEAR_NO_EVIL_MONKEY")
    comptime UNICORN_FACE = ReactionEmoji("🦄", "UNICORN_FACE")
    comptime FACE_THROWING_A_KISS = ReactionEmoji("😘", "FACE_THROWING_A_KISS")
    comptime PILL = ReactionEmoji("💊", "PILL")
    comptime SPEAK_NO_EVIL_MONKEY = ReactionEmoji("🙊", "SPEAK_NO_EVIL_MONKEY")
    comptime SMILING_FACE_WITH_SUNGLASSES = ReactionEmoji("😎", "SMILING_FACE_WITH_SUNGLASSES")
    comptime ALIEN_MONSTER = ReactionEmoji("👾", "ALIEN_MONSTER")
    comptime MAN_SHRUGGING = ReactionEmoji("🤷‍♂️", "MAN_SHRUGGING")
    comptime SHRUG = ReactionEmoji("🤷", "SHRUG")
    comptime WOMAN_SHRUGGING = ReactionEmoji("🤷‍♀️", "WOMAN_SHRUGGING")
    comptime POUTING_FACE = ReactionEmoji("😡", "POUTING_FACE")

    def __init__(out self, value: String) raises:
        if value == "👍":
            self.value = "👍"
            self.name = "THUMBS_UP"
            return
        if value == "👎":
            self.value = "👎"
            self.name = "THUMBS_DOWN"
            return
        if value == "❤":
            self.value = "❤"
            self.name = "RED_HEART"
            return
        if value == "🔥":
            self.value = "🔥"
            self.name = "FIRE"
            return
        if value == "🥰":
            self.value = "🥰"
            self.name = "SMILING_FACE_WITH_HEARTS"
            return
        if value == "👏":
            self.value = "👏"
            self.name = "CLAPPING_HANDS"
            return
        if value == "😁":
            self.value = "😁"
            self.name = "GRINNING_FACE_WITH_SMILING_EYES"
            return
        if value == "🤔":
            self.value = "🤔"
            self.name = "THINKING_FACE"
            return
        if value == "🤯":
            self.value = "🤯"
            self.name = "SHOCKED_FACE_WITH_EXPLODING_HEAD"
            return
        if value == "😱":
            self.value = "😱"
            self.name = "FACE_SCREAMING_IN_FEAR"
            return
        if value == "🤬":
            self.value = "🤬"
            self.name = "SERIOUS_FACE_WITH_SYMBOLS_COVERING_MOUTH"
            return
        if value == "😢":
            self.value = "😢"
            self.name = "CRYING_FACE"
            return
        if value == "🎉":
            self.value = "🎉"
            self.name = "PARTY_POPPER"
            return
        if value == "🤩":
            self.value = "🤩"
            self.name = "GRINNING_FACE_WITH_STAR_EYES"
            return
        if value == "🤮":
            self.value = "🤮"
            self.name = "FACE_WITH_OPEN_MOUTH_VOMITING"
            return
        if value == "💩":
            self.value = "💩"
            self.name = "PILE_OF_POO"
            return
        if value == "🙏":
            self.value = "🙏"
            self.name = "PERSON_WITH_FOLDED_HANDS"
            return
        if value == "👌":
            self.value = "👌"
            self.name = "OK_HAND_SIGN"
            return
        if value == "🕊":
            self.value = "🕊"
            self.name = "DOVE_OF_PEACE"
            return
        if value == "🤡":
            self.value = "🤡"
            self.name = "CLOWN_FACE"
            return
        if value == "🥱":
            self.value = "🥱"
            self.name = "YAWNING_FACE"
            return
        if value == "🥴":
            self.value = "🥴"
            self.name = "FACE_WITH_UNEVEN_EYES_AND_WAVY_MOUTH"
            return
        if value == "😍":
            self.value = "😍"
            self.name = "SMILING_FACE_WITH_HEART_SHAPED_EYES"
            return
        if value == "🐳":
            self.value = "🐳"
            self.name = "SPOUTING_WHALE"
            return
        if value == "❤️‍🔥":
            self.value = "❤️‍🔥"
            self.name = "HEART_ON_FIRE"
            return
        if value == "🌚":
            self.value = "🌚"
            self.name = "NEW_MOON_WITH_FACE"
            return
        if value == "🌭":
            self.value = "🌭"
            self.name = "HOT_DOG"
            return
        if value == "💯":
            self.value = "💯"
            self.name = "HUNDRED_POINTS_SYMBOL"
            return
        if value == "🤣":
            self.value = "🤣"
            self.name = "ROLLING_ON_THE_FLOOR_LAUGHING"
            return
        if value == "⚡":
            self.value = "⚡"
            self.name = "HIGH_VOLTAGE_SIGN"
            return
        if value == "🍌":
            self.value = "🍌"
            self.name = "BANANA"
            return
        if value == "🏆":
            self.value = "🏆"
            self.name = "TROPHY"
            return
        if value == "💔":
            self.value = "💔"
            self.name = "BROKEN_HEART"
            return
        if value == "🤨":
            self.value = "🤨"
            self.name = "FACE_WITH_ONE_EYEBROW_RAISED"
            return
        if value == "😐":
            self.value = "😐"
            self.name = "NEUTRAL_FACE"
            return
        if value == "🍓":
            self.value = "🍓"
            self.name = "STRAWBERRY"
            return
        if value == "🍾":
            self.value = "🍾"
            self.name = "BOTTLE_WITH_POPPING_CORK"
            return
        if value == "💋":
            self.value = "💋"
            self.name = "KISS_MARK"
            return
        if value == "🖕":
            self.value = "🖕"
            self.name = "REVERSED_HAND_WITH_MIDDLE_FINGER_EXTENDED"
            return
        if value == "😈":
            self.value = "😈"
            self.name = "SMILING_FACE_WITH_HORNS"
            return
        if value == "😴":
            self.value = "😴"
            self.name = "SLEEPING_FACE"
            return
        if value == "😭":
            self.value = "😭"
            self.name = "LOUDLY_CRYING_FACE"
            return
        if value == "🤓":
            self.value = "🤓"
            self.name = "NERD_FACE"
            return
        if value == "👻":
            self.value = "👻"
            self.name = "GHOST"
            return
        if value == "👨‍💻":
            self.value = "👨‍💻"
            self.name = "MAN_TECHNOLOGIST"
            return
        if value == "👀":
            self.value = "👀"
            self.name = "EYES"
            return
        if value == "🎃":
            self.value = "🎃"
            self.name = "JACK_O_LANTERN"
            return
        if value == "🙈":
            self.value = "🙈"
            self.name = "SEE_NO_EVIL_MONKEY"
            return
        if value == "😇":
            self.value = "😇"
            self.name = "SMILING_FACE_WITH_HALO"
            return
        if value == "😨":
            self.value = "😨"
            self.name = "FEARFUL_FACE"
            return
        if value == "🤝":
            self.value = "🤝"
            self.name = "HANDSHAKE"
            return
        if value == "✍":
            self.value = "✍"
            self.name = "WRITING_HAND"
            return
        if value == "🤗":
            self.value = "🤗"
            self.name = "HUGGING_FACE"
            return
        if value == "🫡":
            self.value = "🫡"
            self.name = "SALUTING_FACE"
            return
        if value == "🎅":
            self.value = "🎅"
            self.name = "FATHER_CHRISTMAS"
            return
        if value == "🎄":
            self.value = "🎄"
            self.name = "CHRISTMAS_TREE"
            return
        if value == "☃":
            self.value = "☃"
            self.name = "SNOWMAN"
            return
        if value == "💅":
            self.value = "💅"
            self.name = "NAIL_POLISH"
            return
        if value == "🤪":
            self.value = "🤪"
            self.name = "GRINNING_FACE_WITH_ONE_LARGE_AND_ONE_SMALL_EYE"
            return
        if value == "🗿":
            self.value = "🗿"
            self.name = "MOYAI"
            return
        if value == "🆒":
            self.value = "🆒"
            self.name = "SQUARED_COOL"
            return
        if value == "💘":
            self.value = "💘"
            self.name = "HEART_WITH_ARROW"
            return
        if value == "🙉":
            self.value = "🙉"
            self.name = "HEAR_NO_EVIL_MONKEY"
            return
        if value == "🦄":
            self.value = "🦄"
            self.name = "UNICORN_FACE"
            return
        if value == "😘":
            self.value = "😘"
            self.name = "FACE_THROWING_A_KISS"
            return
        if value == "💊":
            self.value = "💊"
            self.name = "PILL"
            return
        if value == "🙊":
            self.value = "🙊"
            self.name = "SPEAK_NO_EVIL_MONKEY"
            return
        if value == "😎":
            self.value = "😎"
            self.name = "SMILING_FACE_WITH_SUNGLASSES"
            return
        if value == "👾":
            self.value = "👾"
            self.name = "ALIEN_MONSTER"
            return
        if value == "🤷‍♂️":
            self.value = "🤷‍♂️"
            self.name = "MAN_SHRUGGING"
            return
        if value == "🤷":
            self.value = "🤷"
            self.name = "SHRUG"
            return
        if value == "🤷‍♀️":
            self.value = "🤷‍♀️"
            self.name = "WOMAN_SHRUGGING"
            return
        if value == "😡":
            self.value = "😡"
            self.name = "POUTING_FACE"
            return
        raise Error("ReactionEmoji: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ReactionEmoji." + self.name + ">"

@fieldwise_init
struct ReactionType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime EMOJI = ReactionType("emoji", "EMOJI")
    comptime CUSTOM_EMOJI = ReactionType("custom_emoji", "CUSTOM_EMOJI")
    comptime PAID = ReactionType("paid", "PAID")

    def __init__(out self, value: String) raises:
        if value == "emoji":
            self.value = "emoji"
            self.name = "EMOJI"
            return
        if value == "custom_emoji":
            self.value = "custom_emoji"
            self.name = "CUSTOM_EMOJI"
            return
        if value == "paid":
            self.value = "paid"
            self.name = "PAID"
            return
        raise Error("ReactionType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<ReactionType." + self.name + ">"

@fieldwise_init
struct ReplyLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_INPUT_FIELD_PLACEHOLDER = ReplyLimit(1, "MIN_INPUT_FIELD_PLACEHOLDER")
    comptime MAX_INPUT_FIELD_PLACEHOLDER = ReplyLimit(64, "MAX_INPUT_FIELD_PLACEHOLDER")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_INPUT_FIELD_PLACEHOLDER"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_INPUT_FIELD_PLACEHOLDER"
            return
        raise Error("ReplyLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<ReplyLimit." + self.name + ">"

@fieldwise_init
struct RevenueWithdrawalStateType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PENDING = RevenueWithdrawalStateType("pending", "PENDING")
    comptime SUCCEEDED = RevenueWithdrawalStateType("succeeded", "SUCCEEDED")
    comptime FAILED = RevenueWithdrawalStateType("failed", "FAILED")

    def __init__(out self, value: String) raises:
        if value == "pending":
            self.value = "pending"
            self.name = "PENDING"
            return
        if value == "succeeded":
            self.value = "succeeded"
            self.name = "SUCCEEDED"
            return
        if value == "failed":
            self.value = "failed"
            self.name = "FAILED"
            return
        raise Error("RevenueWithdrawalStateType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<RevenueWithdrawalStateType." + self.name + ">"

@fieldwise_init
struct StarTransactionsLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_LIMIT = StarTransactionsLimit(1, "MIN_LIMIT")
    comptime MAX_LIMIT = StarTransactionsLimit(100, "MAX_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_LIMIT"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_LIMIT"
            return
        raise Error("StarTransactionsLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<StarTransactionsLimit." + self.name + ">"

@fieldwise_init
struct StickerFormat(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime STATIC = StickerFormat("static", "STATIC")
    comptime ANIMATED = StickerFormat("animated", "ANIMATED")
    comptime VIDEO = StickerFormat("video", "VIDEO")

    def __init__(out self, value: String) raises:
        if value == "static":
            self.value = "static"
            self.name = "STATIC"
            return
        if value == "animated":
            self.value = "animated"
            self.name = "ANIMATED"
            return
        if value == "video":
            self.value = "video"
            self.name = "VIDEO"
            return
        raise Error("StickerFormat: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<StickerFormat." + self.name + ">"

@fieldwise_init
struct StickerLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_NAME_AND_TITLE = StickerLimit(1, "MIN_NAME_AND_TITLE")
    comptime MAX_NAME_AND_TITLE = StickerLimit(64, "MAX_NAME_AND_TITLE")
    comptime MIN_STICKER_EMOJI = StickerLimit(1, "MIN_NAME_AND_TITLE")
    comptime MAX_STICKER_EMOJI = StickerLimit(20, "MAX_STICKER_EMOJI")
    comptime MAX_SEARCH_KEYWORDS = StickerLimit(20, "MAX_STICKER_EMOJI")
    comptime MAX_KEYWORD_LENGTH = StickerLimit(64, "MAX_NAME_AND_TITLE")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_NAME_AND_TITLE"
            return
        if value == 64:
            self.value = 64
            self.name = "MAX_NAME_AND_TITLE"
            return
        if value == 20:
            self.value = 20
            self.name = "MAX_STICKER_EMOJI"
            return
        raise Error("StickerLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<StickerLimit." + self.name + ">"

@fieldwise_init
struct StickerSetLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_INITIAL_STICKERS = StickerSetLimit(1, "MIN_INITIAL_STICKERS")
    comptime MAX_INITIAL_STICKERS = StickerSetLimit(50, "MAX_INITIAL_STICKERS")
    comptime MAX_EMOJI_STICKERS = StickerSetLimit(200, "MAX_EMOJI_STICKERS")
    comptime MAX_ANIMATED_STICKERS = StickerSetLimit(50, "MAX_INITIAL_STICKERS")
    comptime MAX_STATIC_STICKERS = StickerSetLimit(120, "MAX_STATIC_STICKERS")
    comptime MAX_STATIC_THUMBNAIL_SIZE = StickerSetLimit(128, "MAX_STATIC_THUMBNAIL_SIZE")
    comptime MAX_ANIMATED_THUMBNAIL_SIZE = StickerSetLimit(32, "MAX_ANIMATED_THUMBNAIL_SIZE")
    comptime STATIC_THUMB_DIMENSIONS = StickerSetLimit(100, "STATIC_THUMB_DIMENSIONS")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_INITIAL_STICKERS"
            return
        if value == 50:
            self.value = 50
            self.name = "MAX_INITIAL_STICKERS"
            return
        if value == 200:
            self.value = 200
            self.name = "MAX_EMOJI_STICKERS"
            return
        if value == 120:
            self.value = 120
            self.name = "MAX_STATIC_STICKERS"
            return
        if value == 128:
            self.value = 128
            self.name = "MAX_STATIC_THUMBNAIL_SIZE"
            return
        if value == 32:
            self.value = 32
            self.name = "MAX_ANIMATED_THUMBNAIL_SIZE"
            return
        if value == 100:
            self.value = 100
            self.name = "STATIC_THUMB_DIMENSIONS"
            return
        raise Error("StickerSetLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<StickerSetLimit." + self.name + ">"

@fieldwise_init
struct StickerType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime REGULAR = StickerType("regular", "REGULAR")
    comptime MASK = StickerType("mask", "MASK")
    comptime CUSTOM_EMOJI = StickerType("custom_emoji", "CUSTOM_EMOJI")

    def __init__(out self, value: String) raises:
        if value == "regular":
            self.value = "regular"
            self.name = "REGULAR"
            return
        if value == "mask":
            self.value = "mask"
            self.name = "MASK"
            return
        if value == "custom_emoji":
            self.value = "custom_emoji"
            self.name = "CUSTOM_EMOJI"
            return
        raise Error("StickerType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<StickerType." + self.name + ">"

@fieldwise_init
struct StoryAreaPositionLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_ROTATION_ANGLE = StoryAreaPositionLimit(360, "MAX_ROTATION_ANGLE")

    def __init__(out self, value: Int) raises:
        if value == 360:
            self.value = 360
            self.name = "MAX_ROTATION_ANGLE"
            return
        raise Error("StoryAreaPositionLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<StoryAreaPositionLimit." + self.name + ">"

@fieldwise_init
struct StoryAreaTypeLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_LOCATION_AREAS = StoryAreaTypeLimit(10, "MAX_LOCATION_AREAS")
    comptime MAX_SUGGESTED_REACTION_AREAS = StoryAreaTypeLimit(5, "MAX_SUGGESTED_REACTION_AREAS")
    comptime MAX_LINK_AREAS = StoryAreaTypeLimit(3, "MAX_LINK_AREAS")
    comptime MAX_WEATHER_AREAS = StoryAreaTypeLimit(3, "MAX_LINK_AREAS")
    comptime MAX_UNIQUE_GIFT_AREAS = StoryAreaTypeLimit(1, "MAX_UNIQUE_GIFT_AREAS")

    def __init__(out self, value: Int) raises:
        if value == 10:
            self.value = 10
            self.name = "MAX_LOCATION_AREAS"
            return
        if value == 5:
            self.value = 5
            self.name = "MAX_SUGGESTED_REACTION_AREAS"
            return
        if value == 3:
            self.value = 3
            self.name = "MAX_LINK_AREAS"
            return
        if value == 1:
            self.value = 1
            self.name = "MAX_UNIQUE_GIFT_AREAS"
            return
        raise Error("StoryAreaTypeLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<StoryAreaTypeLimit." + self.name + ">"

@fieldwise_init
struct StoryAreaTypeType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime LOCATION = StoryAreaTypeType("location", "LOCATION")
    comptime SUGGESTED_REACTION = StoryAreaTypeType("suggested_reaction", "SUGGESTED_REACTION")
    comptime LINK = StoryAreaTypeType("link", "LINK")
    comptime WEATHER = StoryAreaTypeType("weather", "WEATHER")
    comptime UNIQUE_GIFT = StoryAreaTypeType("unique_gift", "UNIQUE_GIFT")

    def __init__(out self, value: String) raises:
        if value == "location":
            self.value = "location"
            self.name = "LOCATION"
            return
        if value == "suggested_reaction":
            self.value = "suggested_reaction"
            self.name = "SUGGESTED_REACTION"
            return
        if value == "link":
            self.value = "link"
            self.name = "LINK"
            return
        if value == "weather":
            self.value = "weather"
            self.name = "WEATHER"
            return
        if value == "unique_gift":
            self.value = "unique_gift"
            self.name = "UNIQUE_GIFT"
            return
        raise Error("StoryAreaTypeType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<StoryAreaTypeType." + self.name + ">"

@fieldwise_init
struct StoryLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime CAPTION_LENGTH = StoryLimit(2048, "CAPTION_LENGTH")
    comptime ACTIVITY_SIX_HOURS = StoryLimit(21600, "ACTIVITY_SIX_HOURS")
    comptime ACTIVITY_TWELVE_HOURS = StoryLimit(43200, "ACTIVITY_TWELVE_HOURS")
    comptime ACTIVITY_ONE_DAY = StoryLimit(86400, "ACTIVITY_ONE_DAY")
    comptime ACTIVITY_TWO_DAYS = StoryLimit(172800, "ACTIVITY_TWO_DAYS")

    def __init__(out self, value: Int) raises:
        if value == 2048:
            self.value = 2048
            self.name = "CAPTION_LENGTH"
            return
        if value == 21600:
            self.value = 21600
            self.name = "ACTIVITY_SIX_HOURS"
            return
        if value == 43200:
            self.value = 43200
            self.name = "ACTIVITY_TWELVE_HOURS"
            return
        if value == 86400:
            self.value = 86400
            self.name = "ACTIVITY_ONE_DAY"
            return
        if value == 172800:
            self.value = 172800
            self.name = "ACTIVITY_TWO_DAYS"
            return
        raise Error("StoryLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<StoryLimit." + self.name + ">"

@fieldwise_init
struct SuggestedPost(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_PRICE_STARS = SuggestedPost(5, "MIN_PRICE_STARS")
    comptime MAX_PRICE_STARS = SuggestedPost(100000, "MAX_PRICE_STARS")
    comptime MIN_PRICE_NANOTONCOINS = SuggestedPost(10000000, "MIN_PRICE_NANOTONCOINS")
    comptime MAX_PRICE_NANOTONCOINS = SuggestedPost(10000000000000, "MAX_PRICE_NANOTONCOINS")
    comptime MIN_SEND_DATE = SuggestedPost(300, "MIN_SEND_DATE")
    comptime MAX_SEND_DATE = SuggestedPost(2678400, "MAX_SEND_DATE")
    comptime MAX_COMMENT_LENGTH = SuggestedPost(128, "MAX_COMMENT_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 5:
            self.value = 5
            self.name = "MIN_PRICE_STARS"
            return
        if value == 100000:
            self.value = 100000
            self.name = "MAX_PRICE_STARS"
            return
        if value == 10000000:
            self.value = 10000000
            self.name = "MIN_PRICE_NANOTONCOINS"
            return
        if value == 10000000000000:
            self.value = 10000000000000
            self.name = "MAX_PRICE_NANOTONCOINS"
            return
        if value == 300:
            self.value = 300
            self.name = "MIN_SEND_DATE"
            return
        if value == 2678400:
            self.value = 2678400
            self.name = "MAX_SEND_DATE"
            return
        if value == 128:
            self.value = 128
            self.name = "MAX_COMMENT_LENGTH"
            return
        raise Error("SuggestedPost: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<SuggestedPost." + self.name + ">"

@fieldwise_init
struct SuggestedPostInfoState(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime PENDING = SuggestedPostInfoState("pending", "PENDING")
    comptime APPROVED = SuggestedPostInfoState("approved", "APPROVED")
    comptime DECLINED = SuggestedPostInfoState("declined", "DECLINED")

    def __init__(out self, value: String) raises:
        if value == "pending":
            self.value = "pending"
            self.name = "PENDING"
            return
        if value == "approved":
            self.value = "approved"
            self.name = "APPROVED"
            return
        if value == "declined":
            self.value = "declined"
            self.name = "DECLINED"
            return
        raise Error("SuggestedPostInfoState: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<SuggestedPostInfoState." + self.name + ">"

@fieldwise_init
struct SuggestedPostRefunded(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime POST_DELETED = SuggestedPostRefunded("post_deleted", "POST_DELETED")
    comptime PAYMENT_REFUNDED = SuggestedPostRefunded("payment_refunded", "PAYMENT_REFUNDED")

    def __init__(out self, value: String) raises:
        if value == "post_deleted":
            self.value = "post_deleted"
            self.name = "POST_DELETED"
            return
        if value == "payment_refunded":
            self.value = "payment_refunded"
            self.name = "PAYMENT_REFUNDED"
            return
        raise Error("SuggestedPostRefunded: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<SuggestedPostRefunded." + self.name + ">"

@fieldwise_init
struct TagLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_TAG_LENGTH = TagLimit(16, "MAX_TAG_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 16:
            self.value = 16
            self.name = "MAX_TAG_LENGTH"
            return
        raise Error("TagLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<TagLimit." + self.name + ">"

@fieldwise_init
struct TransactionPartnerType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime AFFILIATE_PROGRAM = TransactionPartnerType("affiliate_program", "AFFILIATE_PROGRAM")
    comptime CHAT = TransactionPartnerType("chat", "CHAT")
    comptime FRAGMENT = TransactionPartnerType("fragment", "FRAGMENT")
    comptime OTHER = TransactionPartnerType("other", "OTHER")
    comptime TELEGRAM_ADS = TransactionPartnerType("telegram_ads", "TELEGRAM_ADS")
    comptime TELEGRAM_API = TransactionPartnerType("telegram_api", "TELEGRAM_API")
    comptime USER = TransactionPartnerType("user", "USER")

    def __init__(out self, value: String) raises:
        if value == "affiliate_program":
            self.value = "affiliate_program"
            self.name = "AFFILIATE_PROGRAM"
            return
        if value == "chat":
            self.value = "chat"
            self.name = "CHAT"
            return
        if value == "fragment":
            self.value = "fragment"
            self.name = "FRAGMENT"
            return
        if value == "other":
            self.value = "other"
            self.name = "OTHER"
            return
        if value == "telegram_ads":
            self.value = "telegram_ads"
            self.name = "TELEGRAM_ADS"
            return
        if value == "telegram_api":
            self.value = "telegram_api"
            self.name = "TELEGRAM_API"
            return
        if value == "user":
            self.value = "user"
            self.name = "USER"
            return
        raise Error("TransactionPartnerType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<TransactionPartnerType." + self.name + ">"

@fieldwise_init
struct TransactionPartnerUser(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime INVOICE_PAYMENT = TransactionPartnerUser("invoice_payment", "INVOICE_PAYMENT")
    comptime PAID_MEDIA_PAYMENT = TransactionPartnerUser("paid_media_payment", "PAID_MEDIA_PAYMENT")
    comptime GIFT_PURCHASE = TransactionPartnerUser("gift_purchase", "GIFT_PURCHASE")
    comptime PREMIUM_PURCHASE = TransactionPartnerUser("premium_purchase", "PREMIUM_PURCHASE")
    comptime BUSINESS_ACCOUNT_TRANSFER = TransactionPartnerUser("business_account_transfer", "BUSINESS_ACCOUNT_TRANSFER")

    def __init__(out self, value: String) raises:
        if value == "invoice_payment":
            self.value = "invoice_payment"
            self.name = "INVOICE_PAYMENT"
            return
        if value == "paid_media_payment":
            self.value = "paid_media_payment"
            self.name = "PAID_MEDIA_PAYMENT"
            return
        if value == "gift_purchase":
            self.value = "gift_purchase"
            self.name = "GIFT_PURCHASE"
            return
        if value == "premium_purchase":
            self.value = "premium_purchase"
            self.name = "PREMIUM_PURCHASE"
            return
        if value == "business_account_transfer":
            self.value = "business_account_transfer"
            self.name = "BUSINESS_ACCOUNT_TRANSFER"
            return
        raise Error("TransactionPartnerUser: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<TransactionPartnerUser." + self.name + ">"

@fieldwise_init
struct UniqueGiftInfoOrigin(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime GIFTED_UPGRADE = UniqueGiftInfoOrigin("gifted_upgrade", "GIFTED_UPGRADE")
    comptime OFFER = UniqueGiftInfoOrigin("OFFER", "OFFER")
    comptime RESALE = UniqueGiftInfoOrigin("resale", "RESALE")
    comptime TRANSFER = UniqueGiftInfoOrigin("transfer", "TRANSFER")
    comptime UPGRADE = UniqueGiftInfoOrigin("upgrade", "UPGRADE")

    def __init__(out self, value: String) raises:
        if value == "gifted_upgrade":
            self.value = "gifted_upgrade"
            self.name = "GIFTED_UPGRADE"
            return
        if value == "OFFER":
            self.value = "OFFER"
            self.name = "OFFER"
            return
        if value == "resale":
            self.value = "resale"
            self.name = "RESALE"
            return
        if value == "transfer":
            self.value = "transfer"
            self.name = "TRANSFER"
            return
        if value == "upgrade":
            self.value = "upgrade"
            self.name = "UPGRADE"
            return
        raise Error("UniqueGiftInfoOrigin: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<UniqueGiftInfoOrigin." + self.name + ">"

@fieldwise_init
struct UniqueGiftModelRarity(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime UNCOMMON = UniqueGiftModelRarity("uncommon", "UNCOMMON")
    comptime RARE = UniqueGiftModelRarity("rare", "RARE")
    comptime EPIC = UniqueGiftModelRarity("epic", "EPIC")
    comptime LEGENDARY = UniqueGiftModelRarity("legendary", "LEGENDARY")

    def __init__(out self, value: String) raises:
        if value == "uncommon":
            self.value = "uncommon"
            self.name = "UNCOMMON"
            return
        if value == "rare":
            self.value = "rare"
            self.name = "RARE"
            return
        if value == "epic":
            self.value = "epic"
            self.name = "EPIC"
            return
        if value == "legendary":
            self.value = "legendary"
            self.name = "LEGENDARY"
            return
        raise Error("UniqueGiftModelRarity: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<UniqueGiftModelRarity." + self.name + ">"

@fieldwise_init
struct UpdateType(Equatable, ImplicitlyCopyable):
    var value: String
    var name: String

    comptime MESSAGE = UpdateType("message", "MESSAGE")
    comptime EDITED_MESSAGE = UpdateType("edited_message", "EDITED_MESSAGE")
    comptime CHANNEL_POST = UpdateType("channel_post", "CHANNEL_POST")
    comptime EDITED_CHANNEL_POST = UpdateType("edited_channel_post", "EDITED_CHANNEL_POST")
    comptime INLINE_QUERY = UpdateType("inline_query", "INLINE_QUERY")
    comptime CHOSEN_INLINE_RESULT = UpdateType("chosen_inline_result", "CHOSEN_INLINE_RESULT")
    comptime CALLBACK_QUERY = UpdateType("callback_query", "CALLBACK_QUERY")
    comptime SHIPPING_QUERY = UpdateType("shipping_query", "SHIPPING_QUERY")
    comptime PRE_CHECKOUT_QUERY = UpdateType("pre_checkout_query", "PRE_CHECKOUT_QUERY")
    comptime POLL = UpdateType("poll", "POLL")
    comptime POLL_ANSWER = UpdateType("poll_answer", "POLL_ANSWER")
    comptime MY_CHAT_MEMBER = UpdateType("my_chat_member", "MY_CHAT_MEMBER")
    comptime CHAT_MEMBER = UpdateType("chat_member", "CHAT_MEMBER")
    comptime CHAT_JOIN_REQUEST = UpdateType("chat_join_request", "CHAT_JOIN_REQUEST")
    comptime CHAT_BOOST = UpdateType("chat_boost", "CHAT_BOOST")
    comptime REMOVED_CHAT_BOOST = UpdateType("removed_chat_boost", "REMOVED_CHAT_BOOST")
    comptime MESSAGE_REACTION = UpdateType("message_reaction", "MESSAGE_REACTION")
    comptime MESSAGE_REACTION_COUNT = UpdateType("message_reaction_count", "MESSAGE_REACTION_COUNT")
    comptime BUSINESS_CONNECTION = UpdateType("business_connection", "BUSINESS_CONNECTION")
    comptime BUSINESS_MESSAGE = UpdateType("business_message", "BUSINESS_MESSAGE")
    comptime EDITED_BUSINESS_MESSAGE = UpdateType("edited_business_message", "EDITED_BUSINESS_MESSAGE")
    comptime DELETED_BUSINESS_MESSAGES = UpdateType("deleted_business_messages", "DELETED_BUSINESS_MESSAGES")
    comptime PURCHASED_PAID_MEDIA = UpdateType("purchased_paid_media", "PURCHASED_PAID_MEDIA")
    comptime MANAGED_BOT = UpdateType("managed_bot", "MANAGED_BOT")
    comptime GUEST_MESSAGE = UpdateType("guest_message", "GUEST_MESSAGE")

    def __init__(out self, value: String) raises:
        if value == "message":
            self.value = "message"
            self.name = "MESSAGE"
            return
        if value == "edited_message":
            self.value = "edited_message"
            self.name = "EDITED_MESSAGE"
            return
        if value == "channel_post":
            self.value = "channel_post"
            self.name = "CHANNEL_POST"
            return
        if value == "edited_channel_post":
            self.value = "edited_channel_post"
            self.name = "EDITED_CHANNEL_POST"
            return
        if value == "inline_query":
            self.value = "inline_query"
            self.name = "INLINE_QUERY"
            return
        if value == "chosen_inline_result":
            self.value = "chosen_inline_result"
            self.name = "CHOSEN_INLINE_RESULT"
            return
        if value == "callback_query":
            self.value = "callback_query"
            self.name = "CALLBACK_QUERY"
            return
        if value == "shipping_query":
            self.value = "shipping_query"
            self.name = "SHIPPING_QUERY"
            return
        if value == "pre_checkout_query":
            self.value = "pre_checkout_query"
            self.name = "PRE_CHECKOUT_QUERY"
            return
        if value == "poll":
            self.value = "poll"
            self.name = "POLL"
            return
        if value == "poll_answer":
            self.value = "poll_answer"
            self.name = "POLL_ANSWER"
            return
        if value == "my_chat_member":
            self.value = "my_chat_member"
            self.name = "MY_CHAT_MEMBER"
            return
        if value == "chat_member":
            self.value = "chat_member"
            self.name = "CHAT_MEMBER"
            return
        if value == "chat_join_request":
            self.value = "chat_join_request"
            self.name = "CHAT_JOIN_REQUEST"
            return
        if value == "chat_boost":
            self.value = "chat_boost"
            self.name = "CHAT_BOOST"
            return
        if value == "removed_chat_boost":
            self.value = "removed_chat_boost"
            self.name = "REMOVED_CHAT_BOOST"
            return
        if value == "message_reaction":
            self.value = "message_reaction"
            self.name = "MESSAGE_REACTION"
            return
        if value == "message_reaction_count":
            self.value = "message_reaction_count"
            self.name = "MESSAGE_REACTION_COUNT"
            return
        if value == "business_connection":
            self.value = "business_connection"
            self.name = "BUSINESS_CONNECTION"
            return
        if value == "business_message":
            self.value = "business_message"
            self.name = "BUSINESS_MESSAGE"
            return
        if value == "edited_business_message":
            self.value = "edited_business_message"
            self.name = "EDITED_BUSINESS_MESSAGE"
            return
        if value == "deleted_business_messages":
            self.value = "deleted_business_messages"
            self.name = "DELETED_BUSINESS_MESSAGES"
            return
        if value == "purchased_paid_media":
            self.value = "purchased_paid_media"
            self.name = "PURCHASED_PAID_MEDIA"
            return
        if value == "managed_bot":
            self.value = "managed_bot"
            self.name = "MANAGED_BOT"
            return
        if value == "guest_message":
            self.value = "guest_message"
            self.name = "GUEST_MESSAGE"
            return
        raise Error("UpdateType: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: String) -> Bool:
        return self.value == other

    def __add__(self, other: String) -> String:
        return self.value + other

    def __radd__(self, other: String) -> String:
        return other + self.value

    def __str__(self) -> String:
        return self.value

    def __repr__(self) -> String:
        return "<UpdateType." + self.name + ">"

@fieldwise_init
struct UserProfileAudiosLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_LIMIT = UserProfileAudiosLimit(1, "MIN_LIMIT")
    comptime MAX_LIMIT = UserProfileAudiosLimit(100, "MAX_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_LIMIT"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_LIMIT"
            return
        raise Error("UserProfileAudiosLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<UserProfileAudiosLimit." + self.name + ">"

@fieldwise_init
struct UserProfilePhotosLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_LIMIT = UserProfilePhotosLimit(1, "MIN_LIMIT")
    comptime MAX_LIMIT = UserProfilePhotosLimit(100, "MAX_LIMIT")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_LIMIT"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_LIMIT"
            return
        raise Error("UserProfilePhotosLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<UserProfilePhotosLimit." + self.name + ">"

@fieldwise_init
struct VerifyLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MAX_TEXT_LENGTH = VerifyLimit(70, "MAX_TEXT_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 70:
            self.value = 70
            self.name = "MAX_TEXT_LENGTH"
            return
        raise Error("VerifyLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<VerifyLimit." + self.name + ">"

@fieldwise_init
struct WebhookLimit(Equatable, ImplicitlyCopyable):
    var value: Int
    var name: String

    comptime MIN_CONNECTIONS_LIMIT = WebhookLimit(1, "MIN_CONNECTIONS_LIMIT")
    comptime MAX_CONNECTIONS_LIMIT = WebhookLimit(100, "MAX_CONNECTIONS_LIMIT")
    comptime MIN_SECRET_TOKEN_LENGTH = WebhookLimit(1, "MIN_CONNECTIONS_LIMIT")
    comptime MAX_SECRET_TOKEN_LENGTH = WebhookLimit(256, "MAX_SECRET_TOKEN_LENGTH")

    def __init__(out self, value: Int) raises:
        if value == 1:
            self.value = 1
            self.name = "MIN_CONNECTIONS_LIMIT"
            return
        if value == 100:
            self.value = 100
            self.name = "MAX_CONNECTIONS_LIMIT"
            return
        if value == 256:
            self.value = 256
            self.name = "MAX_SECRET_TOKEN_LENGTH"
            return
        raise Error("WebhookLimit: unknown value")

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    def __eq__(self, other: Int) -> Bool:
        return self.value == other

    def __lt__(self, other: Int) -> Bool:
        return self.value < other

    def __le__(self, other: Int) -> Bool:
        return self.value <= other

    def __gt__(self, other: Int) -> Bool:
        return self.value > other

    def __ge__(self, other: Int) -> Bool:
        return self.value >= other

    def __add__(self, other: Int) -> Int:
        return self.value + other

    def __radd__(self, other: Int) -> Int:
        return other + self.value

    def __sub__(self, other: Int) -> Int:
        return self.value - other

    def __mul__(self, other: Int) -> Int:
        return self.value * other

    def __int__(self) -> Int:
        return self.value

    def __str__(self) -> String:
        return String(self.value)

    def __repr__(self) -> String:
        return "<WebhookLimit." + self.name + ">"
