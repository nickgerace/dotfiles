# Dotfiles

[![Helix](https://img.shields.io/badge/Helix-EFF1F5?style=for-the-badge&logo=helix&logoColor=4c4f69)](https://helix-editor.com/)
[![Nushell](https://img.shields.io/badge/Nushell-EFF1F5?style=for-the-badge&logo=nushell&logoColor=4c4f69)](https://nushell.sh/)
[![Ghostty](https://img.shields.io/badge/Ghostty-EFF1F5?style=for-the-badge&logo=ghostty&logoColor=4c4f69)](https://ghostty.org/)
[![jj](https://img.shields.io/badge/Jujutsu_(jj)-EFF1F5?style=for-the-badge&logoColor=4c4f69)](https://jj-vcs.dev/)
[![Iosevka](https://img.shields.io/badge/Iosevka-EFF1F5?style=for-the-badge&logoColor=4c4f69)](https://typeof.net/Iosevka/)

[![Catppuccin Latte](https://github.com/catppuccin/catppuccin/blob/main/assets/palette/latte.png)](https://catppuccin.com/)

A collection of dotfiles, scripts and configurations from [@nickgerace](https://github.com/nickgerace).

## Quickstart

Before starting, ensure that you have the following installed on your macOS or Linux system:

- `bash`
- `just`
- `nu` _(see the tip below)_

> [!TIP]
> If you are on macOS, have `brew` installed and want to install packages when setting up dotfiles, you do not need to install `nu`.
> It will be installed during setup.

You will also need to ensure that this repository resides in the `$HOME/src/` directory.
You may need to create it by executing `mkdir $HOME/src`.

> [!WARNING]
> Running the following command may overwrite files if you are coming from an existing configuration.
> Please read the source code, starting from the [justfile](justfile), before executing the recipe.

Once everything looks good, run the installer.
By default, it will only install dotfiles and load configurations based on them.
Depending on your platform, you may be presented with an option to install packages and perform additional setup.
That is entirely optional.

```bash
just install
```

The invoked `just` recipe runs an idempotent-ish bootstrap script, so you should be able to execute it multiple times.
That being said: *caution is advised*.

## Updating

Once the initial `just` recipe is ran, you can update packages and more using the `update` recipe.

```bash
just update
```

Alternatively, if you reload your shell, you can use the provided alias that runs the same script under the hood.

```bash
update
```

> [!NOTE]
> The above commands only update packages with the current dotfiles in place.
> If you'd like to re-link dotfiles, run `just install` again.

## Theme

- **Current:** [Catppuccin Latte](https://catppuccin.com) (Light)
- **Alternative:** [Catppuccin Mocha](https://catppuccin.com) (Dark)

This is a list of relevant tools who are reliant on the theme:

- `bat`
- `fastfetch`
- `ghostty`
- `helix`
- `jj`
- `mise` _(no official support [yet](https://github.com/jdx/mise/discussions/8542), but may need to switch based one theme)_

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
