if [ ! "$(command -v jj)" ]; then
  return
fi

autoload -U compinit
compinit
source <(jj util completion zsh)

alias jjst="jj status"
alias jjd="jj diff"

# Force the learning!
alias git="jj"

# ...but here's an escape hatch when git is installed via homebrew.
if [ ! -f "/opt/homebrew/bin/git" ]; then
  alias jjold="/opt/homebrew/bin/git"

  function jjold-fetch-pull-prune {
    if [ -z "$1" ]; then
      echo "must provide a origin branch name"
      return
    fi
    /opt/homebrew/bin/git fetch --all --tags --prune
    /opt/homebrew/bin/git pull --prune origin "$1"
  }
fi
