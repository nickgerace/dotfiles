#!/usr/bin/env bash
set -eu

INSTALL_BOOTSTRAP_PLATFORM="false"
INSTALL_DOTFILES_REPO="$HOME/src/dotfiles"
INSTALL_PLATFORM="false"

INSTALL_LOG_FORMAT_BOLD=$(tput bold)
INSTALL_LOG_FORMAT_GREEN=$(tput setaf 2)
INSTALL_LOG_FORMAT_RED=$(tput setaf 1)
INSTALL_LOG_FORMAT_RESET=$(tput sgr0)

function log {
  echo "${INSTALL_LOG_FORMAT_BOLD}$1${INSTALL_LOG_FORMAT_RESET}"
}

function log-success {
  echo "${INSTALL_LOG_FORMAT_BOLD}${INSTALL_LOG_FORMAT_GREEN}$1${INSTALL_LOG_FORMAT_RESET}"
}

function log-error {
  echo "${INSTALL_LOG_FORMAT_BOLD}${INSTALL_LOG_FORMAT_RED}Error: $1${INSTALL_LOG_FORMAT_RESET}" >&2
}

log "Welcome to @nickgerace's dotfiles setup and platform bootstrap script!"

while true; do
  read -r -n1 -p "Do you want to install packages in addition to setting up dotfiles? [y/n] (default: n): " yn
  case $yn in
  [yY])
    INSTALL_BOOTSTRAP_PLATFORM="true"
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
while true; do
  read -r -n1 -p "Confirm to begin [y/n] (default: y): " yn
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

log "Checking user..."
if [ $EUID -eq 0 ]; then
  log-error "must run as non-root user"
  exit 1
fi

log "Checking platform..."
if [ "$(uname -s)" = "Linux" ]; then
  if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
    log "WSL2 detected!"
  elif [ "$(uname -m)" = "x86_64" ] && [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" = "arch" ]]; then
      log "Found bootstrap-compatible platform: Arch Linux x86_64"
      INSTALL_PLATFORM="arch"
    elif [[ "$ID" = "pop" ]]; then
      log "Found bootstrap-compatible platform: Pop!_OS x86_64"
      INSTALL_PLATFORM="pop"
    elif [[ "$ID" = "fedora" ]]; then
      if [[ "$VARIANT_ID" = "workstation" ]]; then
        log "Found bootstrap-compatible platform: Fedora Workstation x86_64"
        INSTALL_PLATFORM="fedora-workstation"
      elif [[ "$VARIANT_ID" = "server" ]]; then
        log "Found bootstrap-compatible platform: Fedora Server x86_64"
        INSTALL_PLATFORM="fedora-server"
      fi
    elif [[ "$ID" = "nixos" ]]; then
      log "Found bootstrap-compatible platform: NixOS x86_64"
      INSTALL_PLATFORM="nixos"
    fi
  fi
elif [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ]; then
  log "Found bootstrap-compatible platform: macOS aarch64"
  INSTALL_PLATFORM="darwin"
fi

function link {
  if [ ! -f "$1" ]; then
    log-error "file does not exist: $1"
    exit 1
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

log "Setting up dotfiles..."
git config --global pull.rebase true

link "$INSTALL_DOTFILES_REPO/.zshrc" "$HOME/.zshrc"
link "$INSTALL_DOTFILES_REPO/helix/config.toml" "$HOME/.config/helix/config.toml"
link "$INSTALL_DOTFILES_REPO/helix/languages.toml" "$HOME/.config/helix/languages.toml"
link "$INSTALL_DOTFILES_REPO/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
link "$INSTALL_DOTFILES_REPO/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "$INSTALL_DOTFILES_REPO/bat/config" "$HOME/.config/bat/config"
link "$INSTALL_DOTFILES_REPO/bat/themes/catppuccin-frappe.tmTheme" "$HOME/.config/bat/themes/catppuccin-frappe.tmTheme"

if [ "$INSTALL_PLATFORM" = "darwin" ]; then
  link "$INSTALL_DOTFILES_REPO/ghostty/config" "$HOME/.config/ghostty/config"
  link "$INSTALL_DOTFILES_REPO/gfold/darwin.toml" "$HOME/.config/gfold.toml"
else
  link "$INSTALL_DOTFILES_REPO/gfold/linux.toml" "$HOME/.config/gfold.toml"
  if [ "$INSTALL_PLATFORM" = "arch" ]; then
    link "$INSTALL_DOTFILES_REPO/os/arch-linux/cargo/config.toml" "$HOME/.cargo/config.toml"
  elif [ "$INSTALL_PLATFORM" = "fedora" ]; then
    link "$INSTALL_DOTFILES_REPO/os/fedora/cargo/config.toml" "$HOME/.cargo/config.toml"
  elif [ "$INSTALL_PLATFORM" = "pop" ]; then
    link "$INSTALL_DOTFILES_REPO/os/pop-os/home-manager/home.nix" "$HOME/.config/home-manager/home.nix"
  fi
fi

if [ "$INSTALL_BOOTSTRAP_PLATFORM" != "true" ]; then
  log-success "Success!"
  exit 0
elif [ "$INSTALL_PLATFORM" = "false" ]; then
  log-error "dotfiles setup succeeded, but skipping bootstrapper (read script for compatible platforms)"
  exit 1
elif [ "$INSTALL_PLATFORM" = "pop" ]; then
  log "Setting up package installation..."
  sudo apt update
  sudo apt upgrade -y

  log "Installing base packages..."
  xargs sudo apt install -y <"$INSTALL_DOTFILES_REPO/os/pop-os/pkgs/core.lst"

  log "Checking for nix installation..."
  if ! command -v nix && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  if ! command -v nix; then
    log "Installing nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  fi

  if ! command -v home-manager; then
    log "Installing home-manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
  fi
  log "Running home-manager switch..."
  home-manager switch

  log "Checking default shell..."
  if [ "$SHELL" != "$HOME/.nix-profile/bin/zsh" ]; then
    if [[ ! $(grep "$HOME/.nix-profile/bin/zsh" /etc/shells) ]]; then
      echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
    fi
    log "Setting default shell to zsh from home-manager..."
    chsh -s "$HOME/.nix-profile/bin/zsh"
  fi

  if ! command -v rustup && [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
  if ! command -v rustup; then
    log "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    source "$HOME/.cargo/env"
  fi
  log "Setting up rust toolchain..."
  rustup default stable
  rustup component add rust-analyzer

  if ! command -v docker; then
    log "Installing docker..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    sudo docker run hello-world
  fi

  log "Setting up fnm (comes with home-manager)..."
  eval "$(fnm env --use-on-cd)"
  log "Installing latest node lts via fnm..."
  fnm install --lts
  log "Installing npm packages..."
  npm set prefix ~/.npm-global
  npm i -g \
    @vue/language-server \
    prettier \
    typescript \
    typescript-language-server

  log "Installing flatpaks..."
  flatpak install flathub \
    com.discordapp.Discord \
    com.google.Chrome \
    com.slack.Slack \
    com.spotify.Client \
    md.obsidian.Obsidian \
    us.zoom.Zoom

  log "Running final update and cleanup commands..."
  rustup update
  sudo -i nix upgrade-nix
  nix-channel --update
  home-manager switch
  flatpak update -y
  flatpak uninstall --unused
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt clean -y

  log-success "Success!"
elif [ "$INSTALL_PLATFORM" = "arch" ]; then
  log "Upgrading packages before continuing..."
  sudo pacman -Syu --noconfirm

  log "Installing core packages..."
  sudo pacman -S --noconfirm --needed - <"$INSTALL_DOTFILES_REPO/os/arch-linux/pkgs/core.lst"

  # TODO(nick): split desktop and server install.
  # log "Installing GNOME..."
  # sudo pacman -S --noconfirm --needed - <"$INSTALL_DOTFILES_REPO/os/arch-linux/pkgs/gnome.lst"
  # sudo systemctl enable gdm.service
  #
  # log "Install xorg for GNOME (due to Zoom PipeWire 1.2.x bugs and Discord screen share)..."
  # sudo pacman -S --noconfirm --needed xorg

  echo "Attempting to find paru..."
  if ! command -v paru; then
    echo "Installing paru..."
    pushd "$(mktemp -d)"
    git clone https://aur.archlinux.org/paru.git
    pushd paru
    makepkg -si --noconfirm
    popd
    popd
  fi

  log "Installing AUR packages via paru..."
  paru -S --noconfirm --needed - <"$INSTALL_DOTFILES_REPO/os/arch-linux/pkgs/aur.lst"

  log "Checking if host is a System76 Thelio Major..."
  if [ "$(cat /sys/class/dmi/id/product_name)" = "Thelio Major" ]; then
    log "Setting up rust for installing system76 software..."
    rustup default stable
    rustup component add rust-analyzer

    if paru -Qs system76-firmware-daemon-git; then
      log "Skipping system76 firmware daemon installation and setup (already installed)..."
    else
      log "Installing and setting up system76 firmware daemon..."
      paru -S --noconfirm system76-firmware-daemon-git
      sudo systemctl enable --now system76-firmware-daemon
      sudo gpasswd -a "$USER" adm

      log "Installing and setting up firmware manager and system76 driver..."
      paru -S --noconfirm firmware-manager-git
      paru -S --noconfirm system76-driver
      sudo systemctl enable --now system76

      echo "Installing and setting up system76 software and enabling power daemon..."
      paru -S --noconfirm system76-power system76-dkms system76-acpi-dkms system76-io-dkms
      sudo systemctl enable --now com.system76.PowerDaemon.service
    fi
  fi

  log "Setting up nix..."
  sudo usermod -aG nixbld "$USER"
  sudo usermod -aG nix-users "$USER"
  sudo systemctl enable --now nix-daemon.service
  nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
  nix-channel --update

  log "Checking default shell..."
  if [ "$SHELL" != "$(which zsh)" ]; then
    log "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
  fi

  log "Setting up rust via rustup..."
  rustup default stable
  rustup component add rust-analyzer

  log "Setting up docker..."
  sudo systemctl enable --now docker.socket
  sudo usermod -aG docker "$USER"
  sudo docker run hello-world

  log "Setting up tailscale (without running 'tailscale up')..."
  sudo systemctl enable --now tailscaled.service

  # TODO(nick): split desktop and server install.
  # log "Installing flatpaks..."
  # flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # xargs flatpak install flathub -yu <"$INSTALL_DOTFILES_REPO/os/arch-linux/pkgs/flatpak.lst"

  log "Running final update and cleanup commands..."
  sudo pacman -Syu --noconfirm

  # TODO(nick): confirm if nix needs to upgrade itself...
  # sudo -i nix upgrade-nix
  
  # TODO(nick): split desktop and server install.
  # flatpak update -y
  # flatpak uninstall --unused

  log-success "Success!"
elif [ "$INSTALL_PLATFORM" = "darwin" ]; then
  log "Checking for nix installation..."
  if ! command -v nix && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  if ! command -v nix; then
    log "Installing nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  fi

  log "Checking for nix-darwin..."
  if ! command -v darwin-rebuild; then
    pushd $INSTALL_DOTFILES_REPO
    log "Installing nix-darwin..."
    nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
    popd
  fi

  log "Running darwin-rebuild switch..."
  darwin-rebuild switch --flake .

  if [ "$(scutil --get LocalHostName)" = "sibook" ]; then
    log "Installing npm packages for helix LSPs..."
    npm set prefix ~/.npm-global
    npm i -g \
      @vue/language-server \
      prettier \
      typescript \
      typescript-language-server
  fi

  log-success "Success!"
elif [ "$INSTALL_PLATFORM" = "fedora-workstation" ]; then
  log "Upgrading packages before continuing..."
  sudo dnf upgrade -y --refresh

  log "Installing findutils for xargs command..."
  sudo dnf install -y findutils

  log "Installing base packages..."
  xargs sudo dnf install -y <"$INSTALL_DOTFILES_REPO/os/fedora/pkgs/core.lst"

  log "Checking if zellij is installed..."
  if ! command -v zellij; then
    log "Installing zellij from varlad/zellij copr..."
    sudo dnf copr enable -y varlad/zellij
    sudo dnf install -y zellij
  fi

  log "Setting up rpmfusion..."
  sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

  # Source: https://rpmfusion.org/Howto/Multimedia
  log "Setting up multimedia codecs..."
  sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
  sudo dnf groupupdate -y multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  sudo dnf groupupdate -y sound-and-video

  log "Checking for rustup initialization..."
  if ! command -v rustup; then
    log "Running rustup-init..."
    rustup-init --no-modify-path -y
  fi
  . "$HOME/.cargo/env"

  log "Setting default rust toolchain and install rust-analyzer for helix..."
  rustup default stable
  rustup component add rust-analyzer

  log "Checking if host is a System76 Thelio Major..."
  if [ -f /sys/class/dmi/id/product_name ] && [ "$(cat /sys/class/dmi/id/product_name)" = "Thelio Major" ]; then
    log "Installing and setting up system76 software from syzdell/system76 copr..."
    sudo dnf copr enable -y szydell/system76
    sudo dnf install -y system76* firmware-manager
    sudo systemctl enable --now \
      com.system76.PowerDaemon.service \
      system76-firmware-daemon \
      system76-power-wake
    sudo systemctl mask power-profiles-daemon.service
    sudo gpasswd -a "$USER" adm
  fi

  log "Checking for docker installation..."
  if ! command -v docker; then
    log "Installing and setting up docker..."
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo docker run hello-world
    sudo usermod -aG docker "$USER"
  fi

  log "Checking for nix installation..."
  if ! command -v nix && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  if ! command -v nix; then
    log "Installing nix via the determinate nix installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  fi

  log "Checking default shell..."
  if [ "$SHELL" != "/usr/bin/zsh" ]; then
    log "Changing default shell to zsh..."
    chsh -s "/usr/bin/zsh"
  fi

  log "Installing npm packages for helix (LSPs, etc.)..."
  npm set prefix ~/.npm-global
  xargs npm i -g <"$INSTALL_DOTFILES_REPO/os/fedora/pkgs/npm.lst"

  log "Installing flatpaks..."
  xargs flatpak install flathub -y <"$INSTALL_DOTFILES_REPO/os/fedora/pkgs/flatpak.lst"

  log "Running final update and cleanup commands..."
  sudo -i nix upgrade-nix
  npm up -g
  flatpak update -y
  flatpak uninstall --unused
  sudo dnf upgrade -y --refresh
  sudo dnf autoremove -y

  log-success "Success!"
elif [ "$INSTALL_PLATFORM" = "fedora-server" ]; then
  log "Prepare XFS filesystem before running base package upgrades..."
  sudo lvextend /dev/fedora_fedora/root -l+100%FREE || true
  sudo xfs_growfs -d / || true
  df -h /

  log "Upgrading packages before continuing..."
  sudo dnf upgrade -y --refresh

  log "Installing findutils for xargs command..."
  sudo dnf install -y findutils

  log "Installing base packages..."
  xargs sudo dnf install -y <"$INSTALL_DOTFILES_REPO/os/fedora/pkgs/core.lst"

  log "Checking if zellij is installed..."
  if ! command -v zellij; then
    log "Installing zellij from varlad/zellij copr..."
    sudo dnf copr enable -y varlad/zellij
    sudo dnf install -y zellij
  fi

  log "Checking for rustup initialization..."
  if ! command -v rustup; then
    log "Running rustup-init..."
    rustup-init --no-modify-path -y
  fi
  . "$HOME/.cargo/env"

  log "Setting default rust toolchain and install rust-analyzer for helix..."
  rustup default stable
  rustup component add rust-analyzer

  log "Checking if host is a System76 Thelio Major..."
  if [ -f /sys/class/dmi/id/product_name ] && [ "$(cat /sys/class/dmi/id/product_name)" = "Thelio Major" ]; then
    log "Checking if System76 software is installed..."
    if ! command -v system76-driver; then
      log "Installing and setting up system76 software from syzdell/system76 copr..."
      sudo dnf copr enable -y szydell/system76
      sudo dnf install -y system76* firmware-manager
      sudo systemctl enable --now \
        com.system76.PowerDaemon.service \
        system76-firmware-daemon \
        system76-power-wake
      sudo gpasswd -a "$USER" adm
    fi
  fi

  log "Checking for docker installation..."
  if ! command -v docker; then
    log "Installing and setting up docker..."
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo docker run hello-world
    sudo usermod -aG docker "$USER"
  fi

  log "Checking for nix installation..."
  if ! command -v nix && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  if ! command -v nix; then
    log "Installing nix via the determinate nix installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  fi

  log "Installing tailscale..."
  if ! command -v tailscale; then
    sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    sudo dnf install -y tailscale
    sudo systemctl enable --now tailscaled
  fi

  log "Checking default shell..."
  if [ "$SHELL" != "/usr/bin/zsh" ]; then
    log "Changing default shell to zsh..."
    chsh -s "/usr/bin/zsh"
  fi

  log "Installing npm packages for helix (LSPs, etc.)..."
  npm set prefix ~/.npm-global
  xargs npm i -g <"$INSTALL_DOTFILES_REPO/os/fedora/pkgs/npm.lst"

  log "Running final update and cleanup commands..."
  sudo -i nix upgrade-nix
  npm up -g
  sudo dnf upgrade -y --refresh
  sudo dnf autoremove -y

  log-success "Success!"
elif [ "$INSTALL_PLATFORM" = "nixos" ]; then
  log "Running nixos-rebuild..."
  pushd "$INSTALL_DOTFILES_REPO"
  sudo nixos-rebuild switch --flake .
  popd

  log "Installing npm packages..."
  npm set prefix ~/.npm-global
  npm i -g \
    @vue/language-server \
    prettier \
    typescript \
    typescript-language-server

  log "Running final update and cleanup commands..."
  npm up -g

  log-success "Success!"
fi
