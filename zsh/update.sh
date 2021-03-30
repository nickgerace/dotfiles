function update {
    if [ ! $1 ]; then
        echo "Supply argument: -S/-u/-Su"
        echo "  -S   sync dotfiles repository"
        echo "  -u   update existing packages"
        echo "  -Su  perform both actions (sync and then update)"
        return
    fi

    set -ex
    local PACKAGES=$DOTFILES/packages

    if [ "$1" = "-S" ] || [ "$1" = "-Su" ]; then
        ( cd $DOTFILES; git pull origin main )

        if [ "$(command -v brew)" ]; then
            local SUFFIX=linux
            if [ "$(uname -s)" = "Darwin" ]; then
                SUFFIX=darwin
            fi
            brew bundle install --no-lock --file $PACKAGES/brewfile-$SUFFIX
        fi

        if [ "$(command -v cargo)" ]; then
            xargs cargo install < $PACKAGES/cargo-packages
        fi

        if [ "$(command -v apt)" ] && [ "$(uname -s)" != "Darwin" ]; then
            sudo apt update
            sudo apt install build-essential libssl-dev
            sudo apt autoremove
        fi
    fi

    if [ "$1" = "-u" ] || [ "$1" = "-Su" ]; then
        if [ "$(command -v brew)" ]; then
            brew update
            brew upgrade
            brew cleanup
            local SUFFIX=linux
            if [ "$(uname -s)" = "Darwin" ]; then
                SUFFIX=darwin
            fi
            brew bundle dump --force --file $PACKAGES/brewfile-$SUFFIX
        fi

        if [ "$(command -v rustup)" ]; then
            rustup update
        fi

        if [ "$(command -v cargo)" ]; then
            if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
                cargo install cargo-update
            fi
            cargo install-update -a
            cargo install --list | grep -o "^\S*\S" > $PACKAGES/cargo-packages
        fi

        if [ "$(command -v dnf)" ] && [ "$(uname -s)" != "Darwin" ]; then
            sudo dnf upgrade --refresh
            sudo dnf autoremove
            sudo dnf repoquery --userinstalled --queryformat "%{NAME}" > $PACKAGES/dnf-packages
        fi

        # We do not store apt packages into a file due to inconsistencies in results.
        if [ "$(command -v apt)" ] && [ "$(uname -s)" != "Darwin" ]; then
            sudo apt update
            sudo apt upgrade
            sudo apt autoremove
        fi

        if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
            nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
        fi
    fi

    set +ex
}
