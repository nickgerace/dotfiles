# dotfiles

[![GitHub](https://img.shields.io/github/license/nickgerace/dotfiles?style=flat-square)](LICENSE)

A collection of dotfiles and scripts from [@nickgerace](https://github.com/nickgerace).

## Quickstart

Before starting, ensure that `bash` and `zsh` are installed on your macOS or Linux system.
You will also need to ensure that this repository resides in the `$HOME/src/` directory.
You may need to create it by executing `mkdir $HOME/src`.

Once everything looks good, execute the following:

> [!WARNING]
> Running the `make` target may overwrite files if you are coming from an existing configuration.
> Please read the source code, starting from the [Makefile](Makefile), before executing the target.

```bash
make
```

The invoked `make` target runs an idempotent-ish bootstrap script, so you should be able to execute it multiple times.
That being said: *caution is advised*.

### Option for Thelio Users

For [System76 Thelio](https://system76.com/desktops) users running [Pop!\_OS](https://pop.system76.com), execute the following:

```bash
make thelio
```

## Q&A

This section contains questions and answers regarding these dotfiles.

### What interactive shell do the dotfiles rely on?

These dotfiles rely on [`zsh`](https://www.zsh.org/) as the interactive shell.

### What about `oh-my-zsh` and `starship`?

These dotfiles require neither [`oh-my-zsh`](https://ohmyz.sh/) nor [`starship`](https://starship.rs/) to be installed.
Only `zsh` needs to be installed as all shell-based dotfiles are custom and configured manually.
That being said, if `starship` is installed, it will use the configuration file linked to `$HOME/.config/starship.toml`.

### Does the bootstrapper offer options beyond setting up dotfiles?

The bootstrapper only sets up dotfiles by default.
However, for certain Linux distributions and for macOS, you can optionally install packages and setup the base system (e.g. install an opinionated set of base packages with a package manager).

### Is WSL2 supported?

[WSL2](https://learn.microsoft.com/en-us/windows/wsl/) is supported for dotfiles setup, but package installation is blocked.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
