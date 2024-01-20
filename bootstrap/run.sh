#!/usr/bin/env bash
set -eu

# =======================
# === Opening Prompts ===
# =======================

NICK_BOOTSTRAP_GLOBAL_GIT_USER_NAME="Nick Gerace"
NICK_BOOTSTRAP_INSTALL_PACKAGES="false"
NICK_BOOTSTRAP_SETUP_THELIO="false"

echo -e "Welcome to nickgerace's dotfiles bootstrap script!\n"
while true; do
    read -r -n1 -p "1) Are you setting up a System76 Thelio system? [y/n] (default: n): " yn
    case $yn in
        [yY] ) NICK_BOOTSTRAP_SETUP_THELIO="true"; echo ""; break;;
        "" ) break;;
        * ) echo ""; break;;
    esac
done
while true; do
    read -r -n1 -p "2) Do you want to install packages in addition to setting up dotfiles? [y/n] (default: n): " yn
    case $yn in
        [yY] ) NICK_BOOTSTRAP_INSTALL_PACKAGES="true"; echo ""; break;;
        "" ) break;;
        * ) echo ""; break;;
    esac
done
while true; do
    read -r -p "3) What is your git \"user.name\"? (default: \"$NICK_BOOTSTRAP_GLOBAL_GIT_USER_NAME\"): " response
    case $response in
        "" ) break;;
        *) echo ""; NICK_BOOTSTRAP_GLOBAL_GIT_USER_NAME="$response"; break;;
    esac
done
while true; do
    echo -e "\nReady to go! Configuration..."
    echo "  - Set up a System76 Thelio system (ignored for Pop!_OS): $NICK_BOOTSTRAP_SETUP_THELIO"
    echo "  - Install packages in addition to setting up dotfiles: $NICK_BOOTSTRAP_INSTALL_PACKAGES"
    echo "  - Global git config \"user.name\": \"$NICK_BOOTSTRAP_GLOBAL_GIT_USER_NAME\""
    echo ""
    read -r -n1 -p "Run the bootstrap script? [y/n] (default: y): " yn
    case $yn in
        [yY] ) echo -e "\n"; break;;
        "" ) echo ""; break;;
         * ) exit 0;;
    esac
done

# ========================================
# === Reusable Variables and Functions ===
# ========================================

NICK_BOOTSTRAP_DOTFILES_DIRECTORY="$HOME/src/dotfiles"
NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY="$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/bootstrap"

NICK_BOOTSTRAP_LOG_FORMAT_BOLD=$(tput bold)
NICK_BOOTSTRAP_LOG_FORMAT_RED=$(tput setaf 1)
NICK_BOOTSTRAP_LOG_FORMAT_RESET=$(tput sgr0)

function log-inner {
    echo "${NICK_BOOTSTRAP_LOG_FORMAT_BOLD}$1 $2${NICK_BOOTSTRAP_LOG_FORMAT_RESET}"
}

function explode-inner {
    echo "${NICK_BOOTSTRAP_LOG_FORMAT_BOLD}${NICK_BOOTSTRAP_LOG_FORMAT_RED}$1 error: $2${NICK_BOOTSTRAP_LOG_FORMAT_RESET}"
    exit 1
}

function link {
    if [ -d "$2" ]; then
        if [ -f "$2"/"$3" ]; then
            rm "$2"/"$3"
        fi
    elif [ "$HOME" != "$2" ]; then
        mkdir -p "$2"
    fi

    ln -s "$1" "$2"/"$3"
}

# ======================
# === Dotfiles Setup ===
# ======================

function setup-dotfiles-darwin {
    git config --global user.name "$NICK_BOOTSTRAP_GLOBAL_GIT_USER_NAME"
    git config --global pull.rebase true

    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/zshrc" "$HOME" ".zshrc"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/tmux.conf" "$HOME" ".tmux.conf"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/init.lua" "$HOME/.config/nvim" "init.lua"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/starship.toml" "$HOME/.config" "starship.toml"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/alacritty/darwin.yml" "$HOME/.config/alacritty" "alacritty.yml"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/gfold/darwin.toml" "$HOME/.config" "gfold.toml"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/global-cargo-config.toml" "$HOME/.cargo" "config.toml"

    # Only use rustup if it is installed.
    if command -v rustup; then
        rustup toolchain install stable-aarch64-apple-darwin
        rustup toolchain install nightly-aarch64-apple-darwin
        rustup default stable-aarch64-apple-darwin
    fi
}

function setup-dotfiles-linux {
    git config --global user.name "$NICK_BOOTSTRAP_GLOBAL_GIT_USER_NAME"
    git config --global pull.rebase true

    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/zshrc" "$HOME" ".zshrc"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/tmux.conf" "$HOME" ".tmux.conf"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/init.lua" "$HOME/.config/nvim" "init.lua"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/starship.toml" "$HOME/.config" "starship.toml"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/alacritty/darwin.yml" "$HOME/.config/alacritty" "alacritty.yml"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/gfold/darwin.toml" "$HOME/.config" "gfold.toml"
    link "$NICK_BOOTSTRAP_DOTFILES_DIRECTORY/global-cargo-config.toml" "$HOME/.cargo" "config.toml"

    # Only use rustup if it is installed.
    if command -v rustup; then
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
    fi
}

# ==============================================
# === Generic Package Installation Functions ===
# ==============================================

function install-neovim-plugins {
    local NEOVIM_VIM_PLUG_FILE
    NEOVIM_VIM_PLUG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim

    # Inspired by source: https://github.com/junegunn/vim-plug?tab=readme-ov-file#neovim
    if [ ! -f "$NEOVIM_VIM_PLUG_FILE" ]; then
        sh -c 'curl -fLo "$NEOVIM_VIM_PLUG_FILE" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi

    nvim --headless +PlugUpgrade +PlugUpdate +PlugClean +qall
}

# =================================
# === OS (and distro) Functions ===
# =================================

function run-fedora-install-packages {
    function explode {
        explode-inner "[bootstrap|fedora|install-packages]" "$1"
    }
    function log {
        log-inner "[bootstrap|fedora|install-packages]" "$1"
    }

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
        if ! [ "$(command -v docker)" ]; then
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

    function install-rust {
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
        else
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
            source "$HOME/.cargo/env"
        fi
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
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
    install-rust
    log "installing crates"
    install-crates
    log "installing neovim plugins"
    install-neovim-plugins
}

function run-fedora-setup-thelio {
    function explode {
        explode-inner "[bootstrap|fedora|setup-thelio]" "$1"
    }
    function log {
        log-inner "[bootstrap|fedora|setup-thelio]" "$1"
    }

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
    function explode {
        explode-inner "[bootstrap|fedora]" "$1"
    }
    function log {
        log-inner "[bootstrap|fedora]" "$1"
    }

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
        sudo dnf5 install -y findutils zsh make git neovim vim curl wget bash
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
    function explode {
        explode-inner "[bootstrap|pop]" "$1"
    }
    function log {
        log-inner "[bootstrap|pop]" "$1"
    }

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

    function install-rust {
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
        source "$HOME/.cargo/env"
        rustup toolchain install stable-x86_64-unknown-linux-gnu
        rustup toolchain install nightly-x86_64-unknown-linux-gnu
        rustup default stable-x86_64-unknown-linux-gnu
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
    log "installing rust"
    install-rust
    log "installing neovim plugins"
    install-neovim-plugins
    log "cleaning up"
    cleanup
}

function run-opensuse-tumbleweed {
    function explode {
        explode-inner "[bootstrap|opensuse-tumbleweed]" "$1"
    }
    function log {
        log-inner "[bootstrap|opensuse-tumbleweed]" "$1"
    }

    function install-packages {
        sudo zypper install -y -t pattern devel_basis
        sudo zypper install -y openssl libopenssl-devel make zsh jq curl wget neovim vim gcc-c++ ruby ruby-devel go
    }

    log "installing packages"
    install-packages
    log "installing neovim plugins"
    install-neovim-plugins
}

function run-darwin {
    function explode {
        explode-inner "[bootstrap|darwin]" "$1"
    }
    function log {
        log-inner "[bootstrap|darwin]" "$1"
    }

    local DARWIN_DATA
    local DARWIN_BASE_PACKAGES_FILE
    local DARWIN_CRATES_FILE

    DARWIN_DATA=$NICK_BOOTSTRAP_BOOTSTRAP_DIRECTORY/data/darwin
    DARWIN_BASE_PACKAGES_FILE=$DARWIN_DATA/base-packages.txt
    DARWIN_CRATES_FILE=$DARWIN_DATA/crates.txt

    function verify-paths {
        if [ ! -f "$DARWIN_BASE_PACKAGES_FILE" ]; then
            explode "not found $DARWIN_BASE_PACKAGES_FILE"
        fi
        if [ ! -f "$DARWIN_CRATES_FILE" ]; then
            explode "not found $DARWIN_CRATES_FILE"
        fi
    }

    function install-packages {
        xargs brew install < "$DARWIN_BASE_PACKAGES_FILE"
    }

    function install-casks {
        brew install --cask alacritty visual-studio-code font-iosevka font-iosevka-nerd-font font-jetbrains-mono
    }

    function install-crates {
        xargs cargo install < "$DARWIN_CRATES_FILE"
    }

    log "verifying paths"
    verify-paths
    log "installing packages"
    install-packages
    log "installing casks"
    install-casks
    log "installing crates"
    install-crates
    log "installing neovim plugins"
    install-neovim-plugins
}

# =======================
# === Main Entrypoint ===
# =======================

function main {
    function explode {
        explode-inner "[bootstrap]" "$1"
    }
    function log {
        log-inner "[bootstrap]" "$1"
    }

    log "running..."

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

        setup-dotfiles-darwin
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
            setup-dotfiles-linux
            if [ "true" = "$NICK_BOOTSTRAP_INSTALL_PACKAGES" ]; then
                if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
                    explode "cannot use WSL2 and perform advanced package installation"
                fi
                run-fedora
            fi
        elif [ "$LINUX_DISTRO" = "pop" ]; then
            setup-dotfiles-linux
            if [ "true" = "$NICK_BOOTSTRAP_INSTALL_PACKAGES" ]; then
                if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
                    explode "cannot use WSL2 and perform advanced package installation"
                fi
                run-pop
            fi
        elif [ "$LINUX_DISTRO" = "opensuse-tumbleweed" ]; then
            setup-dotfiles-linux
            if [ "true" = "$NICK_BOOTSTRAP_INSTALL_PACKAGES" ]; then
                if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
                    explode "cannot use WSL2 and perform advanced package installation"
                fi
                run-opensuse-tumbleweed
            fi
        fi
    else
        explode "must be macOS or Linux"
    fi

    log "success!"
}

main
