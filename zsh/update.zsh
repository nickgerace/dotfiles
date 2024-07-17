if [ "$NICK_OS" != "nixos" ]; then
    function update {
        echo "Updating OS packages..."
        if [ "$NICK_OS" = "ubuntu" ] || [ "$NICK_OS" = "pop" ]; then
            sudo apt update
            sudo apt upgrade -y
            sudo apt autoremove -y
        elif [ "$NICK_OS" = "arch" ]; then
            sudo pacman -Syu
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

        if command -v rustup; then
            echo "Running rustup update..."
            rustup update
        fi

        if command -v nix; then
            echo "Updating nix..."
            sudo -i nix upgrade-nix
            nix-channel --update

            if command -v home-manager; then
                echo "Running home-manager switch..."
                home-manager switch
            fi
        fi

        if [ "$NICK_LINUX" = "true" ] && [ "$NICK_WSL2" != "true" ]; then
            if command -v snap; then
                echo "Updating snaps..."
                sudo snap refresh
            fi
            if command -v flatpak; then
                echo "Updating flatpaks..."
                flatpak update -y
                flatpak uninstall --unused
                flatpak repair
            fi
        fi

        # NOTE(nick): disabled since crates will come from package managers or nix via home-manager.
        # function update-crates {
        #     if command -v cargo; then
        #         if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
        #             cargo install --locked cargo-update
        #         fi
        #         cargo install-update -a
        #     fi
        # }
    }
fi
