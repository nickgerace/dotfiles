# ZSH CONFIG
# https://nickgerace.dev

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:/usr/local/go/bin
export PATH=${GOPATH//://bin:}/bin:$PATH

export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
if [[ -d $HOME/.rbenv/bin ]]; then
    eval "$(rbenv init -)"
fi

export PATH=$PATH:$HOME/.cargo/bin
if [ "$(command -v cargo)" ]; then
    alias cr="cargo run"
    alias crq="cargo run --quiet"
    alias cmr="cargo fmt && cargo run"
    alias cb="cargo build"
    alias cbr="cargo build --release"
    alias ct="cargo test"
fi

function cargo-build-static {
    docker pull clux/muslrust
    docker run -v $(pwd):/volume --rm -t clux/muslrust cargo build --release
}

function go-mod-vendor {
    printf "Remove the old module first from go.mod\n"
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <module-url> <git-hash>\n"
    else
        go get ${1}@${2}
        go mod vendor
    fi
}
