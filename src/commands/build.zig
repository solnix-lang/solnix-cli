const std = @import("std");
const utils = @import("utils.zig");

pub fn execute(
    allocator: std.mem.Allocator,
    args: []const []const u8,
) !void {
    if (args.len < 3) {
        std.log.err("Usage: solnix build <input_file.snx> [output_file]", .{});
        std.log.err("Example: solnix build program.snx program.o", .{});
        std.process.exit(1);
    }

    const input_file = args[2];
    const output_file = if (args.len > 3) args[3] else "out.o";

    
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
            "Install it or set SOLNIX_COMPILER=/path/to/solnix-compiler",
            .{},
        );
        std.process.exit(1);
    };
    
    defer allocator.free(compiler_path);

    std.log.info("Using compiler: {s}", .{compiler_path});
    std.log.info("Building {s} → {s}", .{ input_file, output_file });

    
    var argv = [_][]const u8{
        compiler_path,
        "compile",
        input_file,
        "-o",
        output_file,
    };

    var child = std.process.Child.init(&argv, allocator);
    child.stdin_behavior = .Inherit;
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    const term = try child.spawnAndWait();
    
    
    const exited_successfully = switch (term) {
        .Exited => |code| code == 0,
        else => false,
    };

    if (!exited_successfully) {
        std.log.err("Compilation failed", .{});
        std.process.exit(1);
    }

    std.log.info("Build successful: {s}", .{output_file});
}