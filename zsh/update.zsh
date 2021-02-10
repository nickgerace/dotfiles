function update {
    printf "[+] Updating all...\n"

    if [[ "$OSTYPE" == "darwin"* ]] && [ "$(command -v brew)" ]; then
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

    if [ "$(command -v home-manager)" ]; then
        printf "[+] home-manager switch\n"
        home-manager switch
    fi

    TEMP_FEDORA=$(cat /etc/os-release | grep "^NAME=Fedora$")
    if [ "$(command -v dnf)" ] && [ ! -z $TEMP_FEDORA ]; then
        printf "[+] sudo dnf upgrade --refresh\n"
        sudo dnf upgrade --refresh
        printf "[+] sudo dnf autoremove\n"
        sudo dnf autoremove
    fi

    printf "[+] All updates completed.\n"
}
