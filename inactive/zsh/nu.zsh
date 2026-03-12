if [ ! "$(command -v nu)" ]; then
  return
fi

alias nu="/opt/homebrew/bin/nu --config $NICK_DOTFILES/nu/config.nu"
