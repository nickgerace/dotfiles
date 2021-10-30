if [ "$NICK_OS" = "darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi