#!/usr/bin/env bash
set -eu

# NOTE(nick): essential items
# hyprland - the compositor
# kitty - hyprland default terminal
# swaync - notification handler
# xdg-desktop-portal-hyprland - xdg portal for hyprland
# polkit-kde-agent - authentication agent
# qt libraries - libraries for hyprland

# NOTE(nick): extra items
# waybar - status bar
# hyprpaper - wallpaper manager
# grim - screenshot-related (1/2)
# slurp - screenshot-related (2/2)
# wofi - app launcher
# cliphist - image and text clipboard
# hyprshade - blue light filter
# udiskie - automatic device mounting (cameras, removable drives, etc.)

sudo pacman -S --needed --noconfirm hyprland kitty swaync xdg-desktop-portal-hyprland polkit-kde-agent qt5-wayland qt6-wayland waybar hyprpaper grim slurp wofi cliphist hyprshade udiskie
paru -S --needed --noconfirm hyprshade
