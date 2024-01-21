if [ -s "/Users/nick/.bun/_bun" ]; then
    source "/Users/nick/.bun/_bun"
fi

if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi
