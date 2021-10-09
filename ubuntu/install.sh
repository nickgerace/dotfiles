#!/usr/bin/bash
if [ "$USER" = "root" ]; then
    echo "must not run as root (nor with sudo)"
    exit 1
fi

sudo apt update
sudo apt install -y lsb-release

REAL_USER=$USER
RELEASE=$(lsb_release -cs)
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH=amd64
fi
IS_WSL2="false"
if [ -f /proc/sys/kernel/osrelease ] && [ $(grep "WSL2" /proc/sys/kernel/osrelease) ]; then
    IS_WSL2="true"
fi

SLEEP_SECONDS=10
echo "=========================="
echo "user: $REAL_USER"
echo "release: $RELEASE ($(lsb_release -rs))"
echo "architecture: $ARCH"
echo "WSL2: $IS_WSL2"
echo "continuing in $SLEEP_SECONDS seconds..."
echo "=========================="
sleep $SLEEP_SECONDS

function pre-install {
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y \
        build-essential \
        cloc \
        curl \
        fzf \
        git \
        htop \
        jq \
        libssl-dev \
        make \
        neovim \
        telnet \
        tmux \
        tree \
        vim \
        wget \
        zsh
    if [ "$IS_WSL2" != "true" ]; then
        sudo apt install -y \
            virtualbox \
            linux-headers-oem \
            virtualbox-dkms \
            ubuntu-restricted-extras
    fi
}

function install-go {
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt update
    sudo apt install -y golang-go
}

function install-go-extras {
    go install github.com/rancher/k3d/v4@latest
    go install github.com/ahmetb/kubectx@latest
}

function install-docker {
    sudo apt remove -y docker docker-engine docker.io containerd runc
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $RELEASE stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo usermod -aG docker $REAL_USER
    if [ "$IS_WSL2" != "true" ]; then
        sudo systemctl enable docker
    fi
}

function install-trivy {
    sudo apt install -y wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb $RELEASE main | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt update
    sudo apt install -y trivy
}

function install-kubectl {
    sudo apt install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install -y kubectl
}

function install-helm {
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    sudo apt install -y apt-transport-https
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt update
    sudo apt install -y helm
}

function install-hashi {
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=$ARCH] https://apt.releases.hashicorp.com $RELEASE main"
    sudo apt update
    sudo apt install -y terraform
    if [ "$IS_WSL2" != "true" ]; then
        sudo apt install -y vagrant
    fi
}

function install-rust {
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
    if [ "$ARCH" = "amd64" ]; then
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
    fi
}

function prepare-chrome {
    if [ "$IS_WSL2" != "true" ]; then
        # Needed for emoji support.
        sudo apt reinstall -y fonts-noto fonts-noto-color-emoji
    fi
}

function post-install {
    sudo apt autoremove -y
    if [ "$IS_WSL2" != "true" ]; then
        echo "(optional) configure GNOME terminal: https://github.com/Mayccoll/Gogh"
    fi
}

pre-install
install-go
install-go-extras
install-docker
install-trivy
install-kubectl
install-helm
install-hashi
install-rust
prepare-chrome
post-install
