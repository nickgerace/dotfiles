#!/usr/bin/env bash
set -eu

LINUX_PKG="/var/cache/pacman/pkg/linux-$1.arch1-1-x86_64.pkg.tar.zst"
LINUX_HEADERS_PKG="/var/cache/pacman/pkg/linux-headers-$1.arch1-1-x86_64.pkg.tar.zst"

if [ -f "$LINUX_PKG" ] && [ -f "$LINUX_HEADERS_PKG" ]; then
  sudo pacman -U "$LINUX_PKG"
  sudo pacman -U "$LINUX_HEADERS_PKG"
fi
