# ZSH CODE
# https://nickgerace.dev

if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
fi

alias code-open-here="code ."

function code-settings {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ${EDITOR} "${HOME}/Library/Application\ Support/Code/User/settings.json"
    else
        ${EDITOR} "${HOME}/.config/Code/User/settings.json"
    fi
}

function code-install-extensions {
    if [ "$(command -v code)" ]; then
        EXTENSIONS=$DOTFILES/code/extensions.txt
        if [ -r $EXTENSIONS ]; then
            while IFS= read -r line; do
                code --install-extension $line
            done < "$EXTENSIONS"
        else
            printf "Cannot access file: $EXTENSIONS\n"
        fi
    else
        printf "Visual Studio Code not installed.\n"
    fi
}
