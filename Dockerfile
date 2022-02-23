FROM alpine
RUN apk update && apk add curl bash file gcc openssl openssl-dev musl-dev
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ADD . .
RUN RUSTFLAGS="-C target-feature=-crt-static" cargo build --release
RUN file /bin/busybox
RUN file ./target/release/rust-musl-dynamic-linking
RUN ldd /bin/busybox
RUN ldd ./target/release/rust-musl-dynamic-linking
