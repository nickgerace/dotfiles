if [ ! "$(command -v caligua)" ]; then
  alias caligua="nix run nixpkgs#caligula"
fi
