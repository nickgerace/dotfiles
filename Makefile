MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: prepare-paths neovim-theme-update
	cp $(MAKEPATH)/.zshrc $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	cp $(MAKEPATH)/init.vim $(HOME)/.config/nvim/
	cp $(MAKEPATH)/alacritty.yml $(HOME)/.config/alacritty/

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/
	-cp $(HOME)/.config/alacritty/alacritty.yml $(MAKEPATH)/

pre-install:
	-mkdir -p $(HOME)/.config/nvim/colors/
	-mkdir -p $(HOME)/.config/alacritty/

neovim-theme-update:
	-rm $(HOME)/.config/nvim/colors/one.vim
	curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -o $(HOME)/.config/nvim/colors/one.vim
