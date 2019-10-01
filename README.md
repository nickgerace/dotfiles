# Dotfiles
**created by: [Nick Gerace](https://nickgerace.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of my dotfiles and related scripts.

## Requirements

The following must be installed before the **make** command is performed.

- [fish](https://fishshell.com/) - any target that includes "fish"
- [vim](https://github.com/vim/vim) - any target that includes "vim"
- [zsh](https://en.wikipedia.org/wiki/Z_shell) - any target that includes "zsh"

## Installation

*Note:* be sure to read the Makefile to see what the targets do.

Perform a shallow clone and then run the following commands.
In this example, we will be installing the **fish** shell, **vim**, **vim-plug**, and my **aliases**.

```bash
git clone --depth=1 https://github.com/nickgerace/dotfiles
cd dotfiles
make install-fish install-vim install-aliases
```
