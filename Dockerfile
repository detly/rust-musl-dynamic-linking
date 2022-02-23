FROM alpine
RUN apk update && apk add curl bash file gcc openssl openssl-dev musl-dev gdb colordiff

ENV HOST_DIR="/root"
ENV CARGO_HOME="$HOST_DIR/.cargo"
ENV RUSTUP_HOME="$HOST_DIR/.rustup"
ENV ARCH="x86_64"
ENV RUSTC_TARGET_ARCH="${ARCH}-unknown-linux-musl"
ENV RUSTUP_INIT_ARGS=--no-modify-path\ --profile\ default\ --default-toolchain\ stable\ --target\ "$RUSTC_TARGET_ARCH"

# Don't quote this one, we want it split.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y -v $RUSTUP_INIT_ARGS

RUN "$CARGO_HOME/bin/rustup" toolchain install stable -t "$RUSTC_TARGET_ARCH"
RUN "$CARGO_HOME/bin/rustup" default stable

ENV CROSS_COMPILE="${ARCH}-alpine-linux-musl"
ENV RUSTFLAGS="-C target-feature=-crt-static -C linker=${ARCH}-alpine-linux-musl-gcc -C ar=${ARCH}-alpine-linux-musl-gcc-ar"

ADD . .

RUN "$CARGO_HOME/bin/cargo" build -vv
RUN colordiff -u <(file /bin/busybox) <(file ./target/debug/rust-musl-dynamic-linking) --fakeexitcode
RUN colordiff -u <(ldd /bin/busybox) <(ldd ./target/debug/rust-musl-dynamic-linking) --fakeexitcode
