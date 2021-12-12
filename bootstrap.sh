#!/usr/bin/env bash
set -e

# Configurable
BOOTSTRAP_GIT_USER_NAME="Nick Gerace"

# Not configurable
SCRIPTPATH="unknown"

function error-and-exit {
    if [ "$1" = "" ]; then
        error-and-exit "must provide argument <error-message>"
    fi
    echo "error: $1"
    exit 1
}

function set-scriptpath {
    if [ "$(uname -s)" = "Linux" ]; then
        SCRIPTPATH=$(dirname $(realpath $0))
    elif [ "$(uname -s)" = "Darwin" ]; then
        SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
    else
        error-and-exit "host must be Darwin or Linux"
    fi
}

function init-filepath {
    if [ ! $1 ]; then
        error-and-exit "must provide argument <path-to-file>"
    fi
    if [ ! -d $(dirname $1) ]; then
        mkdir -p $(dirname $1)
    fi
    if [ -f $1 ]; then
        rm $1
    fi
}

function download-neovim-theme {
    init-filepath $HOME/.config/nvim/colors/one.vim
    curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -so $HOME/.config/nvim/colors/one.vim
}

function configure-git {
    git config --global pull.rebase true
    git config --global user.name "$BOOTSTRAP_GIT_USER_NAME"
}

function link-configfile {
    if [ ! $1 ] || [ ! $2 ]; then
        error-and-exit "must provide arguments <source-path> <destination-path>"
        return
    fi
    init-filepath $2
    if [ "$(uname -s)" = "Linux" ]; then
        ln -sfn $1 $2
    else
        ln -s $1 $2
    fi
}

set-scriptpath
link-configfile $SCRIPTPATH/zshrc $HOME/.zshrc
link-configfile $SCRIPTPATH/tmux.conf $HOME/.tmux.conf
link-configfile $SCRIPTPATH/init.vim $HOME/.config/nvim/init.vim
link-configfile $SCRIPTPATH/alacritty.yml $HOME/.config/alacritty/alacritty.yml
download-neovim-theme
configure-git
