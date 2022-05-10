MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GIT_USER_NAME:="Nick Gerace"

UNAME:=$(shell uname -s)

VSCODE:="$(HOME)/.config/Code/User"
ALACRITTY:=linux.yml
GFOLD:=linux.toml
ifeq ("$(UNAME)", "Darwin")
	VSCODE:="$(HOME)/Library/Application Support/Code/User"
	ALACRITTY:=darwin.yml
	GFOLD:=darwin.toml
endif

.DEFAULT_GOAL:=all

all:
	git config --global pull.rebase true
	git config --global user.name $(GIT_USER_NAME)

	@-rm $(HOME)/.zshrc
	ln -s $(MAKEPATH)/zshrc $(HOME)/.zshrc

	@-rm $(HOME)/.tmux.conf
	ln -s $(MAKEPATH)/tmux.conf $(HOME)/.tmux.conf

	@-mkdir -p $(HOME)/.config/nvim/
	@-rm $(HOME)/.config/nvim/init.lua
	ln -s $(MAKEPATH)/init.lua $(HOME)/.config/nvim/init.lua

	@-mkdir -p $(HOME)/.cargo/
	@-rm $(HOME)/.cargo/config.toml
	ln -s $(MAKEPATH)/config.toml $(HOME)/.cargo/config.toml

	@-mkdir -p $(HOME)/.config/
	@-rm $(HOME)/.config/starship.toml
	ln -s $(MAKEPATH)/starship.toml $(HOME)/.config/starship.toml

	@-mkdir -p $(HOME)/.config/alacritty/
	@-rm $(HOME)/.config/alacritty/alacritty.yml
	ln -s $(MAKEPATH)/alacritty/$(ALACRITTY) $(HOME)/.config/alacritty/alacritty.yml

	@-mkdir -p $(HOME)/.config/
	@-rm $(HOME)/.config/gfold.toml
	ln -s $(MAKEPATH)/gfold/$(GFOLD) $(HOME)/.config/gfold.toml

install-crates:
	xargs cargo install --locked < $(MAKEPATH)/crates.txt

vscode:
	@-rm $(VSCODE)/keybindings.json
	ln -s $(MAKEPATH)/vscode/keybindings.json $(VSCODE)/keybindings.json
.PHONY: vscode
