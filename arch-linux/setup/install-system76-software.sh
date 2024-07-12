#!/usr/bin/env bash
set -eu

echo "Performing initial checks..."
. /etc/os-release
if [ "$(uname -s)" != "Linux" ] || [ "$(uname -m)" != "x86_64" ] || [ "$ID" != "arch" ]; then
  echo "Must be Arch Linux x86_64" >&2
  exit 1
fi

if [ -f /proc/sys/kernel/osrelease ] && grep "WSL2" /proc/sys/kernel/osrelease; then
  echo "Cannot run in WSL2" >&2
  exit 1
fi

echo "Installing base dependencies..."
sudo pacman -S --noconfirm --needed base-devel git linux-headers rustup

echo "Setting up rust..."
rustup default stable

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

echo "Installing and setting up system76 firmware daemon..."
paru -S --noconfirm system76-firmware-daemon-git
sudo systemctl enable --now system76-firmware-daemon
sudo gpasswd -a "$USER" adm

echo "Installing and setting up firmware manager and system76 driver..."
paru -S --noconfirm firmware-manager-git
paru -S --noconfirm system76-driver
sudo systemctl enable --now system76

echo "Installing and setting up system76 software and enabling power daemon..."
paru -S --noconfirm system76-power system76-dkms system76-acpi-dkms system76-io-dkms
sudo systemctl enable --now com.system76.PowerDaemon.service

echo "Success! If you need additional system76 software packages, you can install them now. Restart your system to utilize all installed software."
