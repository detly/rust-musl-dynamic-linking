# rust-musl-dynamic-linking

This repository attempts to reproduce a linker issue that I have with Rust. It shows up when you try to build a Rust binary that is dynamically linked to MUSL. Instead of the correct interpreter, Cargo assigns a glibc interpreter to the binary which will not allow the binary to work on MUSL-based systems such as Alpine.

### Reproduction Steps

1. Build the Dockerfile with `docker build . --progress=plain --no-cache`
2. See the difference in interpreter that my binary gets linked against versus a binary such as `/lib/busybox`
