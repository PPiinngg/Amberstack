const std = @import("std");

pub fn resetStyle(writer: std.fs.File.Writer) !void {
    try writer.writeAll("\x1b[0m");
}

pub const Colour = enum(u8) {
    Black = 30,
    Red = 31,
    Green = 32,
    Yellow = 33,
    Blue = 34,
    Magenta = 35,
    Cyan = 36,
    White = 37,
    Default = 38,
    Bright_Black = 90,
    Bright_Red = 91,
    Bright_Green = 92,
    Bright_Yellow = 93,
    Bright_Blue = 94,
    Bright_Magenta = 95,
    Bright_Cyan = 96,
    Bright_White = 97,
    Bright_Default = 98,

    pub inline fn set(writer: std.fs.File.Writer, layer: enum { Fg, Bg }, colour: Colour) !void {
        try switch (layer) {
            .Fg => std.fmt.format(writer, "\x1b[{d}m", .{@intFromEnum(colour)}),
            .Bg => std.fmt.format(writer, "\x1b[{d}m", .{@intFromEnum(colour) + 10}),
        };
    }

    pub inline fn setBoth(writer: std.fs.File.Writer, fg: Colour, bg: Colour) !void {
        std.fmt.format(writer, "\x1b[{d};{d}m", .{ @intFromEnum(fg), @intFromEnum(bg) + 10 });
    }
};

pub const Effect = enum(u8) {
    Bold = 1,
    Dim = 2,
    Underline = 4,
    Blink = 5,
    Reverse = 7,
    Hide = 8,

    pub fn set(writer: std.fs.File.Writer, effect: Effect, state: bool) !void {
        try switch (state) {
            true => std.fmt.format(writer, "\x1b[{d}m", .{@intFromEnum(effect)}),
            false => std.fmt.format(writer, "\x1b[{d}m", .{@intFromEnum(effect) + 20}),
        };
    }

    pub fn reset(writer: std.fs.File.Writer) !void {
        try writer.writeAll("\x1b[21;22;24;25;27;28m");
    }
};

const ClearMode = enum(u8) {
    Line,
    Cursor_To_Line_Begin,
    Cursor_To_Line_End,
    Screen,
    Cursor_To_Screen_Begin,
    Cursor_To_Screen_End,
};

pub fn clear(
    writer: std.fs.File.Writer,
    mode: ClearMode,
) !void {
    try switch (mode) {
        .Line => writer.writeAll("\x1b[2K"),
        .Cursor_To_Line_Begin => writer.writeAll("\x1b[1K"),
        .Cursor_To_Line_End => writer.writeAll("\x1b[K"),
        .Screen => writer.writeAll("\x1b[2K"),
        .Cursor_To_Screen_Begin => writer.writeAll("\x1b[1K"),
        .Cursor_To_Screen_End => writer.writeAll("\x1b[K"),
    };
}

pub const Clear = enum {
    Line,
    Cursor_To_Line_Begin,
    Cursor_To_Line_End,
    Screen,
    Cursor_To_Screen_Begin,
    Cursor_To_Screen_End,

    pub const LINE = "\x1b[2K";
    pub const CURSOR_2_LINE_BEGIN = "\x1b[1K";
    pub const CURSOR_2_LINE_END = "\x1b[K";
    pub const SCREEN = "\x1b[2J";
    pub const CURSOR_2_SCREEN_BEGIN = "\x1b[1J";
    pub const CURSOR_2_SCREEN_END = "\x1b[J";
};

pub const cursor = struct {
    pub const Mode = enum(u8) { Blink_Block };
};
