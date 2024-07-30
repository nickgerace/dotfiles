#!/usr/bin/env bash
set -eu

INSTALL_DOTFILES_REPO="$HOME/src/dotfiles"
INSTALL_OPTION_INSTALL_PACKAGES="false"
INSTALL_PLATFORM="false"

INSTALL_LOG_FORMAT_BOLD=$(tput bold)
INSTALL_LOG_FORMAT_GREEN=$(tput setaf 2)
INSTALL_LOG_FORMAT_RED=$(tput setaf 1)
INSTALL_LOG_FORMAT_RESET=$(tput sgr0)

function log {
  echo "${INSTALL_LOG_FORMAT_BOLD}$1${INSTALL_LOG_FORMAT_RESET}"
}

function log-success {
  echo "${INSTALL_LOG_FORMAT_BOLD}${INSTALL_LOG_FORMAT_GREEN}$1${INSTALL_LOG_FORMAT_RESET}"
}

function log-error {
  echo "${INSTALL_LOG_FORMAT_BOLD}${INSTALL_LOG_FORMAT_RED}Error: $1${INSTALL_LOG_FORMAT_RESET}" >&2
}

log "Welcome to @nickgerace's dotfiles setup and package installation script!"

while true; do
  read -r -n1 -p "Do you want to install packages in addition to setting up dotfiles? [y/n] (default: n): " yn
  case $yn in
    [yY] ) INSTALL_OPTION_INSTALL_PACKAGES="true"; echo ""; break;;
    "" ) break;;
    * ) echo ""; break;;
  esac
done
while true; do
  read -r -n1 -p "Confirm to begin [y/n] (default: y): " yn
  case $yn in
    [yY] ) echo ""; break;;
    "" ) echo ""; break;;
     * ) exit 0;;
  esac
done

log "Checking user..."
if [ $EUID -eq 0 ]; then
  log-error "must run as non-root user"
  exit 1
fi

log "Checking platform..."
if [ "$(uname -s)" = "Linux" ] && [ "$(uname -m)" = "x86_64" ]; then
  if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
    log-error "cannot run in WSL2"
    exit 1
  fi
  . /etc/os-release
  if [[ "$ID" != "nixos" ]]; then
    log-error "only compatible with NixOS x86_64"
    exit 1
  fi
  log "Found compatible platform: NixOS x86_64"
  INSTALL_PLATFORM="nixos"
elif [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ]; then
  log "Found compatible platform: macOS aarch64"
  INSTALL_PLATFORM="darwin"
else
  log-error "only compatible with NixOS x86_64 or macOS aarch64"
  exit 1
fi

function link {
  if [ ! -f "$1" ]; then
    log-error "file does not exist: $1"
    exit 1
  fi

  local DIRNAME
  DIRNAME=$(dirname "$2")

  if [ -d "$DIRNAME" ]; then
    if [ -f "$2" ]; then
      rm "$2"
    fi
  elif [ "$HOME" != "$DIRNAME" ]; then
    mkdir -p "$DIRNAME"
  fi

  ln -s "$1" "$2"
}

log "Setting up dotfiles..."
git config --global pull.rebase true

link "$INSTALL_DOTFILES_REPO/zshrc" "$HOME/.zshrc"
link "$INSTALL_DOTFILES_REPO/starship.toml" "$HOME/.config/starship.toml"
link "$INSTALL_DOTFILES_REPO/helix/config.toml" "$HOME/.config/helix/config.toml"
link "$INSTALL_DOTFILES_REPO/helix/languages.toml" "$HOME/.config/helix/languages.toml"
link "$INSTALL_DOTFILES_REPO/helix/themes/catppuccin_latte.toml" "$HOME/.config/helix/catppuccin_latte.toml"
link "$INSTALL_DOTFILES_REPO/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
link "$INSTALL_DOTFILES_REPO/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

if [ "$INSTALL_PLATFORM" = "darwin" ]; then
  link "$INSTALL_DOTFILES_REPO/ghostty/darwin-config" "$HOME/.config/ghostty/config"
elif [ "$INSTALL_PLATFORM" = "nixos" ]; then
  link "$INSTALL_DOTFILES_REPO/ghostty/linux-config" "$HOME/.config/ghostty/config"
fi

if [ "$INSTALL_OPTION_INSTALL_PACKAGES" != "true" ]; then
  log-success "Success!"
  exit 0
fi

if [ "$INSTALL_PLATFORM" = "darwin" ]; then
  log "Checking for nix installation..."
  if ! command -v nix && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  if ! command -v nix; then
    log "Installing nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  fi

  log "Checking for nix-darwin..."
  if ! command -v darwin-rebuild; then
    pushd "$INSTALL_DOTFILES_REPO"
    log "Installing nix-darwin..."
    nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
    popd
	fi

  log "Running darwin-rebuild switch..."
  darwin-rebuild switch --flake .

  log "Installing npm packages for helix LSPs..."
  npm set prefix ~/.npm-global
  npm i -g \
    @vue/language-server \
    prettier \
    typescript \
    typescript-language-server
elif [ "$INSTALL_PLATFORM" = "nixos" ]; then
  log "Running nixos-rebuild..."
  pushd "$INSTALL_DOTFILES_REPO"
  sudo nixos-rebuild switch --flake .
  popd

  log "Installing npm packages for helix..."
  npm set prefix ~/.npm-global
  npm i -g \
    @vue/language-server \
    prettier \
    typescript \
    typescript-language-server

  log "Running final update and cleanup commands..."
  npm update -g
fi

log-success "Success!"
