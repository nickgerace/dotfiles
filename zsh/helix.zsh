if [ "$NICK_OS" = "arch" ] && [ "$(command -v helix)" ]; then
  alias hx="helix"

  alias nvim="hx"
  alias hxe="hx ~/.config/helix/"
  alias hxd="hx $NICK_DOTFILES"
  alias hxz="hx ~/.config/zellij/config.kdl"
elif [ "$(command -v hx)" ]; then
  alias nvim="hx"
  alias hxe="hx ~/.config/helix/"
  alias hxd="hx $NICK_DOTFILES"
  alias hxz="hx ~/.config/zellij/config.kdl"
fi
