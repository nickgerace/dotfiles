#!/usr/bin/env bash
set -eu

UPDATE_DOTFILES_REPO="$HOME/src/dotfiles"
UPDATE_OPTION_UPDATE_FLAKE="false"
UPDATE_OPTION_UPGRADE_NIX="false"
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
  if command -v darwin-rebuild; then
    UPDATE_PLATFORM="nix-darwin"
  else
    UPDATE_PLATFORM="darwin"
  fi
else
  log-error "cannot perform updates for unknown platform"
fi
log "Detected platform: $UPDATE_PLATFORM"

if [ "$UPDATE_PLATFORM" = "nix-darwin" ]; then
  while true; do
    read -r -n1 -p "Do you want to upgrade nix? [y/N]: " yn
    case $yn in
    [yY])
      UPDATE_OPTION_UPGRADE_NIX="true"
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

if [ "$UPDATE_PLATFORM" = "nixos" ] || [ "$UPDATE_PLATFORM" = "nix-darwin" ]; then
  while true; do
    read -r -n1 -p "Do you want to run nix flake update? [y/N]: " yn
    case $yn in
    [yY])
      UPDATE_OPTION_UPDATE_FLAKE="true"
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

# TODO(nick): refactor to not have "exit 0" statements.
if [ "$UPDATE_PLATFORM" = "nixos" ]; then
  pushd "$UPDATE_DOTFILES_REPO"

  if [ "$UPDATE_OPTION_UPDATE_FLAKE" = "true" ]; then
    log "Updating nix flake and ignoring any errors..."
    nix flake update || true
    log "Updating nix flake again in case of permissions error..."
    nix flake update
    log "Adding flake.lock to staged changes..."
    git add flake.lock
  fi

  log "Running nixos-rebuild switch..."
  sudo nixos-rebuild switch --flake .

  if command -v npm && [ -d "$HOME/.npm-global" ]; then
    log "Updating npm packages..."
    pushd "$UPDATE_DOTFILES_REPO"
    npm set prefix ~/.npm-global
    npm up -g
    popd
  fi

  popd
  log-success "Success!"
  exit 0
fi

if [ "$UPDATE_PLATFORM" = "nix-darwin" ]; then
  if [ "$UPDATE_OPTION_UPGRADE_NIX" = "true" ]; then
    log "Upgrading nix..."
    sudo -i nix upgrade-nix
  fi

  pushd "$UPDATE_DOTFILES_REPO"

  if [ "$UPDATE_OPTION_UPDATE_FLAKE" = "true" ]; then
    log "Updating flake..."
    nix flake update
  fi

  log "Running darwin-rebuild switch..."
  darwin-rebuild switch --flake .

  popd
  log-success "Success!"
  exit 0
fi

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

if command -v nix; then
  log "Upgrading nix..."
  sudo -i nix upgrade-nix

  if command -v home-manager; then
    log "Running home-manager switch..."
    home-manager switch
  fi
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

if command -v npm && [ -d "$HOME/.npm-global" ]; then
  log "Updating npm packages..."
  pushd "$UPDATE_DOTFILES_REPO"
  npm set prefix ~/.npm-global
  npm up -g
  popd
fi

# NOTE(nick): disabled since crates will come from package managers or nix via home-manager.
# function update-crates {
#     if command -v cargo; then
#         if [ ! -f $HOME/.cargo/bin/cargo-install-update ]; then
#             cargo install --locked cargo-update
#         fi
#         cargo install-update -a
#     fi
# }

log-success "Success!"
