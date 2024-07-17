if [ "$NICK_OS" != "nixos" ] && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ "$(command -v nix)" ]; then
    alias nix-search="nix search nixpkgs"
    alias ndc="nix develop --command"
fi

if [ "$(command -v home-manager)" ]; then
    # TODO(nick): confirm how these variables should be setup.
    if [ "$NICK_OS" != "nixos" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi

    alias hm="home-manager"
    alias hme="home-manager edit"
    alias hms="home-manager switch"
    alias hml="home-manager packages | sort"
elif [ "$NICK_OS" != "nixos" ]; then
    # Only use nix profile commands is home-manager is not installed.
    alias nix-upgrade="nix profile upgrade '.*'"

    function nix-install {
        if [ ! $1 ] || [ "$1" = "" ]; then
            echo "need to provide package name from nixpkgs"
            return
        fi
        nix profile install nixpkgs#${1}
    }
fi
