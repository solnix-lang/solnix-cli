const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // 1. Create the compiler module
    const compiler_mod = b.createModule(.{
        .root_source_file = b.path("../solnix-compiler/src/compiler.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 2. Create the executable module
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 3. Add the module (Currently unused by main.zig, but ready)
    exe_mod.addImport("solnix-compiler", compiler_mod);

    // 4. Create the executable
    const exe = b.addExecutable(.{
        .name = "solnix",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    // 4. Run step
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the solnix app");
    run_step.dependOn(&run_cmd.step);
}
