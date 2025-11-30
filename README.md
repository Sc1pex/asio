# asio

A build.zig for [asio](https://think-async.com/Asio/). Intended for C++ projects using Zig as a build tool.

## Usage 

```sh
zig fetch --save https://github.com/Sc1pex/asio/archive/refs/tags/v1.36.0.tar.gz
```

Then, in your `build.zig`:

```zig
const asio_dep = b.dependency("asio", .{});
const asio_lib = asio_dep.artifact("asio");

exe.linkLibrary(asio_lib);
```

After that, you can use asio in C++:

```cpp
#include <asio.hpp>

int main() {
    asio::io_context io;
    asio::steady_timer t(io, asio::chrono::seconds(5));
    t.wait();
}
```
