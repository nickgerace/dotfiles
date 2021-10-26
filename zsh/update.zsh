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
        sudo dnf repoquery --userinstalled --queryformat "%{NAME}" > $NICK_DOTFILES/fedora/dnf-packages
    elif [ "$NICK_OS" = "opensuse-tumbleweed" ] && [ "$(command -v zypper)" ]; then
        sudo zypper update -y
    elif [ "$NICK_OS" = "darwin" ] && [ "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
        brew bundle dump --force --file $NICK_DOTFILES/Brewfile
    fi

    if [ "$(command -v rustup)" ]; then
        rustup update
    fi

    if [ "$(command -v cargo)" ]; then
        cargo-update-crates
    fi

    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] && [ "$(command -v nvim)" ]; then
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi
}
