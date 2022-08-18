if [ "$NICK_OS" = "darwin" ]; then
    export ZSH_DISABLE_COMPFIX=true
    alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
    alias ls="ls -G"

    # Use GNU Make instead of BSD Make.
    if [ -d /opt/homebrew/opt/make/libexec/gnubin ]; then
        alias PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
    fi
else
    alias ls="ls --color=auto"
fi
