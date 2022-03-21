MAKEPATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GIT_USER_NAME := "Nick Gerace"

.DEFAULT_GOAL := all

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

	@-mkdir -p $(HOME)/.config/alacritty/
	@-rm $(HOME)/.config/alacritty/alacritty.yml
	ln -s $(MAKEPATH)/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml

install-crates:
	xargs cargo install --locked < $(MAKEPATH)/crates.txt
