const std = @import("std");
const compiler = @import("solnix-compiler");
const utils = @import("utils.zig");

pub fn execute(allocator: std.mem.Allocator, args: []const []const u8) !void {
    if (args.len < 3) {
        std.log.err("Usage: solnix build <input_file.snx> [output_file]", .{});
        std.log.err("Example: solnix build program.snx program.o", .{});
        std.process.exit(1);
    }

    const input_file = args[2];
    const output_file = if (args.len > 3) args[3] else "out.o";

    utils.validateSnxInputFile(input_file) catch |err| {
        switch (err) {
            utils.UtilError.InvalidFileExtension => std.log.err("Invalid file extension. Expected .snx: {s}", .{input_file}),
            utils.UtilError.FileNotFound => std.log.err("Input file not found: {s}", .{input_file}),
            else => std.log.err("Input file error ({any}): {s}", .{ err, input_file }),
        }
        std.process.exit(1);
    };

    // Read input file
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    const src = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(src);

    std.log.info("Compiling {s}...", .{input_file});

    // Use compiler library directly
    compiler.compile(src, output_file) catch |err| {
        std.log.err("Compilation failed: {any}", .{err});
        std.process.exit(1);
    };

    std.log.info("Build successful: {s}", .{output_file});
}
