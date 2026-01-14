const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    
    const exe = b.addExecutable(.{
        .name = "solnix", 
        .root_module = b.createModule(.{
            .root_source_file = b.path("./src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    
    b.installArtifact(exe);

    
    b.default_step.dependOn(&exe.step);

    
    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
