const std = @import("std");
const config = @import("config");

const log = @import("util/log.zig");
const text = @import("util/text.zig");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    entrypoint(
        gpa.allocator(),
        std.io.getStdIn().reader(),
        std.io.getStdOut().writer(),
    ) catch |err|
        log.logCriticalError(err, "Unhandled error bubbled up to top scope");
}

fn entrypoint(
    alloc: std.mem.Allocator,
    stdin: std.fs.File.Reader,
    stdout: std.fs.File.Writer,
) !void {
    _ = alloc;
    var input_buffer: [config.repl_input_buffer_bytes]u8 = undefined;

    while (true) {
        stdout.writeAll("ᛮ ") catch {};

        // TODO: Replace with custom readline
        var input_slice: []u8 = stdin.readUntilDelimiter(input_buffer[0..], '\n') catch |err| {
            log.logError(err, "Unable to read stdin");
            continue;
        };
        input_slice = text.trimTrailingWhitespace(input_slice);

        if (input_slice.len == 0) {
            log.logError(null, "No input");
        } else {
            if (input_slice[0] == '(')
                log.logTodo("Execute lisp expression")
            else
                log.logTodo("Execute shell command");
        }

        stdout.writeAll("\n") catch {};
    }
}
