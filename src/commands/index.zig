const std = @import("std");

// Import specific command modules
pub const run = @import("run.zig");
pub const build = @import("build.zig");

pub fn printWelcome() void {
    const RESET = "\x1b[0m";
    const BOLD  = "\x1b[1m";
    const CYAN  = "\x1b[96m";
    const GREEN = "\x1b[92m";
    const WHITE = "\x1b[97m";

    std.debug.print(
        \\
        \\┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
        \\*                                                              *
        \\   {s}{s}Solnix{s}{s} Compiler CLI v0.1.0                         
        \\   {s}{s}System Ready:{s}{s} Modern toolchain for Solnix             
        \\*                                                              *
        \\┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
        \\
        \\Usage:
        \\    solnix <command> [options]
        \\
        \\Commands:
        \\    run     Compile and run the program
        \\    build   Compile the program to an object file
        \\    check   Analyze the source code for errors
        \\
        \\
    , .{
        // Line 1 (4 args)
        CYAN, BOLD, RESET, WHITE,
        // Line 2 (4 args)
        GREEN, BOLD, RESET, WHITE,
    });
}


pub fn printHelp() void {
    const RESET = "\x1b[0m";
    const BOLD = "\x1b[1m";

    std.debug.print(
        \\┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
        \\┃                       {s}Solnix CLI Help{s}                    ┃
        \\┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
        \\
        \\USAGE:
        \\    solnix [COMMAND]
        \\
        \\COMMANDS:
        \\    run     Compile and execute the program immediately.
        \\    build   Compile the source code into an ELF object file.
        \\    help    Show this message.
        \\
    , .{
        BOLD, RESET,
    });
}
