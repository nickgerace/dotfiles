if [ $(command -v nix) ]; then
    alias nix-search="nix search nixpkgs"
    alias ndc="nix develop --command"
fi

if [ $(command -v direnv) ]; then
    eval "$(direnv hook zsh)"
fi
