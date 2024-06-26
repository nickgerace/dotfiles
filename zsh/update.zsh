function update {
    function prepare-permissions {
        sudo -v
    }

    function update-os-packages {
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
    }

    function update-rustup {
        if command -v rustup; then
            rustup update
        fi
    }

    function update-nix-and-packages {
        if command -v nix; then
            sudo -i nix upgrade-nix
            nix-channel --update

            if command -v home-manager; then
                home-manager switch
            fi
        fi
    }

    function update-snap-and-flatpak-packages {
        if [ "$NICK_LINUX" = "true" ] && [ "$NICK_WSL2" != "true" ]; then
            if command -v snap; then
                sudo snap refresh
            fi
            if command -v flatpak; then
                flatpak update -y
                flatpak uninstall --unused
                flatpak repair
            fi
        fi
    }

    # NOTE(nick): disabled since crates will come from package managers or nix via home-manager.
    # function update-crates {
    #     if command -v cargo; then
    #         if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
    #             cargo install --locked cargo-update
    #         fi
    #         cargo install-update -a
    #     fi
    # }

    set -x

    prepare-permissions
    update-os-packages
    update-rustup
    update-nix-and-packages
    update-snap-and-flatpak-packages

    set +x
}
