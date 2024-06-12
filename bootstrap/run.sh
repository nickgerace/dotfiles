#!/usr/bin/env bash
set -eu

# ========================================
# === Reusable Variables and Functions ===
# ========================================

NICK_BOOTSTRAP_DOTFILES_DIRECTORY="$HOME/src/dotfiles"
NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY="$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/bootstrap"

NICK_BOOTSTRAP_LOG_FORMAT_BOLD=$(tput bold)
NICK_BOOTSTRAP_LOG_FORMAT_GREEN=$(tput setaf 2)
NICK_BOOTSTRAP_LOG_FORMAT_RED=$(tput setaf 1)
NICK_BOOTSTRAP_LOG_FORMAT_RESET=$(tput sgr0)

function log {
    echo "${NICK_BOOTSTRAP_LOG_FORMAT_BOLD}☐ $1${NICK_BOOTSTRAP_LOG_FORMAT_RESET}"
}

function success {
    echo "${NICK_BOOTSTRAP_LOG_FORMAT_BOLD}${NICK_BOOTSTRAP_LOG_FORMAT_GREEN}☑ $1${NICK_BOOTSTRAP_LOG_FORMAT_RESET}"
}

function explode {
    echo "${NICK_BOOTSTRAP_LOG_FORMAT_BOLD}${NICK_BOOTSTRAP_LOG_FORMAT_RED}☒ $1${NICK_BOOTSTRAP_LOG_FORMAT_RESET}"
    exit 1
}

# =======================
# === Opening Prompts ===
# =======================

NICK_BOOTSTRAP_INSTALL_PACKAGES="false"
NICK_BOOTSTRAP_SETUP_THELIO="false"

log "welcome to nickgerace's dotfiles bootstrap script!"

while true; do
    read -r -n1 -p "→  are you setting up a System76 Thelio system? [y/n] (default: n) (ignored for Pop!_OS): " yn
    case $yn in
        [yY] ) NICK_BOOTSTRAP_SETUP_THELIO="true"; echo ""; break;;
        "" ) break;;
        * ) echo ""; break;;
    esac
done

log "setting up a System76 Thelio system (ignored for Pop!_OS): $NICK_BOOTSTRAP_SETUP_THELIO"
while true; do
    read -r -n1 -p "→  do you want to install packages in addition to setting up dotfiles? [y/n] (default: n): " yn
    case $yn in
        [yY] ) NICK_BOOTSTRAP_INSTALL_PACKAGES="true"; echo ""; break;;
        "" ) break;;
        * ) echo ""; break;;
    esac
done
log "installing packages in addition to setting up dotfiles: $NICK_BOOTSTRAP_INSTALL_PACKAGES"

while true; do
    read -r -n1 -p "→  run the bootstrap script? [y/n] (default: y): " yn
    case $yn in
        [yY] ) echo -e "\n"; break;;
        "" ) echo ""; break;;
         * ) exit 0;;
    esac
done

success "configuration locked! running..."

# ==============================================
# === Generic Package Installation Functions ===
# ==============================================

function install-rust-darwin {
    install-rust-inner

    rustup toolchain install stable-aarch64-apple-darwin
    rustup default stable-aarch64-apple-darwin

    rustup component add rust-analyzer
}

function install-rust-linux {
    install-rust-inner

    rustup toolchain install stable-x86_64-unknown-linux-gnu
    rustup default stable-x86_64-unknown-linux-gnu

    rustup component add rust-analyzer
}

function install-rust-inner {
    if ! command -v rustup && [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    
    if ! command -v rustup; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
        source "$HOME/.cargo/env"
    fi
}

function install-nix {
    if ! command -v nix; then
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    fi
}

function setup-home-manager {
    if ! command -v home-manager; then
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        nix-shell '<home-manager>' -A install
    fi
    home-manager switch
}

function check-wsl2 {
    if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
        explode "cannot use WSL2 and perform advanced package installation"
    fi
}

# =================================
# === OS (and distro) Functions ===
# =================================

function run-fedora-install-packages {
    local FEDORA_DATA
    local FEDORA_BASE_PACKAGES_FILE
    local FEDORA_CRATES_FILE

    FEDORA_DATA=$NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY/data/fedora
    FEDORA_BASE_PACKAGES_FILE=$FEDORA_DATA/base-packages.txt
    FEDORA_CRATES_FILE=$FEDORA_DATA/crates.txt

    function verify-paths {
        if [ ! -f "$FEDORA_BASE_PACKAGES_FILE" ]; then
            explode "not found $FEDORA_BASE_PACKAGES_FILE"
        fi
        if [ ! -f "$FEDORA_CRATES_FILE" ]; then
            explode "not found $FEDORA_CRATES_FILE"
        fi
    }

    function install-base-packages {
        xargs sudo dnf5 install -y < "$FEDORA_BASE_PACKAGES_FILE"
    }

    # Source: https://rpmfusion.org/Configuration
    function install-rpmfusion {
        # shellcheck disable=SC2046
        sudo dnf5 install -y \
            https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    }

    # Source: https://rpmfusion.org/Howto/Multimedia
    function install-rpmfusion-packages {
        sudo dnf5 swap ffmpeg-free ffmpeg --allowerasing -y
        sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
        sudo dnf groupupdate -y sound-and-video
    }

    # Source: https://docs.docker.com/engine/install/fedora/
    function install-docker {
        if ! command -v docker; then
            sudo dnf5 -y install dnf-plugins-core
            sudo dnf5 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf5 install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable --now docker
        fi

        # Enable docker to be used by non-root users.
        sudo usermod -aG docker "$USER"
        sudo docker run hello-world
    }

    function install-crates {
        xargs cargo install --locked < "$FEDORA_CRATES_FILE"
    }

    log "verifying paths"
    verify-paths
    log "installing base packages"
    install-base-packages
    log "installing rpmfusion"
    install-rpmfusion
    log "installing rpmfusion packages"
    install-rpmfusion-packages
    log "installing docker"
    install-docker
    log "installing rust"
    install-rust-linux
    log "installing crates"
    install-crates
}

function run-fedora-setup-thelio {
    # Source: https://support.system76.com/articles/system76-driver/
    function install-system76-driver {
        sudo dnf5 copr enable szydell/system76 -y
        sudo dnf5 install system76-driver -y
    }

    # Source: https://support.system76.com/articles/system76-software/
    function install-system76-software {
        sudo dnf5 install system76* firmware-manager -y
    }

    function setup-firmware-daemon {
        sudo systemctl enable --now system76-firmware-daemon
        sudo gpasswd -a "$USER" adm
    }

    function enable-and-mask-system76-power-services {
        sudo systemctl enable --now com.system76.PowerDaemon.service system76-power-wake
        sudo systemctl mask power-profiles-daemon.service
    }

    function install-system76-acpi-dkms {
        sudo dnf5 install system76-acpi-dkms -y
        sudo systemctl enable --now dkms
    }

    function install-system76-thelio-io-dkms {
        sudo dnf5 install system76-io-dkms -y
    }

    log "installing system76-driver"
    install-system76-driver
    log "installing system76 software"
    install-system76-software
    log "setting up the firmware daemon"
    setup-firmware-daemon
    log "enabling and masking system76 power services"
    enable-and-mask-system76-power-services
    log "installing the ACPI DKMS package for open firmware systems"
    install-system76-acpi-dkms
    log "installing the system76 Thelio IO DKMS package"
    install-system76-thelio-io-dkms
}

function run-fedora {
    local FEDORA_DATA
    FEDORA_DATA="$NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY/data/fedora"

    function verify-paths {
        if [ ! -d "$FEDORA_DATA" ]; then
            explode "could not find $FEDORA_DATA"
        fi
    }

    function setup-permissions {
        sudo -v
    }

    function install-dnf5 {
        sudo dnf5 install dnf5 --refresh -y
    }

    # Source: https://dnf.readthedocs.io/en/latest/conf_ref.html
    function configure-dnf {
        sudo sed -i '/^max_parallel_downloads=*/d' /etc/dnf/dnf.conf
        sudo sed -i '/^fastestmirror=*/d' /etc/dnf/dnf.conf
        sudo sed -i '/^deltarpm=*/d' /etc/dnf/dnf.conf
        echo "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf
        echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
        echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf
    }

    # Upgrade all packages and install xargs from findutils.
    # We need to do this before executing other scripts.
    function upgrade-all-packages-and-install-essentials {
        sudo dnf5 upgrade -y
        sudo dnf5 install -y findutils zsh make git curl wget bash
    }

    function cleanup {
        sudo dnf5 upgrade -y --refresh
        sudo dnf5 autoremove -y
    }

    log "verifying paths"
    verify-paths
    log "setting up permissions and configuring dnf"
    setup-permissions
    log "configuring dnf"
    configure-dnf
    log "installing dnf5"
    install-dnf5
    log "upgrading all packages and installing essentials"
    upgrade-all-packages-and-install-essentials
    log "installing packages"
    run-fedora-install-packages
    if [ "true" = "$NICK_BOOTSTRAP_SETUP_THELIO" ]; then
        log "setting up Fedora for System76 Thelio"
        run-fedora-setup-thelio
    fi
    log "cleaning up"
    cleanup
}

function run-pop {
    local POP_DATA
    local POP_BASE_PACKAGES_FILE

    POP_DATA="$NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY/data/pop"
    POP_BASE_PACKAGES_FILE="$POP_DATA/base-packages.txt"

    function verify-paths {
        if [ ! -f "$POP_BASE_PACKAGES_FILE" ]; then
            explode "could not find $POP_BASE_PACKAGES_FILE"
        fi
    }

    function setup-permissions {
        sudo -v
    }

    function install-packages {
        sudo apt update
        sudo apt upgrade -y
        xargs sudo apt install -y < "$POP_BASE_PACKAGES_FILE"
    }

    # Source: https://docs.docker.com/engine/install/ubuntu/
    function install-docker {
        if ! command -v docker; then
            sudo apt update
            sudo apt install -y ca-certificates curl gnupg
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            sudo chmod a+r /etc/apt/keyrings/docker.gpg

            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update

            sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        fi

        # Enable docker to be used by non-root users.
        sudo usermod -aG docker "$USER"
        sudo docker run hello-world
    }

    function install-wezterm {
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt update
        sudo apt install -y wezterm
    }

    function cleanup {
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
        sudo apt clean -y
    }

    log "verifying paths"
    verify-paths
    log "setting up permissions and installing packages"
    setup-permissions
    install-packages
    log "installing nix"
    install-nix
    log "setting up home-manager"
    setup-home-manager
    log "installing rust"
    install-rust-linux
    log "installing docker"
    install-docker
    log "installing wezterm"
    install-wezterm
    log "cleaning up"
    cleanup
}

function run-darwin {
    local DARWIN_DATA
    local DARWIN_BASE_PACKAGES_FILE

    # TODO(nick): decide what to do with "extra-packages.txt"
    DARWIN_DATA=$NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY/data/darwin
    DARWIN_BASE_PACKAGES_FILE=$DARWIN_DATA/base-packages.txt

    function verify-paths {
        if [ ! -f "$DARWIN_BASE_PACKAGES_FILE" ]; then
            explode "not found $DARWIN_BASE_PACKAGES_FILE"
        fi
    }

    function install-brew-packages {
        if ! command -v brew; then
            # Source: https://brew.sh/
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew update
        brew upgrade
        brew cleanup
        xargs brew install < "$DARWIN_BASE_PACKAGES_FILE"
    }

    function install-brew-casks {
        brew install --cask wezterm font-iosevka-nerd-font
    }

    # FIXME(nick): replace with homebrew and home-manager, if possible.
    # function install-crates {
    #     xargs cargo install < "$DARWIN_CRATES_FILE"
    # }

    log "verifying paths"
    verify-paths
    log "installing brew packages"
    install-brew-packages
    log "installing brew casks"
    install-brew-casks
    log "installing nix"
    install-nix
    log "installing rust"
    install-rust-darwin
}

# =======================
# === Main Entrypoint ===
# =======================

function main {
    function link {
        if [ ! -f "$1" ]; then
            explode "file does not exist: $1"
        fi

        local DIRNAME
        DIRNAME=$(dirname "$2")

        if [ -d "$DIRNAME" ]; then
            if [ -f "$2" ]; then
                rm "$2"
            fi
        elif [ "$HOME" != "$DIRNAME" ]; then
            mkdir -p "$DIRNAME"
        fi

        ln -s "$1" "$2"
    }

    function setup-dotfiles {
        git config --global pull.rebase true

        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/zshrc" "$HOME/.zshrc"
        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/wezterm.lua" "$HOME/.wezterm.lua"
        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/starship.toml" "$HOME/.config/starship.toml"
        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/cargo-config-global.toml" "$HOME/.cargo/config.toml"
        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/helix/config.toml" "$HOME/.config/helix/config.toml"
        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/helix/languages.toml" "$HOME/.config/helix/languages.toml"
        link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"

        if [ "darwin" = "$1" ]; then
            link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/gfold/darwin.toml" "$HOME/.config/gfold.toml"
        else
            if [ "pop" = "$1" ]; then
                link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/home-manager/pop/home.nix" "$HOME/.config/home-manager/home.nix"
            fi
            link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/gfold/linux.toml" "$HOME/.config/gfold.toml"
        fi
    }

    if [ $EUID -eq 0 ]; then
        explode "must run as non-root"
    fi

    # Ensure all directories exist.
    if [ ! -d "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY" ]; then explode "not found: $NICK_BOOTSTRAP_DOTFILES_DIRECTORY"; fi
    if [ ! -d "$NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY" ]; then explode "not found: $NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY"; fi

    # Run for the detected OS (and distro, if applicable).
    if [ "$(uname -s)" = "Darwin" ]; then
        if [ "$(uname -m)" != "arm64" ]; then
            explode "must use macOS on aarch64/arm64 architecture"
        fi

        setup-dotfiles "darwin"
        if [ "true" = "$NICK_BOOTSTRAP_INSTALL_PACKAGES" ]; then
            run-darwin
        fi
    elif [ "$(uname -s)" = "Linux" ]; then
        if [ "$(uname -m)" != "x86_64" ]; then
            explode "must use Linux on x86_64/amd64 architecture"
        fi
        if [ ! -f /etc/os-release ]; then
            explode "could not determine distro: /etc/os-release not found"
        fi

        local LINUX_DISTRO
        LINUX_DISTRO="$(grep '^ID=' /etc/os-release | sed 's/^ID=//' | tr -d '"')"
        if [ "$LINUX_DISTRO" = "fedora" ]; then
            setup-dotfiles "$LINUX_DISTRO"
            if [ "true" = "$NICK_BOOTSTRAP_INSTALL_PACKAGES" ]; then
                check-wsl2
                run-fedora
            fi
        elif [ "$LINUX_DISTRO" = "pop" ]; then
            setup-dotfiles "$LINUX_DISTRO"
            if [ "true" = "$NICK_BOOTSTRAP_INSTALL_PACKAGES" ]; then
                check-wsl2
                run-pop
            fi
        else
            explode "distro must be either Fedora or Pop!_OS"
        fi
    else
        explode "must be macOS aarch64, Fedora x86_64, or Pop!_OS x86_64"
    fi

    success "success!"
}

main
