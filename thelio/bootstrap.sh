#!/usr/bin/env bash
set -eu

THELIO_BOOTSTRAP_DOTFILES_DIRECTORY="$HOME/src/dotfiles"
THELIO_BOOTSTRAP_INSTALL_PACKAGES="false"

THELIO_BOOTSTRAP_LOG_FORMAT_BOLD=$(tput bold)
THELIO_BOOTSTRAP_LOG_FORMAT_GREEN=$(tput setaf 2)
THELIO_BOOTSTRAP_LOG_FORMAT_RED=$(tput setaf 1)
THELIO_BOOTSTRAP_LOG_FORMAT_RESET=$(tput sgr0)

function log {
    echo "${THELIO_BOOTSTRAP_LOG_FORMAT_BOLD}$1${THELIO_BOOTSTRAP_LOG_FORMAT_RESET}"
}

function log-success {
    echo "${THELIO_BOOTSTRAP_LOG_FORMAT_BOLD}${THELIO_BOOTSTRAP_LOG_FORMAT_GREEN}$1${THELIO_BOOTSTRAP_LOG_FORMAT_RESET}"
}

function log-error {
    echo "${THELIO_BOOTSTRAP_LOG_FORMAT_BOLD}${THELIO_BOOTSTRAP_LOG_FORMAT_RED}$1${THELIO_BOOTSTRAP_LOG_FORMAT_RESET}" >&2
}

log "Welcome to @nickgerace's System76 Thelio bootstrap script for Pop!_OS!"

while true; do
    read -r -n1 -p "Do you want to install packages in addition to setting up dotfiles? [y/n] (default: n): " yn
    case $yn in
        [yY] ) THELIO_BOOTSTRAP_INSTALL_PACKAGES="true"; echo ""; break;;
        "" ) break;;
        * ) echo ""; break;;
    esac
done
while true; do
    read -r -n1 -p "Run the bootstrap script? [y/n] (default: y): " yn
    case $yn in
        [yY] ) echo ""; break;;
        "" ) echo ""; break;;
         * ) exit 0;;
    esac
done

# Check for non-root user
if [ $EUID -eq 0 ]; then
  log-error "Must run as non-root."
  exit 1
fi

# Link all dotfiles
function link {
  if [ ! -f "$1" ]; then
    log-error "File does not exist: $1"
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
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/zshrc" "$HOME/.zshrc"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/wezterm.lua" "$HOME/.wezterm.lua"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/starship.toml" "$HOME/.config/starship.toml"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/cargo-config-global.toml" "$HOME/.cargo/config.toml"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/helix/config.toml" "$HOME/.config/helix/config.toml"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/helix/languages.toml" "$HOME/.config/helix/languages.toml"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
link "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/thelio/data/home.nix" "$HOME/.config/home-manager/home.nix"

# # Configure git
git config --global pull.rebase true

# Bail if we do not wish to install packages
if [[ "$THELIO_BOOTSTRAP_INSTALL_PACKAGES" != "true" ]]; then
  log-success "Success!"
  exit 0
fi

# Escalate and prepare to install packages
log "Setting up package installation..."
sudo -v
sudo apt update
sudo apt upgrade -y

# Install base packages
log "Installing base packages..."
xargs sudo apt install -y < "$THELIO_BOOTSTRAP_DOTFILES_DIRECTORY/thelio/data/base-packages.txt"

# Install Iosevka Nerd Font
if [ ! -f $HOME/.local/share/fonts/IosevkaNerdFont-Regular.ttf ]; then
  log "Installing iosevka nerd font..."
  mkdir -p $HOME/.local/share/fonts
  pushd $HOME/.local/share/fonts
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.tar.xz
  tar -xf Iosevka.tar.xz
  [[ -f LICENSE ]] && rm LICENSE
  [[ -f README.md ]] && rm README.md
  rm Iosevka.tar.xz
  popd
  fc-cache
fi

# Install nix
if ! command -v nix && [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
if ! command -v nix; then
  log "Installing nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi

# Add zsh to nix shells
if [ "$SHELL" != "$HOME/.nix-profile/bin/zsh" ]; then
  if [[ ! $(grep "$HOME/.nix-profile/bin/zsh" /etc/shells) ]]; then
    echo "$HOME/.nix-profile/bin/zsh" |sudo tee -a /etc/shells
  fi
  log "Setting default shell to zsh from home-manager..."
  chsh -s "$HOME/.nix-profile/bin/zsh"
fi

# Install rustup and rust
if ! command -v rustup && [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
if ! command -v rustup; then
  log "Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  source "$HOME/.cargo/env"
fi
log "Setting up rust toolchain..."
rustup toolchain install stable-x86_64-unknown-linux-gnu
rustup default stable-x86_64-unknown-linux-gnu
rustup component add rust-analyzer

# Install home-manager
if ! command -v home-manager; then
  log "Installing home-manager..."
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
fi
log "Setting up home-manager..."
home-manager switch

# Install docker
if ! command -v docker; then
  log "Installing docker..."
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker "$USER"
  sudo docker run hello-world
fi

# Install latest node lts and npm packages (fnm comes from home-manager)
log "Setting up fnm..."
eval "$(fnm env --use-on-cd)"
log "Installing latest node lts via fnm..."
fnm install --lts
log "Installing npm packages..."
npm i -g \
 @vue/language-server \
 prettier \
 typescript \
 typescript-language-server

# Install flatpaks
log "Installing flatpaks..."
flatpak install flathub \
  com.discordapp.Discord \
  com.google.Chrome \
  com.slack.Slack \
  com.spotify.Client \
  md.obsidian.Obsidian \
  org.wezfurlong.wezterm \
  us.zoom.Zoom

# Last step
log "Running final update and cleanup commands..."
rustup update
sudo -i nix upgrade-nix
nix-channel --update
home-manager switch
flatpak update -y
flatpak uninstall --unused
flatpak repair
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean -y
log-success "Success!"
