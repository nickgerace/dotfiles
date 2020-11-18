# ZSH MAIN
# https://nickgerace.dev

export TERM=xterm-256color
export VISUAL=nvim
export EDITOR=$VISUAL

export PATH=$PATH:/usr/local/bin
export PATH=$HOME/local/bin:$PATH
export DEVELOPER=$HOME/Developer
export DOTFILES=$DEVELOPER/dotfiles

alias sz="source $HOME/.zshrc"
alias zsh-config="cd $DOTFILES/zsh/"

alias dev="cd $DEVELOPER"
alias dotfiles="cd $DOTFILES"
alias scripts="cd $DOTFILES/scripts/"

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

if [[ "$OSTYPE" == "darwin"* ]]; then
    export ZSH_DISABLE_COMPFIX=true
    alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
    alias ls="ls -G"
    alias sed="gsed"
    alias make="gmake"
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
