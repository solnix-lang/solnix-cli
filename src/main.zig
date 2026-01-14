const std = @import("std");

const commands = @import("commands/index.zig");

pub fn main() !void {
    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    
    if (args.len == 1) {
        commands.printWelcome();
        return;
    }

    const cmd = args[1];

    
    if (std.mem.eql(u8, cmd, "run")) {
        
        try commands.run.execute(allocator, args);
    } else if (std.mem.eql(u8, cmd, "build")) {
        
        try commands.build.execute(allocator, args);
    } else if (std.mem.eql(u8, cmd, "--help") or std.mem.eql(u8, cmd, "-h")) {
        commands.printHelp();
    } else {
        std.log.err("Error: Unknown command '{s}'", .{cmd});
        std.log.err("Run './solnix --help' for usage.", .{});
        std.process.exit(1);
    }
}