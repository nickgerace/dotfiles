# Dotfiles

![zsh](https://img.shields.io/badge/zsh-black?style=for-the-badge&logo=zsh)
![linux](https://img.shields.io/badge/linux-black?style=for-the-badge&logo=linux)
![fedora](https://img.shields.io/badge/fedora-black?style=for-the-badge&logo=fedora)
![arch-linux](https://img.shields.io/badge/arch_linux-black?style=for-the-badge&logo=archlinux)
![pop-os](https://img.shields.io/badge/pop!__os-black?style=for-the-badge&logo=popos)
![nix-nixos](https://img.shields.io/badge/nix_/_nixos-black?style=for-the-badge&logo=nixos)
![darwin-macos](https://img.shields.io/badge/darwin_\(macos\)-black?style=for-the-badge&logo=apple)

A collection of dotfiles, scripts and configurations from [@nickgerace](https://github.com/nickgerace).

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

## Updating

Once the initial `make` target is ran, you can update packages and more using the `update` target.

```bash
make update
```

Alternatively, if you run `sz` or reload your shell, you can run the [update function](zsh/update.zsh).

```bash
update
```

> [!NOTE]
> The above commands only update packages with the current dotfiles in place.
> If you'd like to re-link dotfiles, run the default `make` target again.

## Q&A

This section contains questions and answers regarding these dotfiles.

### What interactive shell do the dotfiles rely on?

These dotfiles rely on [`zsh`](https://www.zsh.org/) as the interactive shell.

### What about `oh-my-zsh` and `starship`?

These dotfiles require neither [`oh-my-zsh`](https://ohmyz.sh/) nor [`starship`](https://starship.rs/) to be installed.
Only `zsh` needs to be installed as all shell-based dotfiles are custom and configured manually.

### Does the `make` target do more than setup dotfiles?

The script only sets up dotfiles by default.
However, for certain Linux distributions and macOS, you can optionally install packages and setup the base system (e.g. install an opinionated set of base packages with a package manager).
This is referred to "bootstrapping" in the script.

### Is WSL2 supported?

[WSL2](https://learn.microsoft.com/en-us/windows/wsl/) is supported for dotfiles setup, but packages will not be installed for supported distros when running the installer.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
