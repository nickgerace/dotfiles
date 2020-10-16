# dotfiles

[![GitHub](https://img.shields.io/github/license/nickgerace/dotfiles?style=flat-square)](./LICENSE)

A collection of [@nickgerace](https://github.com/nickgerace)'s dotfiles and related scripts.

## Requirements

Due to the ever-changing nature of this repoistory, requirements are always in flux.
Be sure to read through interested ```make``` targets before using them.

## Installation

Perform a shallow clone of the repository. Afterwards, remove the repository, if it is no longer needed.

```bash
git clone --depth=1 https://github.com/nickgerace/dotfiles.git
make -f dotfiles/Makefile install
rm -r dotfiles/
```
