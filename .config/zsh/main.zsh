# ZSH MAIN
# https://nickgerace.dev

# Add autocomplete functionality.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit && compinit

# FIXME: currently disabled. We may or may not need this.
# autoload -U +X bashcompinit && bashcompinit

# Set general settings for the terminal, editor, and more.
export TERM=xterm-256color

# Setup primary editor.
export VISUAL=nvim
export EDITOR=$VISUAL

# Add "local" path additions.
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/local/bin

# Set essential aliases. These are usually OS-independent.
alias vz="$EDITOR $HOME/.zshrc"
alias sz="source $HOME/.zshrc"
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

# Add editor-related aliases based on settings above.
alias v="vim"
alias vi="vim"
alias vmake="$EDITOR Makefile"
alias vtmux="$EDITOR $HOME/.tmux.conf"
alias vvim="$EDITOR $HOME/.vimrc"

# Add tmux-related aliases.
alias tmuxa="tmux attach -t"
alias tmuxk="tmux kill-session -t"
alias tmuxl="tmux ls"
alias tmuxn="tmux new -s"

# Add hardware management aliases (Linux only).
alias bye="sudo shutdown now"
alias check-os="cat /etc/os-release"
alias check-power="powerstat -R -c -z"
alias check-firmware="fwupdmgr get-devices"
alias update-firmware="fwupdmgr update"
alias get-public-ip-address="dig +short myip.opendns.com @resolver1.opendns.com"
alias see-drives="sudo fdisk -l"

# Add macOS settings.
if [[ "$OSTYPE" == "darwin"* ]]; then
    # FIXME: we may not need the following.
    # export ZSH_DISABLE_COMPFIX=true
    export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

