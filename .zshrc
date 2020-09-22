# ZSHRC
# https://nickgerace.dev

ZSH_CONFIG_DIR=$HOME/.config/zsh

ZSH_CONFIG_FILES=("main.zsh" "prompt.zsh" "lang.zsh" "git.zsh" "container.zsh")
for ZSH_CONFIG_FILE in $ZSH_CONFIG_FILES; do
    if [ -r $ZSH_CONFIG_DIR/$ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_DIR/$ZSH_CONFIG_FILE
    else
        printf "File not found: $ZSH_CONFIG_DIR/$ZSH_CONFIG_FILE"
    fi
done
