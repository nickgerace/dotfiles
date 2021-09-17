# Add autocomplete functionality before everything else.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit
compinit
autoload -U +X bashcompinit
bashcompinit

# If facing issues on macOS, run the following command...
# compaudit | xargs chmod g-w

# Change to the home directory on WSL2.
if [ -f /proc/sys/kernel/osrelease ] \
    && [ $(grep "WSL" /proc/sys/kernel/osrelease) ] \
    && [[ "$PWD" == "/mnt/c/Users/"* ]]; then
    cd $HOME
fi

# This environment variable is used in other ZSH configuration files.
export DOTFILES=$HOME/github.com/nickgerace/dotfiles

for ZSH_CONFIG_FILE in $DOTFILES/zsh/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        printf "File not found: $ZSH_CONFIG_FILE\n"
    fi
done
