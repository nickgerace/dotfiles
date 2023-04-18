function update {
    # Start with home-manager
    if [ $(command -v home-manager) ]; then
        nix-channel --update
        home-manager switch
    fi

    # OS-specific package upgrades
    if [ "$NICK_OS" = "ubuntu" ] || [ "$NICK_OS" = "pop" ]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
    elif [ "$NICK_OS" = "fedora" ] && [ "$(command -v dnf)" ]; then
        sudo dnf upgrade -y --refresh
        sudo dnf autoremove -y
    elif [ "$NICK_OS" = "opensuse-tumbleweed" ] && [ "$(command -v zypper)" ]; then
        sudo zypper update -y
    elif [ "$NICK_OS" = "darwin" ] && [ "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
    fi

    # rustup updates (works with home-manager for only the toolchains themselves)
    if [ "$(command -v rustup)" ]; then
        rustup update
    fi

    # neovim updates (works with home-manager)
    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] && [ "$(command -v nvim)" ]; then
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
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

    # Actions we should only allow when home-manager is not being used
    if [ ! "(command -v home-manager)" ]; then
        if [ "$(command -v cargo)" ]; then
            if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
                cargo install --locked cargo-update
            fi
            cargo install-update -a
            # cargo install --list | grep -o "^\S*\S" > $NICK_DOTFILES/crates.txt
        fi
    fi

    # Needed until the following issue is resolved: https://github.com/pop-os/system76-power/issues/299
    # Must run AFTER all other updates and checks.
    if [ "$NICK_OS" = "fedora" ] && [ "$(command -v system76-power)" ]; then
        sudo systemctl start system76-power
        echo "started system76-power"
    fi
}