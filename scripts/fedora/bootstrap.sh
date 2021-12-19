#!/usr/bin/env bash
set -e

# Configurable
BOOTSTRAP_THELIO="true"

# Not configurable
TRUEUSER="unknown"
SCRIPTPATH=$(dirname $(realpath $0))

function error-and-exit {
    if [ "$1" = "" ]; then
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
    if [ "$(uname -m)" != "x86_64" ]; then
        error-and-exit "bootstrapper has only been validated on x86_64"
    fi
}

function determine-user {
    if [ $EUID -eq 0 ]; then
        error-and-exit "must run as non-root"
    fi
    TRUEUSER=$(whoami)
    sudo -v
}

# Source: https://code.visualstudio.com/docs/setup/linux
function install-vs-code {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 
    sudo dnf install --refresh -y code
}

function install-rust {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    rustup toolchain install stable-x86_64-unknown-linux-gnu
    rustup toolchain install nightly-x86_64-unknown-linux-gnu
    rustup default stable-x86_64-unknown-linux-gnu
    cargo install --locked $(jq -r ".[]" $SCRIPTPATH/crates.json)
}

# Source: https://docs.docker.com/engine/install/fedora/
function install-docker {
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $TRUEUSER
    sudo docker run hello-world
}

# Source: https://docs.volta.sh/advanced/installers#skipping-volta-setup
function install-volta {
    curl https://get.volta.sh | bash -s -- --skip-setup
}

# Source: https://learn.hashicorp.com/tutorials/terraform/install-cli
function install-hashicorp-tools {
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf install -y terraform vagrant
}

# Source: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
function install-kubernetes-tools {
    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
    sudo dnf install -y kubectl helm
}

# Source: https://github.com/JetBrains/JetBrainsMono/blob/master/README.md
function install-jetbrains-mono-font {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
}

# Source: https://support.system76.com/articles/system76-driver/
function thelio-driver {
    sudo dnf copr enable -y szydell/system76
    sudo dnf install -y system76-driver
}

# Source: https://support.system76.com/articles/system76-software/
function thelio-firmware {
    sudo dnf install -y firmware-manager
    sudo systemctl enable --now system76-firmware-daemon
    sudo gpasswd -a $TRUEUSER adm

    sudo dnf install -y system76-power
    sudo systemctl enable --now system76-power system76-power-wake

    sudo dnf install -y system76-acpi-dkms
    sudo systemctl enable dkms

    sudo dnf install -y system76-io-dkms
}

# Source: https://flatpak.org/setup/Fedora/
function install-flatpaks {
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install flathub -y us.zoom.Zoom
}

# Source: https://tailscale.com/kb/1050/install-fedora/
function install-tailscale {
    sudo dnf config-manager -y --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    sudo dnf install -y tailscale
    sudo systemctl enable --now tailscaled
}

# Source: https://rpmfusion.org/Configuration
function prepare {
    sudo sed -i '/^max_parallel_downloads=*/d' /etc/dnf/dnf.conf
    sudo sed -i '/^fastestmirror=*/d' /etc/dnf/dnf.conf
    sudo sed -i '/^deltarpm=*/d' /etc/dnf/dnf.conf
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
    echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
    echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf

    sudo dnf upgrade --refresh -y
    sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install --refresh -y \
        @development-tools \
        aspell \
        aspell-en \
        autoconf \
        automake \
        bash \
        bison \
        cloc \
        curl \
        fira-code-fonts \
        fzf \
        gcc-c++ \
        git \
        google-chrome-stable \
        golang \
        htop \
        hugo \
        jq \
        llvm \
        lvm2 \
        make \
        musl-gcc \
        musl-libc \
        neofetch \
        neovim \
        openssl \
        openssl-devel \
        pandoc \
        patch \
        ruby \
        ruby-devel \
        sed \
        speedtest-cli \
        tmux \
        tree \
        util-linux-user \
        vim \
        wget \
        yamllint \
        zlib-devel \
        zsh

    sudo dnf groupinstall -y multimedia core sound-and-video
    sudo dnf groupupdate -y multimedia core sound-and-video
}

function post-install {
    sudo dnf upgrade -y --refresh
    sudo dnf autoremove -y
    echo "Installed the following packages:"
    echo ""
    sudo dnf repoquery --userinstalled --queryformat "%{NAME}"
}

echo "Starting Fedora 🎩 bootstrapper..."
echo ""
verify-fedora
determine-user
prepare

install-vs-code
install-rust
install-docker
install-volta
install-hashicorp-tools
install-kubernetes-tools
install-tailscale

if [ "$BOOTSTRAP_THELIO" = "true" ]; then
    thelio-driver
    thelio-firmware
fi

post-install
echo ""
echo "Fedora 🎩 is ready to go!"
