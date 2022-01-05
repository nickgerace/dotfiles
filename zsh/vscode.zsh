# Unnecessary alias, but just in case...
alias code-open-here="code ."

function code-settings {
    local SETTINGS="$HOME/.config/Code/User/settings.json"
    if [ "$NICK_OS" = "darwin" ]; then
        SETTINGS="$HOME/Library/Application\ Support/Code/User/settings.json"
    fi
    if [ ! -f $SETTINGS ]; then
        echo "settings file does not exist at expected location: $SETTINGS"
        return
    fi
    ${EDITOR} ${SETTINGS}
}

function code-install-extensions {
    xargs code --install-extension < $NICK_DOTFILES/extensions.txt
}
