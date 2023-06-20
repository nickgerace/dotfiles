#!/usr/bin/env bash
set -e

TRUE_USER="$(whoami)"
DOTFILES="$HOME/src/dotfiles"
BASE="$DOTFILES/os/pop-os/scripts/base.txt"
CRATES="$DOTFILES/crates.txt"

function die {
  if [ "$1" = "" ]; then
    die "must provide argument <error-message>"
  fi
  echo "error: $1"
  exit 1
}

function verify-config {
  if [ "$(uname -s)" != "Linux" ]; then
    die "OS is not Linux-based"
  fi
  if [ ! -f /etc/os-release ]; then
    die "cannot determine Linux distro"
  fi
  if [ "$(grep '^ID=' /etc/os-release | sed 's/^ID=//' | tr -d '"')" != "pop" ]; then
    die "Linux distro must be Pop!_OS"
  fi
  if [ -f /proc/sys/kernel/osrelease ] && [ "$(grep "WSL2" /proc/sys/kernel/osrelease)" ]; then
    die "cannot use WSL2"
  fi
  if [ "$(uname -m)" != "x86_64" ]; then
    die "must use x86_64 architecture"
  fi
  if [ $EUID -eq 0 ]; then
    die "must run as non-root"
  fi
  sudo -v
}

function prepare {
  sudo apt update
  sudo apt upgrade -y
  xargs sudo apt install -y < $BASE
}

function final {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
}

function install-nodejs {
  curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt update
  sudo apt install -y nodejs
}

function install-rust {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  source "$HOME/.cargo/env"
  rustup toolchain install stable-x86_64-unknown-linux-gnu
  rustup toolchain install nightly-x86_64-unknown-linux-gnu
  rustup default stable-x86_64-unknown-linux-gnu
  xargs cargo install --locked < $CRATES
}

function install-docker {
  sudo apt update
  sudo apt install -y ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo service docker start
  sudo docker run hello-world
  sudo usermod -aG docker $TRUE_USER
}

verify-config
prepare
install-nodejs
install-rust
install-docker
final
