# Build stage
FROM rust:1.56 as cargo-build

WORKDIR /src/websocat

COPY Cargo.toml Cargo.toml

RUN mkdir src/ &&\
    echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs && \
    cargo build --release && \
    rm -f target/release/deps/websocat*

COPY . .
RUN cargo build --release

# Final stage
FROM debian:bullseye-slim

WORKDIR /
COPY --from=cargo-build /src/websocat/target/release/websocat /usr/local/bin

ENTRYPOINT ["/usr/local/bin/websocat"]
