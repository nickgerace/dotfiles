#!/usr/bin/env bash
set -e

TRUEUSER="$(whoami)"
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
    if [ "$(grep '^ID=' /etc/os-release | sed 's/^ID=//' | tr -d '"')" != "fedora" ]; then
        die "Linux distro must be fedora"
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
    if [ ! -d $DOTFILES ]; then
        die "could not find $DOTFILES"
    fi
    sudo -v
}

# Configure dnf for speed.
function configure-dnf {
    sudo sed -i '/^max_parallel_downloads=*/d' /etc/dnf/dnf.conf
    sudo sed -i '/^fastestmirror=*/d' /etc/dnf/dnf.conf
    sudo sed -i '/^deltarpm=*/d' /etc/dnf/dnf.conf
    echo "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf
    echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
    echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf
}

# Install rpmfusion and then xargs from findutils. Install base pacakges and multimedia packages afterwards.
# Source: https://rpmfusion.org/Configuration
function prepare {
    sudo dnf upgrade --refresh -y
    sudo dnf install -y findutils
    xargs sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
        < $DOTFILES/os/fedora/scripts/base.txt
    sudo dnf groupinstall -y multimedia core sound-and-video
}

function install-rust {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    rustup toolchain install stable-x86_64-unknown-linux-gnu
    rustup toolchain install nightly-x86_64-unknown-linux-gnu
    rustup default stable-x86_64-unknown-linux-gnu
    xargs cargo install --locked < $DOTFILES/crates.txt
}

# Source: https://docs.docker.com/engine/install/fedora/
function install-docker {
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $TRUEUSER
    sudo docker run hello-world
}

# Source: https://docs.volta.sh/advanced/installers#skipping-volta-setup
function install-volta {
    curl https://get.volta.sh | bash -s -- --skip-setup
    volta install node
}

function final {
    sudo dnf upgrade -y --refresh
    sudo dnf autoremove -y
    sudo dnf repoquery --userinstalled --queryformat "%{NAME}"
}

verify-config
configure-dnf
prepare
install-rust
install-docker
install-volta
final
