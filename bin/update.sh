#!/usr/bin/env bash
set -eu

# Make sure that we aren't relying on a specific environment based on our current working directory
pushd $(mktemp -d)

UPDATE_DOTFILES_REPO="$HOME/src/dotfiles"
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

log "Welcome to @nickgerace's platform update script!"
log "Performing initial checks..."

log "Checking user..."
if [ $EUID -eq 0 ]; then
  log-error "must run as non-root user"
  exit 1
fi

if [ "$(uname -s)" = "Linux" ]; then
  . /etc/os-release
  UPDATE_PLATFORM="$ID"
elif [ "$(uname -s)" = "Darwin" ]; then
  UPDATE_PLATFORM="darwin"
else
  log-error "cannot perform updates for unknown platform"
fi
log "Detected platform: $UPDATE_PLATFORM"

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

log "Updating platform packages..."
if [ "$UPDATE_PLATFORM" = "ubuntu" ] || [ "$UPDATE_PLATFORM" = "pop" ]; then
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
elif [ "$UPDATE_PLATFORM" = "arch" ]; then
  sudo pacman -Syu
  if command -v rustup; then
    log "Running rustup update..."
    rustup update
  fi
  if command -v paru; then
    log "Upgrading AUR packages..."
    paru -Sua
  fi

  # TODO(nick): refactor every system to have its own update logic.
  log-success "Success!"
  exit 0
elif [ "$UPDATE_PLATFORM" = "fedora" ]; then
  if command -v dnf5; then
    sudo dnf5 upgrade -y --refresh
    sudo dnf autoremove -y
  else
    sudo dnf upgrade -y --refresh
    sudo dnf autoremove -y
  fi
elif [ "$UPDATE_PLATFORM" = "opensuse-tumbleweed" ]; then
  sudo zypper update -y
elif [ "$UPDATE_PLATFORM" = "darwin" ] && command -v brew; then
  brew update
  brew upgrade
  brew cleanup
fi

if command -v rustup; then
  log "Running rustup update..."
  rustup update
fi

if command -v snap; then
  log "Updating snaps..."
  sudo snap refresh
fi

if command -v flatpak; then
  log "Updating flatpaks..."
  flatpak update -y
  flatpak uninstall --unused
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
