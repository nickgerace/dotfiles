# Dotfiles

[![zsh](https://img.shields.io/badge/zsh-black?style=for-the-badge&logo=zsh)](https://zsh.org/)
[![helix](https://img.shields.io/badge/helix-black?style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbDpzcGFjZT0icHJlc2VydmUiIHN0eWxlPSJmaWxsLXJ1bGU6ZXZlbm9kZDtjbGlwLXJ1bGU6ZXZlbm9kZDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MiIgdmlld0JveD0iNjYzLjM4IDM3LjU3IDU3NS4zNSA5MDMuNzUiPjxwYXRoIGQ9Im0xMDgzLjU4IDE4NzUuNzIgNTUxLjQ4IDMxOC40YTQ3LjY2IDQ3LjY2IDAgMCAxIDIzLjgyIDQxLjI3djEwNS45NGMwIDguNTEtMi4yNyAxNi43LTYuMzggMjMuODMgMCAwLTQzNy44LTI1Mi43Ni01NDUuMy0zMTQuODNhNDcuMjQ1IDQ3LjI0NSAwIDAgMS0yMy42Mi00MC45MnoiIHN0eWxlPSJmaWxsOiM3MDZiYzgiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC00MjAuMTczIC0xODM4LjE0NSkiLz48cGF0aCBkPSJNMTYzNS4yNiAyNjA0Ljg0YTQ3LjIyOCA0Ny4yMjggMCAwIDEgMjMuNjIgNDAuOTF2MTMzLjY5bC01NTEuNDctMzE4LjM5YTQ3LjY2IDQ3LjY2IDAgMCAxLTIzLjgzLTQxLjI3di0xMDUuOTRjMC04LjUyIDIuMjctMTYuNzEgNi4zOC0yMy44MyAwIDAgNDM3LjggMjUyLjc2IDU0NS4zIDMxNC44MyIgc3R5bGU9ImZpbGw6IzU1YzVlNCIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTQyMC4xNzMgLTE4MzguMTQ1KSIvPjxwYXRoIGQ9Ik03OTAuNDA3IDE0MzIuNTZhMzUuMDMzIDM1LjAzMyAwIDAgMC0xMi44OTggMTIuOWMtOS42NDcgMTYuNy00LjAzNiAzOC4zIDEyLjQ5NSA0OC4xM2gtLjAwNmwtMjguODI1LTE2LjY0YTQ3LjY0NCA0Ny42NDQgMCAwIDEtMjMuODI5LTQxLjI3di0xMDUuOTRjMC0xNy4wMyA5LjA4My0zMi43NiAyMy44MjktNDEuMjdsNDk4LjQxNy0yODcuNzMuMjQtLjE0YTM0Ljk2MiAzNC45NjIgMCAwIDAgMTIuNjUtMTIuNzU2YzkuNjUtMTYuNzA4IDQuMDQtMzguMy0xMi40OS00OC4xMzdoLjAxbDI4LjgyIDE2LjY0MmE0Ny42NDggNDcuNjQ4IDAgMCAxIDIzLjgzIDQxLjI3M3YxMDUuOTM4YzAgMTcuMDMtOS4wOCAzMi43Ni0yMy44MyA0MS4yN2wtMjkuNjMgMTcuMTEuNC0uMjZ6IiBzdHlsZT0iZmlsbDojODRkZGVhIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNzMuOTM4IC04NTQuMDUpIi8+PHBhdGggZD0iTTc5MC40MDcgMTY4Ni4yNGEzNS4wOCAzNS4wOCAwIDAgMC0xMi44OTggMTIuODljLTkuNjQ3IDE2LjcxLTQuMDM2IDM4LjMgMTIuNDk1IDQ4LjE0aC0uMDA2bC0yOC44MjUtMTYuNjRhNDcuNjU2IDQ3LjY1NiAwIDAgMS0yMy44MjktNDEuMjd2LTEwNS45NGMwLTE3LjAzIDkuMDgzLTMyLjc2IDIzLjgyOS00MS4yN2w0OTguNDE3LTI4Ny43My4yNC0uMTRjNS4wOS0yLjk5IDkuNS03LjI5IDEyLjY1LTEyLjc2IDkuNjUtMTYuNzEgNC4wNC0zOC4zLTEyLjQ5LTQ4LjE0aC4wMWwyOC44MiAxNi42NWE0Ny42MzYgNDcuNjM2IDAgMCAxIDIzLjgzIDQxLjI3djEwNS45NGMwIDE3LjAyLTkuMDggMzIuNzYtMjMuODMgNDEuMjdsLTI5LjYzIDE3LjEuNC0uMjV6IiBzdHlsZT0iZmlsbDojOTk3YmM4IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNzMuOTM4IC04NTQuMDUpIi8+PC9zdmc+)](https://helix-editor.com/)

A collection of dotfiles, scripts and configurations from [@nickgerace](https://github.com/nickgerace).

## Quickstart

Before starting, ensure that `bash` and `just` are installed on your macOS or Linux system.
The "install" recipe will install `zsh` if you opt to install packages, so it is not required to start.

> [!TIP]
> You can use the `devShell` from the [flake](flake.nix) to get the base depedencies.

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
However, for certain Linux distributions and macOS, you can optionally install packages and setup the base system (e.g. install an opinionated set of base packages with a package manager).
This is referred to "bootstrapping" in the script.

### Is WSL2 supported?

[WSL2](https://learn.microsoft.com/en-us/windows/wsl/) is supported for dotfiles setup, but packages will not be installed for supported distros when running the installer.

## Disclaimer

Files not recently in use may be out of date.
This is a "living" repository, meaning that scripts and dotfiles more frequently in use will be more likely to be kept up to date.
Anything not recently or frequently in use will be removed from the repository (eventually).
