# Add autocomplete functionality before everything else.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit
compinit
autoload -U +X bashcompinit
bashcompinit

# If facing issues on macOS, run the following command...
# compaudit | xargs chmod g-w

# These environment variables are used in other ZSH configuration files.
export DOTFILES=$HOME/github.com/nickgerace/dotfiles
if [ -f /proc/sys/kernel/osrelease ] && [ $(grep "WSL2" /proc/sys/kernel/osrelease) ]; then
    export IS_WSL2="true"
fi

# Change to the home directory on WSL2.
if [ "$IS_WSL2" = "true" ] && [[ "$PWD" == "/mnt/c/Users/"* ]]; then
    cd $HOME
fi

for ZSH_CONFIG_FILE in $DOTFILES/zsh/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        printf "File not found: $ZSH_CONFIG_FILE\n"
    fi
done
