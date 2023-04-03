function update {
    function apt-upgrade {
        if [ "$(command -v apt)" ]; then
            sudo apt update
            sudo apt upgrade -y
            sudo apt autoremove -y
        fi
    }

    function update-rust-analyzer {
        if [ ! -d ~/.local/bin ]; then
            mkdir -p ~/.local/bin
        fi

        if [ -f ~/.local/bin/rust-analyzer ]; then
            rm ~/.local/bin/rust-analyzer
        fi

        curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
        chmod +x ~/.local/bin/rust-analyzer
    }

    # OS-specific package upgrades.
    if [ "$NICK_OS" = "ubuntu" ] || [ "$NICK_OS" = "pop" ]; then
        apt-upgrade
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

    # Linux desktop snap and flatpak upgrades.
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

    if [ "$(command -v rustup)" ]; then
        rustup update
    fi

    if [ "$(command -v cargo)" ]; then
        if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
            cargo install --locked cargo-update
        fi
        cargo install-update -a
        cargo install --list | grep -o "^\S*\S" > $NICK_DOTFILES/crates.txt
    fi

    # Do not use volta at the moment.
    # if [ "$(command -v volta)" ]; then
    #     volta install node
    # fi

    # Update the rust-analzyer binary too.
    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] && [ "$(command -v nvim)" ]; then
        update-rust-analyzer
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi

    # Needed until the following issue is resolved: https://github.com/pop-os/system76-power/issues/299
    # Must run AFTER all other updates and checks.
    if [ "$NICK_OS" = "fedora" ] && [ "$(command -v system76-power)" ]; then
        sudo systemctl start system76-power
        echo "started system76-power"
    fi
}

function update-rust-analyzer {
    if [ ! -d ~/.local/bin ]; then
        mkdir -p ~/.local/bin
    fi

    if [ -f ~/.local/bin/rust-analyzer ]; then
        rm ~/.local/bin/rust-analyzer
    fi

    echo "downloading latest rust-analyzer"
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer
}
