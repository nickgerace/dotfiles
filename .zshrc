# ZSHRC
# https://nickgerace.dev

ZSH_CONFIG_DIR=$HOME/.config/zsh

for ZSH_CONFIG_FILE in $ZSH_CONFIG_DIR/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        printf "File not found: $ZSH_CONFIG_FILE\n"
    fi
done
