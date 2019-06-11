#!/bin/bash

##
# UPDATE DOTFILES
# created by: Nick Gerace
#
# MIT License, Copyright (c) Nick Gerace
# See "LICENSE" file for more information
#
# Please find license and further
# information via the link below.
# https://github.com/nickgerace/dotfiles
##

COLOR='\033[0;35m'
NC='\033[0m'
echo -e "    ${COLOR}Copying dotfiles to git repository ...${NC}"
cp ~/.zshrc ~/github/dotfiles
cp ~/.vimrc ~/github/dotfiles
cp ~/.aliases ~/github/dotfiles
cp -r ~/.scripts ~/github/dotfiles
echo -e "    ${COLOR}Checking git status ...${NC}"
git -C ~/github/dotfiles status
echo -e "    ${COLOR}Update complete!${NC}"
