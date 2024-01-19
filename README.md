# dotfiles

[![GitHub](https://img.shields.io/github/license/nickgerace/dotfiles?style=flat-square)](./LICENSE)

A collection of dotfiles and scripts from [@nickgerace](https://github.com/nickgerace).

## Quickstart

Before starting, ensure that `bash` and `zsh` are installed on your macOS or Linux system.
You will also need to ensure that this repository resides in the `$HOME/src/` directory.
You may need to create it by executing `mkdir $HOME/src`.

Once everything looks good, execute the following:

```bash
make
```

The invoked `make` target runs an idempotent-ish bootstrap script.
Thus, you should be able to execute it multiple times, as desired.
That being said: *caution is advised*.
Running the `make` target may overwrite files if you are coming from an existing configuration.
Please read the source code, starting from the [Makefile](./Makefile), before execution.

## Platform Notes

These dotfiles require neither [`oh-my-zsh`](https://ohmyz.sh/) nor [`starship`](https://starship.rs/) to be installed.
Only `zsh` needs to be installed as all shell-based dotfiles are custom and configured manually.
That being said, if `starship` is installed, it will use the configuration file linked to `$HOME/.config/starship.toml`.

While most Linux distros can use these dotfiles, only hand-selected distros have advanced bootstrapping options.
Advanced bootstrapping options are available via the interactive installer.

WSL2 is supported, but advanced bootstrapping options from the interactive installer will likely be blocked.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
