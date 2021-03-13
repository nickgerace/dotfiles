export PATH=$PATH:$HOME/.cargo/bin
if [ "$(command -v cargo)" ]; then
    alias cr="cargo run"
    alias crq="cargo run --quiet"
    alias cmr="cargo fmt && cargo run"
    alias cb="cargo build"
    alias cbr="cargo build --release"
    alias ct="cargo test"
fi

if [ "$(command -v rustup)" ]; then
    alias rustup-list="rustup target list"
fi

function cargo-build-static {
    docker pull clux/muslrust
    docker run -v $(pwd):/volume --rm -t clux/muslrust cargo build --release
}

function rustup-default-toolchain-setup {
    if [ "$(uname)" = "Linux" ]; then
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
    else
        rustup toolchain install stable-x86_64-apple-darwin
        rustup toolchain install nightly-x86_64-apple-darwin
        rustup default stable-x86_64-apple-darwin
    fi
}
