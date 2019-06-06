#!/bin/bash

##
# DOTFILES
# created by: Nick Gerace
#
# MIT License, Copyright (c) Nick Gerace
# See "LICENSE" file for more information
#
# Please find license and further
# information via the link below.
# https://github.com/nickgerace/dotfiles
##

echo "[dotfiles] Copying files to repository..."
cp ~/.zshrc ~/github/dotfiles
cp ~/.vimrc ~/github/dotfiles
cp ~/.aliases ~/github/dotfiles
git -C ~/github/dotfiles status
echo "[dotfiles] Update complete!"
