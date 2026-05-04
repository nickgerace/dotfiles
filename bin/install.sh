#!/usr/bin/env bash
set -eu

BOOTSTRAP_PLATFORM="false"
REPO="$HOME/src/n"

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

log "Welcome to @nickgerace's dotfiles setup and platform bootstrap script!"

if [ $EUID -eq 0 ]; then
  log-error "must run as non-root user"
  exit 1
fi

if [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ]; then
  while true; do
    read -r -n1 -p "Do you want to install packages in addition to setting up dotfiles? [y/N]: " yn
    case $yn in
    [yY])
      BOOTSTRAP_PLATFORM="true"
      echo ""
      break
      ;;
    "") break ;;
    *)
      echo ""
      break
      ;;
    esac
  done
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

function link {
  if [ ! -f "$1" ]; then
    log-error "file does not exist: $1"
    exit 1
  fi

  local DIRNAME
  DIRNAME=$(dirname "$2")

  if [ -d "$DIRNAME" ]; then
    if [ -f "$2" ] || [ -L "$2" ]; then
      rm "$2"
    fi
  elif [ "$HOME" != "$DIRNAME" ]; then
    mkdir -p "$DIRNAME"
  fi

  log "Linking: $1 --> $2"
  ln -s "$1" "$2"
}

if [ "$BOOTSTRAP_PLATFORM" = "true" ]; then
  log "Checking if cargo is installed via rustup..."
  if ! command -v cargo; then
    log "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

    log "Setting cargo env for this script..."
    . "$HOME/.cargo/env"

    log "Installing rust-analzyer via rustup..."
    rustup component add rust-analyzer
  fi

  log "Checking if homebrew is installed..."
  if ! command -v brew; then
    log-error "could not install packages: homebrew is not installed"
    exit 1
  fi

  log "Setting up brew taps..."
  brew tap philocalyst/tap

  log "Installing brew packages..."
  xargs brew install <"$REPO/pkgs/brew-base.lst"
fi

log "Setting up dotfiles..."

link "$REPO/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "$REPO/gfold/config.toml" "$HOME/.config/gfold.toml"
link "$REPO/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
link "$REPO/helix/config.toml" "$HOME/.config/helix/config.toml"
link "$REPO/helix/languages.toml" "$HOME/.config/helix/languages.toml"
link "$REPO/jj/config.toml" "$HOME/.config/jj/config.toml"

log "Checking if mise is installed..."
if command -v mise; then
  log "Trusting config file for mise and then linking..."
  mise trust "$REPO/mise/config.toml"
  link "$REPO/mise/config.toml" "$HOME/.config/mise/config.toml"
fi

log-success "Success!"
