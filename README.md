# Dotfiles
**created by: [Nick Gerace](https://nickgerace.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of my dotfiles and related scripts.

## Requirements

The following must be installed before the **make** command is performed.

- [bash](https://www.gnu.org/software/bash/) - any target that includes "bash"
- [vim](https://github.com/vim/vim) - any target that includes "vim"

Depending on what you want, there may be more requirements, such as **zsh** and **fish**.
However, they do not appear as targets in the Makefile.

## Installation

*Note:* be sure to read the Makefile to see what the targets do.

Perform a shallow clone and then run the following commands.
In this example, we will be setting up the **bash** shell, **vim**, **vim-plug**, and my **aliases**.

```bash
git clone --depth=1 https://github.com/nickgerace/dotfiles.git
cd dotfiles
make install-all
```
