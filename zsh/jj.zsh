if [ "$(command -v jj)" ]; then
  autoload -U compinit
  compinit
  source <(jj util completion zsh)
fi
