if [ "$(command -v zypper)" ]; then
    alias zin="sudo zypper install -y"
    alias zup="sudo zypper update -y"
    alias zrm="sudo zypper remove -y"
    alias zypper-install-build-essential="sudo zypper install -y -t pattern devel_basis"

    function opensuse-setup {
        sudo zypper install -y -t pattern devel_basis
        sudo zypper install -y openssl libopenssl-devel make zsh jq curl wget
    }
fi

