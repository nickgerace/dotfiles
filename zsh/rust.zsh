export PATH=$PATH:$HOME/.cargo/bin
if [ "$(command -v cargo)" ]; then
    alias cr="cargo run --"
    alias crq="cargo run --quiet --"
    alias cmr="cargo fmt && cargo run"
    alias cb="cargo build"
    alias ct="cargo test"
    alias cx="cargo xtask"
    
    alias cargo-install-crates-from-dotfiles="xargs cargo install < $DOTFILES/crates"
fi

if [ "$(command -v rustup)" ]; then
    alias rustup-list="rustup target list"
fi

function cargo-update-crates {
    cargo install-update -a
}

function cargo-fmt-all {
    cargo fmt --all -- --check
    cargo clippy -- -D warnings
}

function cargo-check-all {
    cargo +nightly fmt
    cargo +nightly clippy
    cargo +nightly udeps
    cargo bloat
}

function cargo-build-static {
    if [ ! -f Cargo.toml ]; then
        docker pull clux/muslrust
        docker run -v $(pwd):/volume --rm -t clux/muslrust cargo build --release
    else
        echo "file not found in current working directory: Cargo.toml"
    fi
}

function cbr {
    cargo build --release
    local CRATE=target/release/$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].name')
    du -h $CRATE
    du $CRATE
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
