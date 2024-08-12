if [ "$NICK_OS" != "nixos" ] && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ "$(command -v nix)" ]; then
  alias ndc="nix develop --command"
fi

if [ "$(command -v home-manager)" ]; then
  if [ "$NICK_OS" != "nixos" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  fi

  alias hm="home-manager"
  alias hme="home-manager edit"
  alias hms="home-manager switch"
  alias hml="home-manager packages | sort"
fi
