// BUILD SETTINGS //
is_debug_build: bool = true,

// THEME //
prompt_glyph: []const u8 = "ᛮ ",

// LIMITS //
repl_input_buffer_bytes: comptime_int = 1 << 14, // 16k
cmd_max_chained_commands: comptime_int = 64,
lisp_ast_max_tree_depth: comptime_int = 64,
