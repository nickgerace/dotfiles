#!/usr/bin/env bash
ZSH=$(command -v zsh)
echo ${ZSH} | sudo tee -a /etc/shells
chsh -s ${ZSH}
