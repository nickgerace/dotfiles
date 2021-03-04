function update {
    set -x
    local PACKAGES=$HOME/dotfiles/packages

    if [ "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
        local PREFIX=linuxbrew
        if [[ "$OSTYPE" == "darwin"* ]]; then
            PREFIX=brew
        fi
        brew leaves > $PACKAGES/$PREFIX-packages
        brew list --casks -1 > $PACKAGES/$PREFIX-casks
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

    if [ "$(command -v dnf)" ]; then
        sudo dnf upgrade --refresh
        sudo dnf autoremove
        sudo dnf repoquery --userinstalled --queryformat "%{NAME}" > $PACKAGES/dnf-packages
    fi

    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi

    set +x
}
