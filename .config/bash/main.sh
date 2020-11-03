# BASH MAIN
# https://nickgerace.dev

case $- in    
    *i*) ;;    
      *) return;;    
esac

export TERM=xterm-256color
shopt -s checkwinsize
export HISTTIMEFORMAT="%d/%m/%y %T | "

export VISUAL=nvim
export EDITOR=$VISUAL
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/local/bin

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
    source /usr/local/etc/profile.d/bash_completion.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/profile.d/bash_completion.sh ]; then
    source /etc/profile.d/bash_completion.sh
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
else
    printf "Unable to start bash completion.\n"
fi

alias sb="source $HOME/.bashrc"
alias bash-config="cd $HOME/.config/bash/"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../"
alias .......="cd ../../../../../"
alias fa="alias | grep"
alias grep-no-match="grep -L"
alias h="history"
alias history="fc -lf -20"
alias path='echo $PATH | sed "s/:/\n/g"'
alias ping5="ping -c 5"
alias rm="rm -i"

alias v="$EDITOR"
alias vi="$EDITOR"
alias vim="$EDITOR"
alias vmake="$EDITOR Makefile"
alias vtmux="$EDITOR $HOME/.tmux.conf"
alias vvim="$EDITOR $HOME/.vimrc"

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

if [[ -x /usr/bin/dircolors ]]; then
    alias ls="ls --color=auto"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
    alias ls="ls -G"
    alias sed="gsed"
else
    alias ls="ls --color=auto"
fi

function update {
    printf "[+] Updating all...\n"
    if [[ "$OSTYPE" == "darwin"* ]] && [ "$(command -v brew)" ]; then
        printf "[+] brew update\n"
        brew update
        printf "[+] brew upgrade\n"
        brew upgrade
        printf "[+] brew cleanup\n"
        brew cleanup
    fi
    if [ "$(command -v rustup)" ]; then
        printf "[+] rustup update\n"
        rustup update
    fi
    printf "[+] All updates completed.\n"
}

function find-file {
    if [[ ! $1 ]]; then
        printf "[-] Requires argument(s): <file-name-or-pattern>\n"
    else
        find . -name ${1}
    fi
}
