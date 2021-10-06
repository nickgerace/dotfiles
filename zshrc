# Add autocomplete functionality before everything else.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit
compinit
autoload -U +X bashcompinit
bashcompinit

# If facing issues on macOS, run the following command...
# compaudit | xargs chmod g-w

# These environment variables are used in other ZSH configuration files.
export NICK_DOTFILES=$HOME/github.com/nickgerace/dotfiles
export NICK_RANCHER=$HOME/github.com/nickgerace/rancher
export NICK_RANCHER_CHARTS=$HOME/github.com/nickgerace/rancher-charts
if [ -f /proc/sys/kernel/osrelease ] && [ $(grep "WSL2" /proc/sys/kernel/osrelease) ]; then
    export NICK_WSL2="true"
fi

for ZSH_CONFIG_FILE in $NICK_DOTFILES/zsh/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        printf "File not found: $ZSH_CONFIG_FILE\n"
    fi
done
