const std = @import("std");
// const config = @import("config");

const log = @import("util/log.zig");
const text = @import("util/text.zig");

pub fn main() void {
    entrypoint() catch |err| log.logCriticalError(err, "Unhandled error bubbled up to top scope");
}

fn entrypoint() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    _ = alloc;

    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var input_buffer: [1 << 14]u8 = undefined;

    // REPL //
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
