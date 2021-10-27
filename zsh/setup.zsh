function setup {
    if [ "$NICK_OS" = "opensuse-tumbleweed" ]; then
        sudo zypper install -y -t pattern devel_basis
        sudo zypper install -y openssl libopenssl-devel make zsh jq curl wget neovim vim gcc-c++ ruby ruby-devel go
    elif [ "$NICK_OS" = "darwin" ]; then
        if ! [ "$(command -v brew)" ]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew bundle install --no-lock --file $NICK_DOTFILES/Brewfile
    fi

    if ! [ "$(command -v rustup) " ]; then
        curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
    fi

    if [ "$NICK_OS" = "darwin" ]; then
        rustup toolchain install stable-$NICK_ARCH-apple-darwin
        rustup toolchain install nightly-$NICK_ARCH-apple-darwin
        rustup default stable-$NICK_ARCH-apple-darwin
    elif [ "$NICK_ARCH" = "x86_64" ]; then
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
    else
        echo "non-amd64 non-darwin system detected: setup rustup toolchain manually"
        return
    fi

    cargo install $(jq -r ".[]" $NICK_DOTFILES/crates.json)
}