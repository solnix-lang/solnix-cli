const std = @import("std");

pub const UtilError = error{
    InvalidFileExtension,
    FileNotFound,
};

pub const FindCompilerError = error{
    CompilerNotFound,
    OutOfMemory,
};

pub fn validateSnxInputFile(path: []const u8) !void {
    if (!std.mem.endsWith(u8, path, ".snx")) {
        return UtilError.InvalidFileExtension;
    }

    var f = std.fs.cwd().openFile(path, .{}) catch |err| switch (err) {
        error.FileNotFound => return UtilError.FileNotFound,
        else => return err,
    };
    f.close();
}

pub fn findCompiler(allocator: std.mem.Allocator) ![]const u8 {
    // 1. Check environment variable override
    if (std.process.getEnvVarOwned(allocator, "SOLNIX_COMPILER")) |path| {
        if (fileExists(path)) return path;
        allocator.free(path);
    } else |_| {}

    // 2. Search PATH
    const path_env = std.process.getEnvVarOwned(allocator, "PATH") 
        catch return error.CompilerNotFound;
    defer allocator.free(path_env);

    var it = std.mem.splitScalar(u8, path_env, std.fs.path.delimiter);
    while (it.next()) |dir| {
        const full = std.fs.path.join(
            allocator,
            &.{ dir, "solnix-compiler" },
        ) catch continue; 

        if (fileExists(full)) {
            return full; // Return the allocated string; caller must free it
        }
        
        // Only free if we didn't return it
        allocator.free(full);
    }

    return error.CompilerNotFound;
}

fn fileExists(path: []const u8) bool {
    std.fs.cwd().access(path, .{}) catch return false;
    return true;
}