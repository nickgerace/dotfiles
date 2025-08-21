#!/usr/bin/env bash
set -euxo pipefail

if [ "$(uname -s)" = "Darwin" ]; then
  brew install fnm
elif [ "$(uname -s)" = "Linux" ] && [ -f /etc/os-release ]; then
  . /etc/os-release
  if [ "$ID" = "arch" ]; then
    paru -S --noconfirm fnm
  else
    exit 1
  fi
else
  exit 1
fi

fnm install 18 # used by SI
source ~/.zshrc # get fnm completions

mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH="$HOME/.npm-global/bin:$PATH"
npm i -g \
  typescript \
  @vue/language-server \
  @vue/typescript-plugin \
  prettier \
  typescript-language-server
