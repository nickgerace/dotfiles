# Dotfiles

**created by: [Nick Gerace](https://nickgerace.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of my dotfiles and related scripts.

## Requirements

Due to the ever-changing nature of this repoistory, requirements are always in flux.
Be sure to read through interested ```make``` targets before using them.

## Installation

```bash
# Perform a shallow clone of the repository.
git clone --depth=1 https://github.com/nickgerace/dotfiles.git

# For macOS users...
make -f dotfiles/Makefile install-mac

# For Linux and WSL2 users...
make -f dotfiles/Makefile install-linux

# Remove the repository, if it is no longer needed.
rm -r dotfiles/
```
