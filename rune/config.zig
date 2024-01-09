// BUILD SETTINGS //
is_debug_build: bool = true,

// LIMITS //
prompt_input_buffer_bytes: comptime_int = 1 << 14, // 16k
max_chained_semicolon_delimited_commands: comptime_int = 64,
