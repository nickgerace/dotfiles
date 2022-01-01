#!/usr/bin/env bash
set -ex

#######################################
BOOTSTRAP_FULL="false"
BOOTSTRAP_THELIO="false"
BOOTSTRAP_DOCKER_MODE="true"
#######################################

function die {
    if [ "$1" = "" ]; then
        die "must provide argument <error-message>"
    fi
    echo "error: $1"
    exit 1
}

# Verify that we are using Fedora.
if [ "$(uname -s)" != "Linux" ]; then
    die "OS is not Linux-based"
fi
if [ ! -f /etc/os-release ]; then
    die "cannot determine Linux distro"
fi
if [ "$(grep '^ID=' /etc/os-release | sed 's/^ID=//' | tr -d '"')" != "fedora" ]; then
    die "Linux distro must be fedora"
fi

# Set base variables used throughout the bootstrapper.
TRUEUSER="$(whoami)"
SCRIPTPATH="$(dirname $(realpath $0))"
REPOPATH="$(dirname $(dirname $SCRIPTPATH))"
ARCH="$(uname -m)"

# Verify that we are using a valid configuration.
if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "aarch64" ]; then
    die "bootstrapper has only been validated on x86_64 (amd64) and aarch64 (arm64)"
fi
if [ "$BOOTSTRAP_DOCKER_MODE" != "true" ]; then
    if [ $EUID -eq 0 ]; then
        die "must run as non-root"
    fi
    sudo -v
fi
if [ "$BOOTSTRAP_FULL" = "true" ] && [ "$ARCH" != "x86_64" ]; then
    die "must install extras on x86_64 systems"
fi
if [ "$BOOTSTRAP_THELIO" = "true" ] && [ "$ARCH" != "x86_64" ]; then
    die "must install Thelio packages on an x86_64 system"
fi
if [ "$BOOTSTRAP_THELIO" = "true" ] && [ "$BOOTSTRAP_DOCKER_MODE" "true" ]; then
    die "cannot both be enabled: BOOTSTRAP_THELIO and BOOTSTRAP_DOCKER_MODE"
fi
if [ "$BOOTSTRAP_FULL" = "true" ] && [ "$BOOTSTRAP_DOCKER_MODE" "true" ]; then
    die "cannot both be enabled: BOOTSTRAP_FULL and BOOTSTRAP_DOCKER_MODE"
fi

# Configure dnf for speed.
sudo sed -i '/^max_parallel_downloads=*/d' /etc/dnf/dnf.conf
sudo sed -i '/^fastestmirror=*/d' /etc/dnf/dnf.conf
sudo sed -i '/^deltarpm=*/d' /etc/dnf/dnf.conf
echo "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf

# Upgrade existing packages and refresh before getting started.
sudo dnf upgrade --refresh -y

# Install rpmfusion and then xargs from findutils. Install multimedia packages if extras is enabled.
# Source: https://rpmfusion.org/Configuration
sudo dnf install -y findutils
xargs sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    < $SCRIPTPATH/packages.txt
if [ "$BOOTSTRAP_FULL" = "true" ]; then
    sudo dnf groupinstall -y multimedia core sound-and-video
fi

# Install rustup, our toolchains, and crates that we use.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
rustup toolchain install stable-$ARCH-unknown-linux-gnu
rustup toolchain install nightly-$ARCH-unknown-linux-gnu
rustup default stable-$ARCH-unknown-linux-gnu
xargs cargo install --locked < $REPOPATH/crates.txt

# Install docker if not within a docker container.
# Source: https://docs.docker.com/engine/install/fedora/
if [ "$BOOTSTRAP_DOCKER_MODE" != "true" ]; then
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $TRUEUSER
    sudo docker run hello-world
fi

# Install volta on x86_64 systems.
# Source: https://docs.volta.sh/advanced/installers#skipping-volta-setup
if [ "$ARCH" = "x86_64" ]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
fi

# Install terraform on x86_64 systems.
# Source: https://learn.hashicorp.com/tutorials/terraform/install-cli
if [ "$ARCH" = "x86_64" ]; then
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf install --refresh -y terraform
fi

# Install kubectl and helm.
# Source: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
if [ ! -d /etc/yum.repos.d ]; then
    sudo mkdir /etc/yum.repos.d
fi
if [ -f /etc/yum.repos.d/kubernetes.repo ]; then
    sudo rm -f /etc/yum.repos.d/kubernetes.repo
fi
sudo cp $SCRIPTPATH/kubernetes-$ARCH.repo /etc/yum.repos.d/kubernetes.repo
sudo dnf install -y kubectl helm

# Install mold from source.
# Source: https://github.com/rui314/mold/blob/main/README.md
git clone https://github.com/rui314/mold.git /tmp/mold
( cd /tmp/mold; git checkout v1.0.1; make -j$(nproc); sudo make install )
rm -rf /tmp/mold

# Install extras, which include GUI applications.
if [ "$BOOTSTRAP_FULL" = "true" ]; then
    # Install vs code.
    # Source: https://code.visualstudio.com/docs/setup/linux
    if [ ! -d /etc/yum.repos.d ]; then
        sudo mkdir /etc/yum.repos.d
    fi
    if [ -f /etc/yum.repos.d/vscode.repo ]; then
        sudo rm -f /etc/yum.repos.d/vscode.repo
    fi
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 
    sudo dnf install --refresh -y code

    # Install google chrome.
    sudo dnf install -y google-chrome-stable

    # Install zoom.
    # Source: https://flatpak.org/setup/Fedora/
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install flathub -y us.zoom.Zoom

    # Install tailscale.
    # Source: https://tailscale.com/kb/1050/install-fedora/
    sudo dnf config-manager -y --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    sudo dnf install -y tailscale
    sudo systemctl enable --now tailscaled

    # Install fonts.
    # Source: https://github.com/JetBrains/JetBrainsMono/blob/master/README.md
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
    sudo dnf install -y fira-code-fonts
fi

if [ "$BOOTSTRAP_THELIO" = "true" ]; then
    # Install system76-driver.
    # Source: https://support.system76.com/articles/system76-driver/
    sudo dnf copr enable -y szydell/system76
    sudo dnf install -y system76-driver

    # Install system76-software.
    # Source: https://support.system76.com/articles/system76-software/
    sudo dnf install -y firmware-manager
    sudo systemctl enable --now system76-firmware-daemon
    sudo gpasswd -a $TRUEUSER adm

    sudo dnf install -y system76-power
    sudo systemctl enable --now system76-power system76-power-wake

    sudo dnf install -y system76-acpi-dkms
    sudo systemctl enable dkms

    sudo dnf install -y system76-io-dkms
fi

# Perform another upgrade, autoremove packages, and print installed packages.
sudo dnf upgrade -y --refresh
sudo dnf autoremove -y
sudo dnf repoquery --userinstalled --queryformat "%{NAME}"
