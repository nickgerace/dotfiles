function update {
    if [ "$NICK_OS" = "ubuntu" ]; then
        if [ "$(command -v apt)" ]; then
            sudo apt update
            sudo apt upgrade -y
            sudo apt autoremove -y
        fi
        if [ "$(command -v snap)" ] && [ "$NICK_WSL2" != "true" ]; then
            sudo snap refresh
        fi
    elif [ "$NICK_OS" = "fedora" ] && [ "$(command -v dnf)" ]; then
        sudo dnf upgrade --refresh
        sudo dnf autoremove
    elif [ "$NICK_OS" = "opensuse-tumbleweed" ] && [ "$(command -v zypper)" ]; then
        sudo zypper update -y
    elif [ "$NICK_OS" = "darwin" ] && [ "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
        brew bundle dump --force --file $NICK_DOTFILES/darwin/brewfile-$NICK_ARCH.rb
    fi

    if [ "$(command -v rustup)" ]; then
        rustup update
    fi

    if [ "$(command -v cargo)" ]; then
        if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
            cargo install cargo-update
        fi
        cargo install-update -a
        cargo install --list | grep -o "^\S*\S" | jq -Rn '[inputs]' > $NICK_DOTFILES/crates.json
    fi

    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] && [ "$(command -v nvim)" ]; then
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi

    if [ "$NICK_LINUX" = "true" ] && [ "$NICK_WSL2" != "true" ] && [ "$(command -v fwupdmgr)" ]; then
        fwupdmgr update
    fi
}
