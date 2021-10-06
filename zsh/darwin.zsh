if [[ "$OSTYPE" == "darwin"* ]]; then
    export ZSH_DISABLE_COMPFIX=true
    alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias brew-install-packages-from-dotfiles="brew bundle install --no-lock --file $NICK_DOTFILES/Brewfile"
fi
