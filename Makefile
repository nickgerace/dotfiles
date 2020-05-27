# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CURRENT:=$(MAKEPATH)/current

include $(MAKEPATH)/makefiles/distros.mk
include $(MAKEPATH)/makefiles/editors.mk

install:
	cp $(CURRENT)/.zshrc $(HOME)/
	cp $(CURRENT)/.tmux.conf $(HOME)/
	cp $(CURRENT)/.vimrc $(HOME)/
	-mkdir -p $(HOME)/.oh-my-zsh/themes/
	cp $(CURRENT)/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/
	@printf "\nNow, install oh-my-zsh: https://ohmyz.sh/\n"

push:
	-cp $(HOME)/.zshrc $(CURRENT)/
	-cp $(HOME)/.tmux.conf $(CURRENT)/
	-cp $(HOME)/.vimrc $(CURRENT)/
	-cp $(HOME)/.config/Code/User/settings.json $(CURRENT)/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(CURRENT)/

cargo:
	cargo install \
		exa \
		ripgrep \
		fd-find \
		ytop \
		bat
	cargo install --git https://github.com/nickgerace/gfold
	@printf "Should probably publish gfold to crates.io at some point...\n"

