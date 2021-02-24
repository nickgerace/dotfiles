function update {
    printf "[+] Updating all...\n"

    if [ "$(command -v brew)" ]; then
        printf "[+] brew update\n"
        brew update
        printf "[+] brew upgrade\n"
        brew upgrade
        printf "[+] brew cleanup\n"
        brew cleanup
    fi

    if [ "$(command -v rustup)" ]; then
        printf "[+] rustup update\n"
        rustup update
    fi

    if [ "$(command -v cargo)" ]; then
        if [ ! -f ~/.cargo/bin/cargo-install-update ]; then
            printf "[+] cargo install cargo-update\n"
            cargo install cargo-update
        fi
        printf "[+] cargo install-update -a\n"
        cargo install-update -a
    fi

    TEMP_FEDORA=$(cat /etc/os-release | grep "^NAME=Fedora$")
    if [ "$(command -v dnf)" ] && [ ! -z $TEMP_FEDORA ]; then
        printf "[+] sudo dnf upgrade --refresh\n"
        sudo dnf upgrade --refresh
        printf "[+] sudo dnf autoremove\n"
        sudo dnf autoremove
    fi

    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        printf "[+] nvim +PlugUpgrade +PlugUpdate +PlugClean +qall\n"
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi

    printf "[+] All updates completed.\n"
}
