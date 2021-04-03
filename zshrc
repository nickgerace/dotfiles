# Add autocomplete functionality before everything else.
# Solution: https://github.com/kubernetes/kubectl/issues/125#issuecomment-351653836
autoload -U +X compinit
compinit

# If facing issues on macOS, run the following command...
# compaudit | xargs chmod g-w

# Leaving the below commented for now. We may or may not need this.
# autoload -U +X bashcompinit && bashcompinit

export DOTFILES=$HOME/github.com/nickgerace/dotfiles
local ZSH_CONFIG_DIR=$DOTFILES/zsh

for ZSH_CONFIG_FILE in $ZSH_CONFIG_DIR/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        printf "File not found: $ZSH_CONFIG_FILE\n"
    fi
done
