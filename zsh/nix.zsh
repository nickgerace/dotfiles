if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ "$(command -v nix)" ]; then
    alias nix-search="nix search nixpkgs"
    alias ndc="nix develop --command"
fi

if [ "$(command -v home-manager)" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

    alias hm="home-manager"
    alias hme="home-manager edit"
    alias hms="home-manager switch"
    alias hml="home-manager packages | sort"
else
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

if [ "$(command -v direnv)" ]; then
    # Source: https://github.com/direnv/direnv/issues/106#issuecomment-1027330218
    if [ -n "$tmux" ] && [ -n "$direnv_dir" ]; then
        unset "${!direnv_@}"  # unset env vars starting with direnv_
    fi
    eval "$(direnv hook zsh)"
fi

