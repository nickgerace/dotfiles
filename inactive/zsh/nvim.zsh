if [ "$(command -v nvim)" ]; then
  alias nvim-upgrade="nvim +PlugUpgrade +PlugUpdate +PlugClean +qall"
  alias nvim-install="nvim +PlugInstall +qall"

  function update-neovim-plugins {
    if [ -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ] && command -v nvim; then
      nvim --headless +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi
  }

  function trim-whitespace {
    if [ ! $1 ]; then
      echo "requires argument: <path-to-file>"
      return
    fi
    if [ ! $(command -v nvim) ]; then
      echo "must be installed and in PATH: nvim"
      return
    fi
    nvim "+%s/\s\+$//e" +wq ${1}
  }
fi
