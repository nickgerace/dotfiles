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

echo "[check-git-status] checking dotfiles..."
git -C ~/github/dotfiles status
echo "[check-git-status] checking full-stack-python-template..."
git -C ~/github/full-stack-python-template status
echo "[check-git-status] checking lateralus..."
git -C ~/github/lateralus status
echo "[check-git-status] checking private..."
git -C ~/github/private status
