function update {
    set -x

    # OS-specific package upgrades
    if [ "$NICK_OS" = "ubuntu" ] || [ "$NICK_OS" = "pop" ]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
    elif [ "$NICK_OS" = "fedora" ]; then
        if command -v dnf5; then
            sudo dnf5 upgrade -y --refresh
            sudo dnf autoremove -y
        else
            sudo dnf upgrade -y --refresh
            sudo dnf autoremove -y
        fi
    elif [ "$NICK_OS" = "opensuse-tumbleweed" ]; then
        sudo zypper update -y
    elif [ "$NICK_OS" = "darwin" ] && command -v brew; then
        brew update
        brew upgrade
        brew cleanup
    fi

    # Toolchain and package updates
    if command -v rustup; then
        rustup update
    fi
    if [ -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ] && command -v nvim; then
        nvim --headless +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi

    # Nix profile updates
    if command -v nix && [ ! "$(command -v home-manager)" ]; then
        nix profile upgrade '.*'
        nix upgrade-nix
    fi

    # Linux desktop snap and flatpak upgrades
    if [ "$NICK_LINUX" = "true" ] && [ "$NICK_WSL2" != "true" ]; then
        if [ "$(command -v snap)" ]; then
            sudo snap refresh
        fi
        if [ "$(command -v flatpak)" ]; then
            flatpak update -y
            flatpak uninstall --unused
            flatpak repair
        fi
    fi

    # Update crates
    if command -v cargo; then
        if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
            cargo install --locked cargo-update
        fi
        cargo install-update -a
    fi

    set +x
}
