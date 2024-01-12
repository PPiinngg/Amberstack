const std = @import("std");

const ast = @import("ast.zig");
const parser = @import("parser.zig");
const tokeniser = @import("tokeniser.zig");

const log = @import("../util/log.zig");

const statics = struct {
    var ast_arena: std.heap.ArenaAllocator = undefined;
    var ast_roots: std.StringArrayHashMap(ast.Atom) = undefined;
};

pub fn init(alloc: std.mem.Allocator) !void {
    statics.ast_arena = std.heap.ArenaAllocator.init(alloc);
    statics.ast_roots = std.StringArrayHashMap(ast.Atom);
}

pub fn evaluate(alloc: std.mem.Allocator, expr: []const u8) void {
    const tokens = tokeniser.tokeniser(alloc, expr) catch |err| {
        log.logError(err, "Lisp tokeniser unable to allocate");
        return;
    };
    defer alloc.free(tokens);
    parser.parser(tokens, &statics.ast_arena, &statics.ast_roots) catch |err| {
        log.logError(err, "Syntax error");
        return;
    };
    log.logTodo("Evaluate AST");
    statics.ast_roots.clearAndFree();
    _ = statics.ast_arena.reset(.free_all);
}
