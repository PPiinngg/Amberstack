const std = @import("std");

const tokeniser = @import("tokeniser.zig");
const log = @import("../util/log.zig");

pub fn evaluateLispExpression(alloc: std.mem.Allocator, expr: []const u8) void {
    const tokens = tokeniser.tokeniser(alloc, expr) catch |err| {
        log.logError(err, "Lisp tokeniser unable to allocate");
        return;
    };
    defer alloc.free(tokens);
    for (tokens) |token| log.logDebug(token);
    log.logTodo("Parse tokens into AST");
    log.logTodo("Evaluate AST");
}
