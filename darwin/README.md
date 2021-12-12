# Setting Up a macOS Machine

Follow these steps (in order) to set up a macOS machine.

## Prepare OS

- Download all OS updates
- Install XCode (full GUI app) from the App Store
  - This will install the command line tools package needed for everything else
- Install browser of choice (and set to default) or continue using Safari

## Install Homebrew

Navigate to [brew.sh](https://brew.sh) and install it.
After installation, you may need to execute `eval "$(/opt/homebrew/bin/brew shellenv)"` to get `brew` in your `PATH`.

Finally, install some base packages with `brew`:

```sh
brew install zsh git bash make jq neovim vim curl wget
```

## Setup Dotfiles

Clone the [dotfiles](https://github.com/nickgerace/dotfiles) and get started with the `Makefile`.
Use `zsh` from `brew` as our default shell:

```sh
ZSH=$(command -v zsh)
echo ${ZSH} | sudo tee -a /etc/shells
chsh -s ${ZSH}
```

Now, install the previous `Brewfile`.

```sh
brew bundle install --no-lock --file $NICK_DOTFILES/darwin/brewfile-$NICK_ARCH.rb
```

## Setup Rust

Execute the following command from [rustup.sh](https://rustup.sh):

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
```

With the dotfiles loaded and `zsh` as your shell, execute the loaded function: `rust-setup`
