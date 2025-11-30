const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("asio", .{});

    const asio = b.addLibrary(.{
        .name = "asio",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        }),
    });
    asio.root_module.addIncludePath(upstream.path("include"));
    asio.root_module.addCMacro("ASIO_SEPARATE_COMPILATION", "1");
    asio.root_module.addCSourceFile(.{
        .file = upstream.path("src/asio.cpp"),
        .flags = &.{
            "-std=c++23",
        },
    });
    asio.installHeadersDirectory(
        upstream.path("include"),
        "",
        .{ .include_extensions = &.{ ".hpp", ".ipp" } },
    );

    b.installArtifact(asio);
}
