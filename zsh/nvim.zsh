if [ "$(command -v nvim)" ]; then
    alias nvim-upgrade="nvim +PlugUpgrade +PlugUpdate +PlugClean +qall"
    alias nvim-install="nvim +PlugInstall +qall"
fi