#!/usr/bin/env bash
set -euo pipefail

if [ $EUID -eq 0 ]; then
  echo "must run as non-root user" >&2
  exit 1
fi
sudo -v

# Get xargs command
sudo dnf install -y findutils

# Ghostty install
if ! command -v ghostty; then
  sudo dnf copr enable -y scottames/ghostty
  sudo dnf install -y ghostty
fi

# Homebrew deps then install
sudo dnf group install -y development-tools
sudo dnf install -y procps-ng curl file

if ! command -v brew; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  if ! command -v brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.^Cshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

if ! command -v caligula; then
  brew tap philocalyst/tap
  brew install caligula
fi

sudo dnf install -y helix htop hugo git eza fastfetch hyperfine fd-find bat zoxide fzf gh jq wget tree
brew install just nushell dua-cli caligula gfold ripgrep jujutsu kubernetes-cli vivid

# sudo install -y fwupd
# sudo fwupdmgr refresh
# sudo fwupdmgr get-updates
# sudo fwupdmgr update

if ! command -v docker; then
  if [ ! -f /etc/yum.repos.d/docker-ce.repo ]; then
    sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
  fi
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable --now docker
  sudo docker run hello-world
  if ! getent group docker; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker $USER
fi


# TODO: check using "any" if these already appear
# dnf repolist --json | jq .[].name
# sudo dnf install -y \
#   https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# sudo dnf install -y \
#   https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Docs: https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/#_enabling_appstream_data_from_the_rpm_fusion_repositories
# sudo dnf group upgrade core
# sudo dnf install -y fedora-workstation-repositories

# Docs: https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/#_installing_chrome
# sudo dnf install -y fedora-workstation-repositories
# sudo dnf config-manager setopt google-chrome.enabled=1
# sudo dnf config-manager --set-enabled google-chrome
# sudo dnf install -y google-chrome-stable

# flatpak remote-delete flathub
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak install -y flathub \
#   com.discordapp.Discord \
#   com.google.Chrome \
#   com.slack.Slack \

# flatpak update -y
# flatpak uninstall --unused
sudo dnf upgrade -y --refresh
sudo dnf autoremove -y
