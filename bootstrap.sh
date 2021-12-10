#!/usr/bin/env bash
set -e

# Change and customize these variable(s) as needed.
BOOTSTRAP_GIT_USER_NAME="Nick Gerace"

# These variables should not be changed and are used internally.
SCRIPTPATH="unknown"

function error-and-exit {
    if [ ! $1 ]; then
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

function rm-file-if-exists {
    if [ ! $1 ]; then
        error-and-exit "must provide argument <path-to-file>"
    fi
    if [ -f $1 ]; then
        rm $1
    fi
}

function prepare-neovim {
    if [ ! -d $HOME/.config/nvim/colors/ ]; then
        mkdir -p $HOME/.config/nvim/colors/
    fi
  	rm-file-if-exists $HOME/.config/nvim/colors/one.vim
  	curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -so $HOME/.config/nvim/colors/one.vim
}

function prepare-git {
    git config --global pull.rebase true
    git config --global user.name "$BOOTSTRAP_GIT_USER_NAME"
}

function link-configfile {
    if [ ! $1 ] || [ ! $2 ]; then
        error-and-exit "must provide arguments <source-path> <destination-path>"
        return
    fi
    rm-file-if-exists $2
    ln -s $1 $2
}

set-scriptpath
prepare-neovim
prepare-git
link-configfile $SCRIPTPATH/zshrc $HOME/.zshrc
link-configfile $SCRIPTPATH/tmux.conf $HOME/.tmux.conf
link-configfile $SCRIPTPATH/init.vim $HOME/.config/nvim/init.vim
