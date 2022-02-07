#!/usr/bin/env bash
set -e

TRUE_USER="$(whoami)"
DOTFILES="$HOME/src/dotfiles"

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
  # shellcheck disable=SC2143
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
  xargs sudo apt install -y <"$DOTFILES"/scripts/pop-os/base.txt
}

function final {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
}

function install-volta {
  curl https://get.volta.sh | bash -s -- --skip-setup
  volta install node
}

function install-rust {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  rustup toolchain install stable-x86_64-unknown-linux-gnu
  rustup toolchain install nightly-x86_64-unknown-linux-gnu
  rustup default stable-x86_64-unknown-linux-gnu
  xargs cargo install --locked <"$DOTFILES"/crates.txt
}

function install-docker {
  sudo apt update
  sudo apt-get install -y ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  sudo docker run hello-world
  sudo usermod -aG docker "$TRUE_USER"
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
}

verify-config
prepare
install-volta
install-rust
install-docker
final
