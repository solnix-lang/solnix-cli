const std = @import("std");

pub const UtilError = error{
    InvalidFileExtension,
    FileNotFound,
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
