const std = @import("std");

pub fn build(b: *std.Build) !void {
    const asio = b.addLibrary(.{
        .name = "asio",
        .root_module = b.createModule(.{
            .target = b.graph.host,
        }),
    });
    asio.root_module.addIncludePath(b.path("asio/include"));
    asio.linkLibCpp();
    asio.root_module.addCMacro("ASIO_SEPARATE_COMPILATION", "1");
    asio.root_module.addCSourceFile(.{
        .file = b.path("asio/src/asio.cpp"),
        .flags = &.{
            "-std=c++23",
        },
    });

    b.installArtifact(asio);
    b.installDirectory(.{
        .source_dir = b.path("asio/include"),
        .install_dir = .prefix,
        .install_subdir = "include",
    });
}
