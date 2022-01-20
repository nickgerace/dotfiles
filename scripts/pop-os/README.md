# Setting up Pop!_OS

This guide is aimed at setting up a fresh installation of [Pop!_OS](https://pop.system76.com/).

## Install and Upgrade Base Packages

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y zsh make git neovim vim curl wget bash build-essential
sudo apt autoremove -y
```

## Clone Dotfiles and Bootstrap

```bash
( cd ~/src/dotfiles; make )
```

## Change Default Shell

```bash
chsh -s $(which zsh)
```

Log out and log back in.

## Execute Bootstrap Script

```bash
~/src/dotfiles/scripts/pop-os/bootstrap.sh
```

Log out and log back in.

## Install GUI and Optional Applications

Here are some examples:

- Google Chrome
- Zoom
- Slack
- CLion
- VS Code
- Tailscale
- [Mold](https://github.com/rui314/mold)

## Setup GNOME Terminal

Use [Gogh](https://mayccoll.github.io/Gogh/) to customize terminal with a theme (e.g. Atom One Light).
You may have to create an extra profile first in your terminal preferences.