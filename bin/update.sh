#!/usr/bin/env bash
set -eu

UPDATE_DOTFILES_REPO="$HOME/src/dotfiles"
UPDATE_OPTION_UPDATE_FLAKE="false"
UPDATE_OPTION_UPGRADE_NIX="false"
UPDATE_OPTION_UPGRADE_OTHER_PACKAGES="true"
UPDATE_PLATFORM="false"

UPDATE_LOG_FORMAT_BOLD=$(tput bold)
UPDATE_LOG_FORMAT_GREEN=$(tput setaf 2)
UPDATE_LOG_FORMAT_RED=$(tput setaf 1)
UPDATE_LOG_FORMAT_RESET=$(tput sgr0)

function log {
  echo "${UPDATE_LOG_FORMAT_BOLD}$1${UPDATE_LOG_FORMAT_RESET}"
}

function log-success {
  echo "${UPDATE_LOG_FORMAT_BOLD}${UPDATE_LOG_FORMAT_GREEN}$1${UPDATE_LOG_FORMAT_RESET}"
}

function log-error {
  echo "${UPDATE_LOG_FORMAT_BOLD}${UPDATE_LOG_FORMAT_RED}Error: $1${UPDATE_LOG_FORMAT_RESET}" >&2
}

log "Welcome to @nickgerace's platform uptdate script!"

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
  UPDATE_PLATFORM="nixos"
elif [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ]; then
  log "Found compatible platform: macOS aarch64"
  UPDATE_PLATFORM="darwin"
else
  log-error "only compatible with NixOS x86_64 or macOS aarch64"
  exit 1
fi

if [ "$UPDATE_PLATFORM" = "darwin" ]; then
  while true; do
    read -r -n1 -p "Do you want to upgrade nix? [y/n] (default: n): " yn
    case $yn in
      [yY] ) UPDATE_OPTION_UPGRADE_NIX="true"; echo ""; break;;
      "" ) break;;
      * ) echo ""; break;;
    esac
  done
fi
while true; do
  read -r -n1 -p "Do you want to run nix flake update? [y/n] (default: n): " yn
  case $yn in
    [yY] ) UPDATE_OPTION_UPDATE_FLAKE="true"; echo ""; break;;
    "" ) break;;
    * ) echo ""; break;;
  esac
done
while true; do
  read -r -n1 -p "Do you want to update other packages not managed by nix? [y/n] (default: y): " yn
  case $yn in
    [nN] ) UPDATE_OPTION_UPGRADE_OTHER_PACKAGES="false"; echo ""; break;;
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

if [ "$UPDATE_PLATFORM" = "nixos" ]; then
  if [ "$UPDATE_OPTION_UPDATE_FLAKE" = "true" ]; then
    log "Updating flake..."
    pushd "$UPDATE_DOTFILES_REPO"
    nix flake update
    popd
  fi

  log "Running nixos-rebuild switch..."
  pushd "$UPDATE_DOTFILES_REPO"
  sudo nixos-rebuild switch --flake .
  popd
  
  if [ "$UPDATE_OPTION_UPGRADE_OTHER_PACKAGES" = "true" ]; then
  	log "Updating npm packages..."
  	npm update -g	
  fi
elif [ "$UPDATE_PLATFORM" = "darwin" ]; then
  if [ "$UPDATE_OPTION_UPGRADE_NIX" = "true" ]; then
    log "Upgrading nix..."
  	sudo -i nix upgrade-nix
  fi

  if [ "$UPDATE_OPTION_UPDATE_FLAKE" = "true" ]; then
    log "Updating flake..."
    pushd "$UPDATE_DOTFILES_REPO"
    nix flake update
  	popd
  fi

  log "Running darwin-rebuild switch..."
  pushd "$UPDATE_DOTFILES_REPO"
	darwin-rebuild switch --flake .
	popd

  if [ "$UPDATE_OPTION_UPGRADE_OTHER_PACKAGES" = "true" ]; then
  	log "Updating npm packages..."
  	npm update -g
  fi
fi

log-success "Success!"
