#!/usr/bin/env bash
set -eu

# Make sure that we aren't relying on a specific environment based on our current working directory
pushd "$(mktemp -d)"

UPDATE_DOTFILES_REPO="$HOME/src/dotfiles"

LOG_FORMAT_BOLD=$(tput bold)
LOG_FORMAT_GREEN=$(tput setaf 2)
LOG_FORMAT_RED=$(tput setaf 1)
LOG_FORMAT_RESET=$(tput sgr0)

function log {
  echo "${LOG_FORMAT_BOLD}$1${LOG_FORMAT_RESET}"
}

function log-success {
  echo "${LOG_FORMAT_BOLD}${LOG_FORMAT_GREEN}$1${LOG_FORMAT_RESET}"
}

function log-error {
  echo "${LOG_FORMAT_BOLD}${LOG_FORMAT_RED}Error: $1${LOG_FORMAT_RESET}" >&2
}

log "Welcome to @nickgerace's platform update script!"

if [ $EUID -eq 0 ]; then
  log-error "must run as non-root user"
  exit 1
fi

log "Checking platform..."
if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  log-error "can only perform updates on Drawin aarch64 (arm64)"
  exit 1
fi

while true; do
  read -r -n1 -p "Confirm to begin [Y/n]: " yn
  case $yn in
  [yY])
    echo ""
    break
    ;;
  "")
    echo ""
    break
    ;;
  *) exit 0 ;;
  esac
done

if command -v brew; then
  log "Updating brew packages..."
  brew update
  brew upgrade
  brew cleanup
fi

if command -v rustup; then
  log "Running rustup update..."
  rustup update
fi

if command -v fnm; then
  log "Updating node installed via fnm..."
  fnm install --lts
fi

if command -v npm && [ -d "$HOME/.npm-global" ]; then
  log "Updating npm packages..."
  pushd "$UPDATE_DOTFILES_REPO"
  npm set prefix ~/.npm-global
  npm up -g
  popd
fi

# Leave the temporary directory
popd

log-success "Success!"
