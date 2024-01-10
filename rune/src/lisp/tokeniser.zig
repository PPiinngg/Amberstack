const std = @import("std");

const log = @import("../util/log.zig");
const text = @import("../util/text.zig");

pub fn tokeniser(alloc: std.mem.Allocator, expr: []const u8) ![][]const u8 {
    var tokens = std.ArrayList([]const u8).init(alloc);
    errdefer tokens.deinit();

    var i: usize = 0;
    var token_start: usize = i;
    var new_token: bool = true;

    while (i < expr.len) : (i += 1) {
        if (try tokeniseString('"', &tokens, expr, &i, &token_start, &new_token)) continue;
        if (try tokeniseString('\'', &tokens, expr, &i, &token_start, &new_token)) continue;
        if (try ignoreComment(&tokens, expr, &i, &token_start, &new_token)) continue;
        if (try tokeniseParentheses(&tokens, expr, &i, &token_start, &new_token)) continue;
        if (try tokeniseOtherOnWhitespace(&tokens, expr, &i, &token_start, &new_token)) continue;
        new_token = false;
    }
    // Catch-all for anything remaining
    if (!new_token) try tokens.append(expr[token_start..expr.len]);

    return tokens.toOwnedSlice();
}

inline fn tokeniseString(
    delimiter: u8,
    tokens: *std.ArrayList([]const u8),
    expr: []const u8,
    i: *usize,
    token_start: *usize,
    new_token: *bool,
) !bool {
    if (new_token.* and expr[i.*] == delimiter) {
        i.* += 1;
        while (i.* < expr.len - 1 and expr[i.*] != delimiter) : (i.* += 1) {
            if (expr[i.*] == '\\') i.* += 1;
        }
        try tokens.append(expr[token_start.* .. i.* + 1]);
        new_token.* = true;
        token_start.* = i.* + 1;
        return true;
    }
    return false;
}

inline fn ignoreComment(
    tokens: *std.ArrayList([]const u8),
    expr: []const u8,
    i: *usize,
    token_start: *usize,
    new_token: *bool,
) !bool {
    if (i.* < expr.len - 1)
        if (expr[i.*] == ';' and expr[i.* + 1] == ';') {
            if (!new_token.*) try tokens.append(expr[token_start.*..i.*]);
            while (i.* < expr.len and expr[i.*] != '\n') i.* += 1;
            new_token.* = true;
            token_start.* = i.* + 1;
            return true;
        };
    return false;
}

inline fn tokeniseParentheses(
    tokens: *std.ArrayList([]const u8),
    expr: []const u8,
    i: *usize,
    token_start: *usize,
    new_token: *bool,
) !bool {
    if (expr[i.*] == '(' or expr[i.*] == ')') { // Parens //
        if (!new_token.*) try tokens.append(expr[token_start.*..i.*]);
        try tokens.append(expr[i.* .. i.* + 1]);
        new_token.* = true;
        token_start.* = i.* + 1;
        return true;
    }
    return false;
}

inline fn tokeniseOtherOnWhitespace(
    tokens: *std.ArrayList([]const u8),
    expr: []const u8,
    i: *usize,
    token_start: *usize,
    new_token: *bool,
) !bool {
    if (text.charIsWhitespace(expr[i.*])) { // Whitespace delimiting //
        if (!new_token.*) try tokens.append(expr[token_start.*..i.*]);
        while (i.* < expr.len - 1 and text.charIsWhitespace(expr[i.* + 1]))
            i.* += 1;
        new_token.* = true;
        token_start.* = i.* + 1;
        return true;
    }
    return false;
}
