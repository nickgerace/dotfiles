#!/usr/bin/env bash
if ! [ $(command -v zsh) ]; then
    echo "could not find \"zsh\" in PATH"
    exit 1
fi

function add-to-etc-shells {
    ZSH=$(command -v zsh)
    echo ${ZSH} | sudo tee -a /etc/shells
    chsh -s ${ZSH}
}

add-to-etc-shells
