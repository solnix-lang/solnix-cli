const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    // Build the executable
    const exe = b.addExecutable(.{
        .name = "solnix", // name expected by install.sh
        .root_module = b.createModule(.{
            .root_source_file = b.path("./src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Install the executable to zig-out/bin
    b.installArtifact(exe);

    // Make this the default build target
    b.default_step.dependOn(&exe.step);

    // Optional: allow `zig build run` to execute the CLI
    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
