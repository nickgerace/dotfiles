export PATH=$HOME/.cargo/bin:$PATH

if [ "$(command -v cargo)" ]; then
    alias cr="cargo run"
    alias crq="cargo run --quiet"
    alias cmr="cargo fmt && cargo run"
    alias cb="cargo build"
    alias ct="cargo test"
    alias cx="cargo xtask"

    alias cargo-doc-watch="cargo watch -s 'cargo doc --all'"
    alias cargo-wipe="$NICK_DOTFILES/scripts/cargo-wipe.sh $NICK_SRC"
fi

if [ "$(command -v rustup)" ]; then
    alias rustup-list="rustup target list"
fi

function cargo-fmt-all {
    cargo fmt --all -- --check
    cargo clippy -- -D warnings
}

function cargo-check-all {
    cargo +nightly fmt
    cargo clippy
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
    local CRATE
    CRATE="target/release/$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].name')"
    du -h $CRATE
}

function cargo-all {
    cargo build --all
    cargo fix --edition-idioms --allow-dirty --allow-staged
    cargo fmt --all
    cargo clippy
}
