if [[ "$OSTYPE" == "darwin"* ]]; then
    export ZSH_DISABLE_COMPFIX=true
    alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
    alias ls="ls -G"
    if [ "$(command -v gsed)" ]; then alias sed="gsed"; fi
    if [ "$(command -v gmake)" ]; then alias make="gmake"; fi
else
    alias ls="ls --color=auto"
fi
