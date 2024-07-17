if [ "$NICK_OS" = "nixos" ]; then
  alias hx-nixos="sudoedit /etc/nixos/configuration.nix"
  alias rebuild="sudo nixos-rebuild switch"

  # TODO(nick): get this working or use flakes.
  # export NIX_PATH="nixos-config=$HOME/src/dotfiles/configuration.nix"
  export PATH="$HOME/.npm-global/bin:$PATH"
fi
