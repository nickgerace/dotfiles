export TERM=xterm-256color
export VISUAL=nvim
export EDITOR=$VISUAL

export PATH=$PATH:/usr/local/bin
export PATH=$HOME/local/bin:$PATH

alias sz="source $HOME/.zshrc"
alias zsh-config="cd $HOME/dotfiles/zsh/"

alias dotfiles="cd $HOME/dotfiles"
alias scripts="cd $HOME/dotfiles/scripts/"

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
alias rm="rm -i"

alias v=$EDITOR
alias vi=$EDITOR
alias vim=$EDITOR
alias vmake="$EDITOR Makefile"
alias vtmux="$EDITOR $HOME/.tmux.conf"

alias tmuxa="tmux attach -t"
alias tmuxk="tmux kill-session -t"
alias tmuxl="tmux ls"
alias tmuxn="tmux new -s"

alias bye="sudo shutdown now"
alias check-os="cat /etc/os-release"
alias check-power="powerstat -R -c -z"
alias check-firmware="fwupdmgr get-devices"
alias update-firmware="fwupdmgr update"
alias get-public-ip-address="dig +short myip.opendns.com @resolver1.opendns.com"
alias see-drives="sudo fdisk -l"
alias inspiration="fortune | cowsay | lolcat"

bindkey -v
bindkey '^R' history-incremental-search-backward

function find-file {
    if [[ ! $1 ]]; then
        printf "[-] Requires argument(s): <file-name-or-pattern>\n"
    else
        find . -name ${1}
    fi
}

function loop-command {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "[-] Requires argument(s): <command-to-be-looped> <sleep-seconds>\n"
    else
        while true; do ${1}; sleep ${2}; done
    fi
}

function string-grab-first-n-characters {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <string> <n>\n"
    else
        echo "${1}" | cut -c1-${2}
    fi
}

function markdown-to-html {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <input.md> <output.html>\n"
    else
        pandoc ${1} -f markdown -t html5 > ${2}
    fi
}

function ssh-passwordless-setup {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <username> <hostname> <optional-port-number>\n"
    elif [ ! $3 ]; then
        cat ${HOME}/.ssh/id_rsa.pub | ssh ${1}@${2} "mkdir -p ${HOME}/.ssh && chmod 755 ${HOME}/.ssh && cat >> ${HOME}/.ssh/authorized_keys && chmod 644 ${HOME}/.ssh/authorized_keys"
    else
        cat ${HOME}/.ssh/id_rsa.pub | ssh ${1}@${2} -p ${3} "mkdir -p ${HOME}/.ssh && chmod 755 ${HOME}/.ssh && cat >> ${HOME}/.ssh/authorized_keys && chmod 644 ${HOME}/.ssh/authorized_keys"
    fi
}

function trim-whitespace {
    if [ ! $1 ]; then
        printf "Requires argument(s): <path-to-file>\n"
    else
        vim "+%s/\s\+$//e" +wq ${1}
    fi
}

function shasum-github {
    if [ ! $1 ] || [ ! $2 ] || [ ! $3 ]; then
        printf "Argument(s): <user/org> <repo> <release-semver>\n"
    else
        for i in {1..20}; do
            wget https://github.com/${1}/${2}/archive/${3}.tar.gz > /dev/null 2>&1
            shasum -a 256 ${3}.tar.gz
            rm ${3}.tar.gz
        done
    fi
}

