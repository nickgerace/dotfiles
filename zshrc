# Add autocomplete functionality before everything else.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit
compinit
autoload -U +X bashcompinit
bashcompinit

# If facing issues on macOS, run the following command...
# compaudit | xargs chmod g-w

# These environment variables are used in other ZSH configuration files.
export NICK_GITHUB_REPOS=$HOME/github.com/nickgerace
export NICK_DOTFILES=$NICK_GITHUB_REPOS/dotfiles
export NICK_RANCHER=$NICK_GITHUB_REPOS/rancher
export NICK_RANCHER_CHARTS=$NICK_GITHUB_REPOS/rancher-charts
export NICK_ARCH="$(uname -m)"

# Set the OS and WSL2 variables for usage in other scripts.
if [ "$(uname -s)" = "Darwin" ]; then
    export NICK_OS="darwin"
    export NICK_LINUX="false"
elif [ -f /etc/os-release ]; then
    OS_RELEASE_ID=$(grep '^ID=' /etc/os-release | sed 's/^ID=//' | tr -d '"')
    if [ "$OS_RELEASE_ID" = "ubuntu" ] || [ "$OS_RELEASE_ID" = "fedora" ] || [ "$OS_RELEASE_ID" = "opensuse-tumbleweed" ]; then
        export NICK_OS="$OS_RELEASE_ID"
        export NICK_LINUX="true"
    else
        export NICK_OS="unknown"
        export NICK_LINUX="unknown"
    fi

    if [ -f /proc/sys/kernel/osrelease ] && [ $(grep "WSL2" /proc/sys/kernel/osrelease) ]; then
        export NICK_WSL2="true"
    else
        export NICK_WSL2="false"
    fi
else
    export NICK_OS="unknown"
    export NICK_LINUX="unknown"
fi

for ZSH_CONFIG_FILE in $NICK_DOTFILES/zsh/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        echo "file not readable or not found: $ZSH_CONFIG_FILE"
    fi
done
