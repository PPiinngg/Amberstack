const std = @import("std");

const log = @import("../util/log.zig");
const text = @import("../util/text.zig");

pub fn tokeniser(alloc: std.mem.Allocator, expr: []const u8) ![][]const u8 {
    var tokens = std.ArrayList([]const u8).init(alloc);

    var i: usize = 0;
    var token_start = i;
    var new_token: bool = true;

    while (i < expr.len) : (i += 1) {
        // String literals //
        if (new_token and expr[i] == '"') {
            i += 1;
            while (expr[i] != '"') : (i += 1) {
                if (expr[i] == '\\') i += 1;
            }
            try tokens.append(expr[token_start .. i + 1]);
            new_token = true;
            token_start = i + 1;
            continue;
        }

        // Skip past comments //
        if (i < expr.len - 1)
            if (expr[i] == ';' and expr[i + 1] == ';') {
                if (!new_token) try tokens.append(expr[token_start..i]);
                while (i < expr.len and expr[i] != '\n') i += 1;
                new_token = true;
                token_start = i + 1;
                continue;
            };

        // Parens //
        if (new_token and (expr[i] == '(' or expr[i] == ')')) {
            try tokens.append(expr[i .. i + 1]);
            new_token = true;
            token_start = i + 1;
            continue;
        }

        // Whitespace delimiting //
        if (text.charIsWhitespace(expr[i])) {
            if (!new_token) try tokens.append(expr[token_start..i]);
            while (i < expr.len - 1 and text.charIsWhitespace(expr[i + 1]))
                i += 1;
            new_token = true;
            token_start = i + 1;
            continue;
        }
        new_token = false;
    }

    return tokens.toOwnedSlice();
}
