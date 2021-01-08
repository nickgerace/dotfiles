# ZSH CONFIG
# https://nickgerace.dev

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
    source $HOME/.nix-profile/etc/profile.d/nix.sh
    alias hm="home-manager"
fi
