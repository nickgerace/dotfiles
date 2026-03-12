# Dotfiles

A collection of dotfiles, scripts and configurations from [@nickgerace](https://github.com/nickgerace).

## Quickstart

Before starting, ensure that `bash` and `just` are installed on your macOS or Linux system.
If you are on macOS, have `brew` installed and want to install packages when setting up dotfiles, you do not need to install `zsh`.
Otherwise, you also need to install `zsh`.

You will also need to ensure that this repository resides in the `$HOME/src/` directory.
You may need to create it by executing `mkdir $HOME/src`.

> [!WARNING]
> Running the following command may overwrite files if you are coming from an existing configuration.
> Please read the source code, starting from the [justfile](justfile), before executing the recipe.

Once everything looks good, execute the following and you will be presented with some options that you'll need to choose:

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

Alternatively, if you run `sz` or reload your shell, you can run the [update function](zsh/update.zsh).

```bash
update
```

> [!NOTE]
> The above commands only update packages with the current dotfiles in place.
> If you'd like to re-link dotfiles, run `just install` again.

## Q&A

This section contains questions and answers regarding these dotfiles.

### What interactive shell do the dotfiles rely on?

These dotfiles rely on [`zsh`](https://www.zsh.org/) as the interactive shell.

### What about `oh-my-zsh` and `starship`?

These dotfiles require neither [`oh-my-zsh`](https://ohmyz.sh/) nor [`starship`](https://starship.rs/) to be installed.
Only `zsh` needs to be installed as all shell-based dotfiles are custom and configured manually.

### Does the `just` recipe do more than setup dotfiles?

The script only sets up dotfiles by default.
However, you can optionally install packages and setup the base system (e.g. install an opinionated set of base packages with a package manager) if the option is provided in the script.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
