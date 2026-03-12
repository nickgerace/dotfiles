if [ "$NICK_OS" = "darwin" ]; then
  export ZSH_DISABLE_COMPFIX=true
  alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
  if [ ! "$(command -v eza)" ]; then
    alias ls="ls -G"
  fi

  # Use GNU Make instead of BSD Make.
  if [ -d /opt/homebrew/opt/make/libexec/gnubin ]; then
    alias PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
  fi
else
  alias ls="ls --color=auto"
fi
