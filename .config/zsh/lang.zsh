# ZSH LANG
# https://nickgerace.dev

# Go settings and pathing.
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:/usr/local/go/bin
export PATH=${GOPATH//://bin:}/bin:$PATH

# Ruby settings and pathing. If installed, set up the environment.
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
if [[ -d $HOME/.rbenv/bin ]]; then
    eval "$(rbenv init -)"
fi

# Adjust settings for Rust and Cargo.
export PATH=$PATH:$HOME/.cargo/bin
if [ "$(command -v cargo)" ]; then
    alias cr="cargo run"
    alias crq="cargo run --quiet"
    alias cb="cargo build"
    alias cbr="cargo build --release"
    alias ct="cargo test"
fi

# Add aliases for applications available on crates.io.
if [ "$(command -v bat)" ]; then
    alias cat="bat -p"
    alias bat="bat --theme=ansi-light"
fi
if [ "$(command -v exa)" ]; then
    alias ls="exa"
    alias x="exa"
fi
if [ "$(command -v rg)" ]; then
    alias grep="rg"
    alias rgh="rg --hidden"
fi
if [ "$(command -v fd)" ]; then
    alias find="fd"
    alias fdh="fd --hidden"
fi

# Use Docker to build a staticlly-linked Rust project.
function cargo-build-static {
    PWD=$(pwd)
    docker pull clux/muslrust
    docker run -v $PWD:/volume --rm -t clux/muslrust cargo build --release
}

