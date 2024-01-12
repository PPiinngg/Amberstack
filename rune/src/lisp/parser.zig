const config = @import("config");
const std = @import("std");

const ansi = @import("../util/ansi.zig");
const ast = @import("ast.zig");

const RuntimeError = error{MaximumStackDepthExceeded};

const SyntaxError = error{
    NotEnoughClosingParens,
    TooManyClosingParens,
};

const TreeLevelTracker = struct {
    siblings: usize = 0,
    open_paren_tk_i: usize = 0,
};

const aaaa = struct {
    pub var maxtokenlen: usize = 0;
};

const max_tree_depth = config.lisp_ast_max_tree_depth;

fn debugPrintAtom(token: []const u8, tk_i: usize, tree_depth: usize) void {
    std.debug.print("{s} ", .{token});
    ansi.Effect.set(std.io.getStdOut().writer(), .Dim, true) catch {};
    for (0..(aaaa.maxtokenlen + 3) - token.len) |_| std.debug.print(".", .{});
    ansi.resetStyle(std.io.getStdOut().writer()) catch {};
    ansi.Colour.set(std.io.getStdOut().writer(), .Fg, .Cyan) catch {};
    std.debug.print(" [tk_i = {}] [tree_depth = {}]\n", .{ tk_i, tree_depth });
    ansi.resetStyle(std.io.getStdOut().writer()) catch {};
}

pub fn parser(
    tokens: [][]const u8,
    ast_arena: *std.heap.ArenaAllocator,
    ast_roots: *std.StringArrayHashMap(ast.Atom),
) !void {
    for (tokens) |tk| aaaa.maxtokenlen = @max(aaaa.maxtokenlen, tk.len);

    _ = ast_roots;
    _ = ast_arena;

    var tree_depth: usize = 0;
    var tree_tracker: [max_tree_depth]TreeLevelTracker = undefined;
    @memset(&tree_tracker, .{});

    var tk_i: usize = 0;
    while (tk_i < tokens.len) : (tk_i += 1) {
        if (try parens(tokens, &tk_i, &tree_depth, &tree_tracker)) continue;

        for (tree_depth) |_| std.debug.print("   ", .{});
        debugPrintAtom(tokens[tk_i], tk_i, tree_depth);
    }
    if (tree_depth > 0) return SyntaxError.NotEnoughClosingParens;
}

fn parens(
    tokens: [][]const u8,
    tk_i: *usize,
    tree_depth: *usize,
    tree_tracker: []TreeLevelTracker,
) !bool {
    switch (tokens[tk_i.*][0]) {
        '(' => {
            for (tree_depth.*) |_| std.debug.print("   ", .{});
            if (tk_i.* >= max_tree_depth)
                return RuntimeError.MaximumStackDepthExceeded;
            tree_tracker[tree_depth.*].siblings += 1;
            tree_depth.* += 1;
            tree_tracker[tree_depth.*].open_paren_tk_i = tk_i.*;
            debugPrintAtom(tokens[tk_i.*], tk_i.*, tree_depth.*);
            return true;
        },
        ')' => {
            if (tree_depth.* == 0)
                return SyntaxError.TooManyClosingParens;
            tree_depth.* -= 1;
            for (tree_depth.*) |_| std.debug.print("   ", .{});
            debugPrintAtom(tokens[tk_i.*], tk_i.*, tree_depth.*);
            return true;
        },
        else => return false,
    }
}
