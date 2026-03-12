if [ -f $HOME/.fzf.zsh ]; then
  source $HOME/.fzf.zsh
fi

if [ "$(command -v fzf)" ]; then
  source <(fzf --zsh)
fi
