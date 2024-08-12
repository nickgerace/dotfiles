if [ "$NICK_OS" = "darwin" ]; then
    if [ -d /opt/homebrew/bin ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    if [ -d /opt/homebrew/opt/ruby/bin ]; then
        export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    fi
elif [ "$NICK_LINUX" = "true" ]; then
    if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    fi
fi
