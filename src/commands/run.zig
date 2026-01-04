const std = @import("std");
const utils = @import("utils.zig");

pub fn execute(
    allocator: std.mem.Allocator,
    args: []const []const u8,
) !void {
    if (args.len < 3) {
        std.log.err("Usage: solnix run <input_file.snx>", .{});
        std.process.exit(1);
    }

    const input_file = args[2];

    utils.validateSnxInputFile(input_file) catch |err| {
        switch (err) {
            utils.UtilError.InvalidFileExtension =>
                std.log.err("Invalid file extension (.snx required): {s}", .{input_file}),
            utils.UtilError.FileNotFound =>
                std.log.err("Input file not found: {s}", .{input_file}),
            else =>
                std.log.err("Input file error ({any}): {s}", .{ err, input_file }),
        }
        std.process.exit(1);
    };

    const compiler_path = utils.findCompiler(allocator) catch {
        std.log.err(
            "solnix-compiler not found.\n" ++
            "Install it or set SOLNIX_COMPILER",
            .{},
        );
        std.process.exit(1);
    };

    std.log.info("Using compiler: {s}", .{compiler_path});
    std.log.info("Compiling {s}...", .{input_file});

    const temp_output = "solnix_temp.o";

    var argv = [_][]const u8{
        compiler_path,
        "compile",
        input_file,
        "-o",
        temp_output,
    };

    var child = std.process.Child.init(&argv, allocator);
    child.stdin_behavior = .Inherit;
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    const term = try child.spawnAndWait();
    if (term.Exited != 0) {
        std.log.err("Compilation failed", .{});
        std.process.exit(1);
    }

    std.log.info("Compilation successful", .{});
    std.log.info("Output: {s}", .{temp_output});
    std.log.warn("Execution not implemented yet", .{});
}
