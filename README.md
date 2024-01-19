# dotfiles

[![GitHub](https://img.shields.io/github/license/nickgerace/dotfiles?style=flat-square)](./LICENSE)

A collection of dotfiles and scripts from [@nickgerace](https://github.com/nickgerace).

## Quickstart

Ensure the following:

1. `bash` and `zsh` are installed on your macOS or Linux system
1. That this repository resides in `$HOME/src/` (you will likely need to create the directory)

Then, execute the following to get started:

```bash
make
```

The invoked `make` target is idempotent-ish, so you should be able to execute it multiple times, as desired.
However, it may overwrite files if you are coming from an existing configuration.
Please read the source code, starting from the [Makefile](./Makefile), before execution.

## Platform Notes

These dotfiles require neither [`oh-my-zsh`](https://ohmyz.sh/) nor [`starship`](https://starship.rs/) to be installed (though, a  `starship` configuration file will be linked to `$HOME/.config/starship.toml`).
Only `zsh` needs to be installed as everything is configured manually.

While most Linux distros can use these dotfiles, only hand-selected distros have advanced bootstrapping options.
Advanced bootstrapping options are available via the interactive installer.

WSL2 is supported, but advanced bootstrapping options from the interactive installer will likely be blocked.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
