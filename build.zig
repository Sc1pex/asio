const std = @import("std");

const AddHeaders = struct {
    lib: *std.Build.Step.Compile,
    b: *std.Build,

    header_dir_prefix: []const u8,
};

fn add_headers_recursive(p: AddHeaders, dir: std.fs.Dir, curr_prefix: []const u8) !void {
    var it = dir.iterate();

    while (try it.next()) |entry| {
        if (entry.kind == .file) {
            const header_file = std.fmt.allocPrint(p.b.allocator, "{s}/{s}/{s}", .{ p.header_dir_prefix, curr_prefix, entry.name }) catch unreachable;
            const header_path = std.fmt.allocPrint(p.b.allocator, "{s}/{s}", .{ curr_prefix, entry.name }) catch unreachable;
            p.lib.installHeader(p.b.path(header_file), header_path[1..]); // Remove leading '/'
        } else if (entry.kind == .directory) {
            const sub_dir = try dir.openDir(entry.name, .{ .iterate = true });
            const new_prefix = std.fmt.allocPrint(p.b.allocator, "{s}/{s}", .{ curr_prefix, entry.name }) catch unreachable;
            try add_headers_recursive(p, sub_dir, new_prefix);
        }
    }
}

fn add_asio_headers(b: *std.Build, lib: *std.Build.Step.Compile) !void {
    const asio_include_dir = try std.fs.cwd().openDir(b.pathFromRoot("asio/include"), .{ .iterate = true });
    try add_headers_recursive(.{
        .lib = lib,
        .b = b,
        .header_dir_prefix = "asio/include",
    }, asio_include_dir, "");
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const asio = b.addLibrary(.{
        .name = "asio",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        }),
    });
    asio.root_module.addIncludePath(b.path("asio/include"));
    asio.root_module.addCMacro("ASIO_SEPARATE_COMPILATION", "1");
    asio.root_module.addCSourceFile(.{
        .file = b.path("asio/src/asio.cpp"),
        .flags = &.{
            "-std=c++23",
        },
    });
    try add_asio_headers(b, asio);

    b.installArtifact(asio);
}
