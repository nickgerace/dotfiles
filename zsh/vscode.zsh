if [ "$(command -v code)" ]; then
    # Unnecessary alias, but just in case...
    alias code-open-here="code ."
fi

function code-dir {
    local CODE_DIR="$HOME/.config/Code/User/"
    if [ "$NICK_OS" = "darwin" ]; then
        CODE_DIR="$HOME/Library/Application\ Support/Code/User/"
    fi
    if [ ! -d $CODE_DIR ]; then
        echo "could not change to directory (does not exist): $CODE_DIR"
        return
    fi
    cd $CODE_DIR
}
