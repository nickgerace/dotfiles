# dotfiles

[![GitHub](https://img.shields.io/github/license/nickgerace/dotfiles?style=flat-square)](./LICENSE)

A collection of dotfiles and scripts from [@nickgerace](https://github.com/nickgerace).

## Quickstart

_Before running the setup automation, you will need to update [dotfiles.toml](./dotfiles.toml)_.

Execute the following to get started:

```bash
make
```

This `make` target is idempotent, so you should be able to execute it multiple times, if needed.
However, it may overwrite files if you are coming from an existing configuration, so please read the [Makefile](./Makefile) before execution.

## Shell Configuration

These dotfiles have been tested in the following environments using `zsh` as the default shell:

| OS    | Type      | `x86_64 / amd64` | `arm64 / aarch64` |
| ----- | --------- | ---------------- | ----------------- |
| macOS | darwin    | 🚫               | ✅                |
| Linux | linux-gnu | ✅               | 🚫                |
| WSL2  | linux-gnu | ✅               | 🚫                |

### What about `oh-my-zsh`?

This shell configuration does not use `oh-my-zsh`.
Only `zsh` needs to be installed as everything is configured manually.

## GNOME Users

Using [Gogh](https://mayccoll.github.io/Gogh/) can help setup your terminal colors nicely.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
