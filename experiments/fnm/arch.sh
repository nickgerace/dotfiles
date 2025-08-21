#!/usr/bin/env bash
set -euxo pipefail

paru -S --noconfirm fnm
fnm install 18 # used by SI

mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH="$HOME/.npm-global/bin:$PATH"
npm i -g \
  typescript \
  @vue/language-server \
  @vue/typescript-plugin \
  prettier \
  typescript-language-server
