if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin"
fi

# Unnecessary alias, but just in case...
alias code-open-here="code ."

function code-settings {
    local SETTINGS="${HOME}/.config/Code/User/settings.json"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SETTINGS="${HOME}/Library/Application\ Support/Code/User/settings.json"
    fi
    if [ ! -f $SETTINGS ]; then
        echo "settings file does not exist at expected location: $SETTINGS"
        return
    fi
    ${EDITOR} ${SETTINGS}
}

function code-extensions-install {
    if ! [ "$(command -v code)" ]; then
        echo "must be installed: Visual Studio Code"
        return
    fi
    EXTENSIONS=$DOTFILES/code/extensions.txt
    if [ -r $EXTENSIONS ]; then
        while IFS= read -r line; do
            code --install-extension $line
        done < "$EXTENSIONS"
    else
        echo "cannot access file: $EXTENSIONS"
    fi
}
