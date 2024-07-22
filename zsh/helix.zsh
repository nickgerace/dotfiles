if [ "$NICK_OS" = "arch" ]; then
    if [ "$(command -v helix)" ]; then
        alias hx="helix"
        alias nvim="hx"
        alias hxe="hx ~/.config/helix/"
    fi
elif [ "$(command -v hx)" ]; then
    alias nvim="hx"
    alias hxe="hx ~/.config/helix/"
    alias hxd="hx $NICK_DOTFILES"
fi
