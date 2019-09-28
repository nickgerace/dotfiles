# Dotfiles
**created by: [Nick Gerace](https://nickgerace.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of my dotfiles and related scripts.

## Why Only Instructions For Fish?

While there are Make targets for **zsh**, this README will only look at **fish**.
The former is a great shell, but **fish** is much more user friendly and has very sane defaults.

## Requirements

The following must be installed before the **make** command is performed.

- [fish](https://fishshell.com/)
- [vim](https://github.com/vim/vim)

## Installation

*Note:* be sure to read the Makefile to see what the targets do.
- For this Make target, it installs vim-plug, the vim-plug packages from the vimrc, and the relevant dotfiles.
- Those files are config.fish, .vimrc, and .aliases.sh.

Perform a shallow clone and then run the following commands.

```bash
git clone --depth=1 https://github.com/nickgerace/dotfiles
cd dotfiles
make install-fish
```
