const builtin = @import("builtin");
const std = @import("std");

const ansi = @import("ansi.zig");

inline fn log(writer: std.fs.File.Writer, colour: ansi.Colour, tag: []const u8, extra: anytype, msg: []const u8) void {
    ansi.Colour.set(writer, .Fg, colour) catch {};
    writer.writeAll(tag) catch {};
    if (extra != null) std.fmt.format(writer, " [{any}]", .{extra}) catch {};
    writer.writeByte(':') catch {};
    ansi.resetStyle(writer) catch {};
    std.fmt.format(writer, " {s}\n", .{msg}) catch {};
}

pub fn logError(err: ?anyerror, msg: []const u8) void {
    const stderr = std.io.getStdErr().writer();
    log(stderr, .Bright_Red, "ERROR", err, msg);
}

pub fn logCriticalError(err: ?anyerror, msg: []const u8) void {
    const stderr = std.io.getStdErr().writer();
    log(stderr, .Bright_Yellow, "CRITICAL ERROR", err, msg);
}

pub fn logTodo(msg: []const u8) void {
    const stdout = std.io.getStdOut().writer();
    log(stdout, .Blue, "TODO", null, msg);
}

pub fn logDebug(msg: []const u8) void {
    if (builtin.mode == std.builtin.OptimizeMode.Debug) {
        const stdout = std.io.getStdOut().writer();
        log(stdout, .Green, "DEBUG", null, msg);
    }
}
