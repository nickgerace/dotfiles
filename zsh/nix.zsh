if [ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

if [ $(command -v home-manager) ]; then
    alias hm="home-manager"
    alias hms="home-manager switch --flake $NICK_DOTFILES"
    alias hml="home-manager packages | sort"
fi

if [ $(command -v nix) ]; then
    alias nix-search="nix search nixpkgs"
    alias ndc="nix develop --command"
fi
