if [ "$NICK_OS" = "arch" ]; then
  export EDITOR=helix
else
  export EDITOR=hx
fi

export TERM=xterm-256color
export VISUAL=$EDITOR

export PATH=$PATH:/usr/local/bin
export PATH=$HOME/.local/bin:$PATH

alias sz="source $HOME/.zshrc"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../"
alias .......="cd ../../../../../"
alias alias-search="alias | grep"
alias grep-no-match="grep -L"
alias h="history"
alias history="fc -lf -20"
alias ping5="ping -c 5"
alias rmi="rm -i"

alias v=$EDITOR
alias vi=$EDITOR
alias vim=$EDITOR

alias disks="sudo fdisk -l"
alias inspiration="fortune | cowsay | lolcat"

bindkey -v
bindkey '^R' history-incremental-search-backward

alias uuidgen-seven="uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-7"
alias which-linker="ld --verbose > default.ld"
alias log-to-file="echo '2\>\&1 \| tee'"

alias path='echo $PATH | sed "s/:/\n/g"'
alias path-pretty-print="tr ':' '\n' <<< \"$PATH\""

function find-file {
  if [ ! $1 ]; then
    echo "required argument: <file-name-or-pattern>"
    return
  fi
  find . -name ${1}
}

function loop-command {
  if [ ! $1 ]; then
    echo "required argument(s): <command-to-be-looped> <optional-sleep-seconds>"
    return
  fi
  local SLEEP_SECONDS=15
  if [ $2 ] && [ "$2" != "" ]; then
    SLEEP_SECONDS=$2
  fi
  while true; do
    ${1}
    sleep $SLEEP_SECONDS
  done
}

function string-grab-first-n-characters {
  if [ ! $1 ] || [ ! $2 ]; then
    echo "required arguments: <string> <number-of-first-characters>\n"
    return
  fi
  echo "${1}" | cut -c1-${2}
}

function markdown-to-html {
  if [ ! $1 ] || [ ! $2 ]; then
    echo "required arguments: <input.md> <output.html>"
    return
  fi
  if [ ! $(command -v pandoc) ]; then
    echo "must be installed and in PATH: pandoc"
    return
  fi
  pandoc ${1} -f markdown -t html5 >${2}
}

function strip-and-size {
  if [ ! $1 ]; then
    echo "required argument: <path-to-binary>"
    return
  fi
  du -h $1
  strip $1
  du -h $1
}

function directory-sizes {
  du -hs * | sort -hr
}

function rick {
  curl -s -L http://bit.ly/10hA8iC | bash
}

function dotfiles {
  cd $NICK_DOTFILES
}
