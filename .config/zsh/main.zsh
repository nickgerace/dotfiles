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
alias sz="source $HOME/.zshrc"
alias zsh-config="cd $HOME/.config/zsh/"
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
alias vscode-settings="$EDITOR '$HOME/Library/Application Support/Code/User/settings.json'"

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

# Add macOS settings, and aiases.
if [[ "$OSTYPE" == "darwin"* ]]; then
    export ZSH_DISABLE_COMPFIX=true
    export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
    alias ls="ls -G"
    alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
else
    alias ls="ls --color=auto"
fi

# Generic update function for any OS.
function update() {
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
