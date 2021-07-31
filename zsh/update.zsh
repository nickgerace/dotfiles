function update {
    set -ex

    local TYPE=""
    if [ "$(uname -s)" = "Darwin" ]; then
        TYPE="darwin"
    else
        if [ -f /etc/os-release ]; then
            local ID=$(grep '^ID=' / | sed 's/^ID=//')
            if [ "$ID" = "ubuntu" ] || [ "$ID" = "fedora" ]; then
                TYPE=$ID
            fi
        else
            echo "could not find /etc/os-release"
            return
        fi
    fi
    if [ "$TYPE" = "" ]; then
        echo "invalid type (available: darwin ubuntu fedora)"
        return
    fi
    echo "detected type: $TYPE"

    if [ "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
        # Install for the first time: brew bundle install --no-lock --file $BREWFILE
        brew bundle dump --force --file $DOTFILES/Brewfile
    fi

    if [ "$(command -v rustup)" ]; then
        rustup update
    fi

    if [ "$(command -v cargo)" ]; then
        if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
            cargo install cargo-update
        fi
        cargo install-update -a
        # Install for the first time: xargs cargo install < $DOTFILES/crates
        cargo install --list | grep -o "^\S*\S" > $DOTFILES/crates
    fi

    if [ "$TYPE" = "fedora" ] && [ "$(command -v dnf)" ]; then
        sudo dnf upgrade --refresh
        sudo dnf autoremove
        sudo dnf repoquery --userinstalled --queryformat "%{NAME}" > $DOTFILES/fedora/dnf-packages
    fi

    if [ "$TYPE" = "ubuntu" ] && [ "$(command -v apt)" ]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
    fi

    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi

    set +ex
}
