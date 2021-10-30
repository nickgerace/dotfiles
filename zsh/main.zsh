export TERM=xterm-256color
export EDITOR=nvim
export VISUAL=$EDITOR

export PATH=$PATH:/usr/local/bin
export PATH=$HOME/.local/bin:$PATH

if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
    export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
fi

if [ -f $HOME/.fzf.zsh ]; then
    source $HOME/.fzf.zsh
fi

alias sz="source $HOME/.zshrc"

alias dotfiles="cd $NICK_DOTFILES"
alias scripts="cd $NICK_DOTFILES/scripts/"

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
alias path='echo $PATH | sed "s/:/\n/g"'
alias ping5="ping -c 5"
alias rmi="rm -i"

alias v=$EDITOR
alias vi=$EDITOR
alias vim=$EDITOR

alias tmuxa="tmux attach -t"
alias tmuxk="tmux kill-session -t"
alias tmuxl="tmux ls"
alias tmuxn="tmux new -s"

alias see-drives="sudo fdisk -l"
alias inspiration="fortune | cowsay | lolcat"

bindkey -v
bindkey '^R' history-incremental-search-backward

alias gfld=$HOME/.cargo/bin/gfold
alias bat="bat --theme=OneHalfLight"
alias uuidgen-seven="uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-7"
alias which-linker="ld --verbose > default.ld"
alias jq-keys="jq 'keys'"
alias log-to-file="echo '2\>\&1 \| tee'"
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
    while true; do ${1}; sleep $SLEEP_SECONDS; done
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
    pandoc ${1} -f markdown -t html5 > ${2}
}

function trim-whitespace {
    if [ ! $1 ]; then
        echo "requires argument: <path-to-file>"
        return
    fi
    local VIMLIKE=nvim
    if [ ! $(command -v nvim) ]; then
        if [ ! $(command -v vim) ]; then
            echo "must be installed and in PATH: vim"
            return
        fi
        VIMLIKE=vim
    fi
    ${VIMLIKE} "+%s/\s\+$//e" +wq ${1}
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
    local SORT=sort
    if [ "$NICK_OS" = darwin ]; then
        if [ ! $(command -v gsort) ]; then
            echo "gsort required: brew install coreutils"
            return
        fi
        SORT=gsort
    fi
    du -hs * | $SORT -hr
}
