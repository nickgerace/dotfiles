export PATH=$PATH:$HOME/.cargo/bin
if [ "$(command -v cargo)" ]; then
    alias cr="cargo run --"
    alias crq="cargo run --quiet --"
    alias cmr="cargo fmt && cargo run"
    alias cb="cargo build"
    alias ct="cargo test"
    alias cx="cargo xtask"
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

function rust-setup {
    if ! [ "$(command -v rustup) " ]; then
        curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
    fi
    if [ "$(uname -s)" = "Darwin" ]; then
        local ARCH="aarch64"
        if [ "$(uname -m)" = "x86_64" ]; then
            ARCH="x86_64"
        fi
        rustup toolchain install stable-$ARCH-apple-darwin
        rustup toolchain install nightly-$ARCH-apple-darwin
        rustup default stable-$ARCH-apple-darwin
    else
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
    fi
    cargo install $(jq -r ".[]" $NICK_DOTFILES/crates.json)
}

function cargo-update-crates {
    if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
        cargo install cargo-update
    fi
    cargo install-update -a
    cargo install --list | grep -o "^\S*\S" | jq -Rn '[inputs]' > $NICK_DOTFILES/crates.json
}
