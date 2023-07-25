if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ $(command -v nix) ]; then
    alias nix-search="nix search nixpkgs"
    alias ndc="nix develop --command"
    alias nix-upgrade="nix profile upgrade '.*'"

    function nix-install {
        if [ ! $1 ] || [ "$1" = "" ]; then
            echo "need to provide package name from nixpkgs"
            return
        fi
        nix profile install nixpkgs#${1}
    }
fi

if [ $(command -v direnv) ]; then
    eval "$(direnv hook zsh)"
fi

