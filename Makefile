MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: neovim-theme-update
	cp $(MAKEPATH)/.zshrc $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	cp $(MAKEPATH)/init.vim $(HOME)/.config/nvim/

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/

darwin-install:
	xargs brew install < $(MAKEPATH)/packages/brew-packages
	xargs brew install --cask < $(MAKEPATH)/packages/brew-casks

neovim-theme-update:
	-mkdir -p $(HOME)/.config/nvim/colors/
	-rm $(HOME)/.config/nvim/colors/one.vim
	wget https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -P $(HOME)/.config/nvim/colors/