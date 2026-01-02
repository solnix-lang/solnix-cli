const std = @import("std");
// Import the index file from the commands folder
const commands = @import("commands/index.zig");

pub fn main() !void {
    // Allocator setup
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Get arguments
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // 1. Default State: Show Welcome
    if (args.len == 1) {
        commands.printWelcome();
        return;
    }

    const cmd = args[1];

    // 2. Route commands to their specific files
    if (std.mem.eql(u8, cmd, "run")) {
        // Calls execute() in commands/run.zig
        try commands.run.execute(allocator, args);
    } else if (std.mem.eql(u8, cmd, "build")) {
        // Calls execute() in commands/build.zig
        try commands.build.execute(allocator, args);
    } else if (std.mem.eql(u8, cmd, "--help") or std.mem.eql(u8, cmd, "-h")) {
        commands.printHelp();
    } else {
        std.log.err("Error: Unknown command '{s}'", .{cmd});
        std.log.err("Run './solnix --help' for usage.", .{});
        std.process.exit(1);
    }
}