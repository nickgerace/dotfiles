# ZSH CONFIG
# https://nickgerace.dev

if [[ "$OSTYPE" == "darwin"* ]]; then
    export ZSH_DISABLE_COMPFIX=true
    alias fix-compaudit-errors-on-macos="compaudit | xargs chmod g-w"
    alias ls="ls -G"
    alias sed="gsed"
    alias make="gmake"
else
    alias ls="ls --color=auto"
fi
