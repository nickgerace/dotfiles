# BASHRC
# https://nickgerace.dev

BASH_CONFIG_DIR=$HOME/.config/bash
for BASH_CONFIG_FILE in $BASH_CONFIG_DIR/*; do
    if [ -r $BASH_CONFIG_FILE ]; then
        source $BASH_CONFIG_FILE
    else
        printf "File not found: $BASH_CONFIG_FILE\n"
    fi
done
