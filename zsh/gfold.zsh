if [ ! "$(command -v gfold)" ]; then
  alias gfold="nix run nixpkgs#gfold"
fi
