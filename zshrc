# Add autocomplete functionality before everything else.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit
compinit
autoload -U +X bashcompinit
bashcompinit

# If facing issues on macOS, run the following command...
# compaudit | xargs chmod g-w

# These environment variables are used in other ZSH configuration files.
export NICK_SRC=$HOME/src
export NICK_DOTFILES=$NICK_SRC/dotfiles
export NICK_ARCH="$(uname -m)"

# Set OS-based environment variables.
if [ "$(uname -s)" = "Darwin" ]; then
    export NICK_OS="darwin"
    export NICK_LINUX="false"
    export NICK_WSL2="false"
elif [ "$(uname -s)" = "Linux" ]; then
    NICK_LINUX="true"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        export NICK_OS="$ID"
    else
        export NICK_OS="unknown"
    fi

    if [ -f /proc/sys/kernel/osrelease ] && [ $(grep "WSL2" /proc/sys/kernel/osrelease) ]; then
        export NICK_WSL2="true"
    else
        export NICK_WSL2="false"
    fi
else
    export NICK_OS="unknown"
    export NICK_LINUX="false"
    export NICK_WSL2="false"
fi

function nick-environment-variables {
    echo "NICK_ARCH            $NICK_ARCH"
    echo "NICK_OS              $NICK_OS"
    echo "NICK_LINUX           $NICK_LINUX"
    echo "NICK_WSL2            $NICK_WSL2"
    echo "NICK_SRC             $NICK_SRC"
    echo "NICK_DOTFILES        $NICK_DOTFILES"
}

for ZSH_CONFIG_FILE in $NICK_DOTFILES/zsh/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        echo "file not readable or not found: $ZSH_CONFIG_FILE"
    fi
done
