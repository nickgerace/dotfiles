#!/usr/bin/env bash
set -e

TRUEUSER="unknown"

function error-and-exit {
    if [ ! $1 ]; then
        error-and-exit "must provide argument <error-message>"
    fi
    echo "error: $1"
    exit 1
}

function verify-fedora {
    if [ "$(uname -s)" != "Linux" ]; then
        error-and-exit "OS is not Linux-based"
    fi
    if [ ! -f /etc/os-release ]; then
        error-and-exit "cannot determine Linux distro"
    fi
    if [ "$(grep '^ID=' /etc/os-release | sed 's/^ID=//' | tr -d '"')" != "fedora" ]; then
        error-and-exit "Linux distro must be fedora"
    fi
}

function determine-user {
    if [ $EUID -eq 0 ]; then
        error-and-exit "must run as non-root"
    fi
    TRUEUSER=$(whoami)
    sudo -v
}

verify-fedora
determine-user
echo $TRUEUSER

function install-rustup {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
}

function stuff {
    sudo sed -i '/^max_parallel_downloads*/d' /etc/dnf/dnf.conf
    echo "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf

		sudo dnf install -y dnf-plugins-core
  	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  	sudo dnf install -y docker-ce docker-ce-cli containerd.io

  	sudo systemctl start docker
  	sudo systemctl enable docker
  	sudo usermod -aG docker $TRUEUSER
  	sudo docker run hello-world

    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf install -y terraform

    sudo dnf install -y \
        aspell \
        aspell-en \
        autoconf \
        automake \
        awscli \
        bison \
        cloc \
        cowsay \
        dhcpcd \
        efibootmgr \
        fd-find \
        fzf \
        gcc-c++ \
        git \
        golang \
        grub2-efi-x64 \
        grub2-tools \
        htop \
        kernel \
        kernel-core \
        kernel-modules \
        kubectl \
        llvm \
        lolcat \
        lvm2 \
        make \
        musl-gcc \
        musl-libc \
        neofetch \
        neovim \
        nodejs \
        openssl-devel \
        pandoc \
        patch \
        podman \
        ruby \
        ruby-devel \
        shim-x64 \
        speedtest-cli \
        tmux \
        vgrep \
        vim-enhanced \
        xfsprogs \
        zlib-devel \
        zsh

    sudo dnf repoquery --userinstalled --queryformat "%{NAME}"
}
