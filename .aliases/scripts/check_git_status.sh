#!/bin/bash

##
# CHECK GIT STATUS
# created by: Nick Gerace
#
# MIT License, Copyright (c) Nick Gerace
# See "LICENSE" file for more information
#
# Please find license and further
# information via the link below.
# https://github.com/nickgerace/dotfiles
##

RED='\033[0;31m'
NC='\033[0m'
echo -e "${RED}>>> determinant-domination <<<${NC}"
git -C ~/github/determinant-domination status
echo -e "${RED}>>> dotfiles <<<${NC}"
git -C ~/github/dotfiles status
echo -e "${RED}>>> full-stack-python-template <<<${NC}"
git -C ~/github/full-stack-python-template status
echo -e "${RED}>>> lateralus <<<${NC}"
git -C ~/github/lateralus status
echo -e "${RED}>>> private <<<${NC}"
git -C ~/github/private status
