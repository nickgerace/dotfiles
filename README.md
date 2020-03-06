# Dotfiles
**created by: [Nick Gerace](https://nickgerace.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of my dotfiles and related scripts.

## Requirements

The following must be installed before the **make** command is performed.

- bash
- curl
- git
- tmux

Depending on what you want, there may be more requirements, such as **zsh** and **fish**.
However, they do not appear as targets in the Makefile.

## Installation

Be sure to read the Makefile to see what the targets do.

```bash
git clone --depth=1 https://github.com/nickgerace/dotfiles.git
make -f dotfiles/Makefile install
rm -r dotfiles/
```
