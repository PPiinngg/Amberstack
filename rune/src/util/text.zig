const std = @import("std");

// Whitespace Handling //
pub inline fn charIsWhitespace(char: u8) bool {
    return if (char == ' ' or char == 0x09 or char == '\n') true else false;
}

pub inline fn firstNonWhitespaceChar(input: []u8) u8 {
    for (input) |char|
        if (!charIsWhitespace(char)) return char;
    return 0;
}

pub fn trimTrailingWhitespace(input: []u8) []u8 {
    var no_whitespace_slice_start: usize = 0;
    for (0..input.len) |i| {
        if (!charIsWhitespace(input[i])) {
            no_whitespace_slice_start = i;
            break;
        }
    }

    var no_whitespace_slice_end: usize = no_whitespace_slice_start;
    for (no_whitespace_slice_start..input.len) |i| {
        if (!charIsWhitespace(input[i]))
            no_whitespace_slice_end = i + 1;
    }

    return input[no_whitespace_slice_start..no_whitespace_slice_end];
}
