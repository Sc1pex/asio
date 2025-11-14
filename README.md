# Fork of asio built with zig

This repository contains a fork of asio, which has been modified to be built with zig 0.15.2.

Currently, this fork only supports building as a static library. Header only and dynamic library builds are not supported yet.

## Example Usage 

```sh
zig fetch --save https://github.com/Sc1pex/asio/archive/refs/tags/v1.36.0.tar.gz
```

Then, in your `build.zig`:

```zig
const asio_dep = b.dependency("asio", .{});
const asio_lib = asio_dep.artifact("asio");

exe.linkLibrary(asio_lib);
```