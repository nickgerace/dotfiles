# ZSHRC
# https://nickgerace.dev

ZSH_CONFIG_DIR=$HOME/.config/zsh
ZSH_CONFIG_FILE_NAMES=("prompt.zsh" "main.zsh" "lang.zsh" "git.zsh" "container.zsh")

for ZSH_CONFIG_FILE_NAME in $ZSH_CONFIG_FILES; do
    ZSH_CONFIG_FILE_FULL=$ZSH_CONFIG_DIR/$ZSH_CONFIG_FILE_NAME
    if [ -r $ZSH_CONFIG_FILE_FULL ]; then
        source $ZSH_CONFIG_FILE_FULL
    else
        printf "File not found: $ZSH_CONFIG_FILE_FULL\n"
    fi
done
