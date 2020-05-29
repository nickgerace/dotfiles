# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEPATH)/makefiles/distros.mk
include $(MAKEPATH)/makefiles/editors.mk

install:
	cp $(MAKEPATH)/zsh/.zshrc $(HOME)/
	cp $(MAKEPATH)/tmux/.tmux.conf $(HOME)/
	cp $(MAKEPATH)/vim/.vimrc $(HOME)/
	-mkdir -p $(HOME)/.oh-my-zsh/themes/
	cp $(MAKEPATH)/zsh/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/zsh/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/tmux/
	-cp $(HOME)/.vimrc $(MAKEPATH)/vim/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/nvim/
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/vs-code/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(MAKEPATH)/zsh/

cargo:
	cargo install \
		exa \
		ripgrep \
		fd-find \
		ytop \
		bat
	cargo install --git https://github.com/nickgerace/gfold
	@printf "Should probably publish gfold to crates.io at some point...\n"

