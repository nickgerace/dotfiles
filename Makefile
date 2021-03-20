MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: neovim-theme-update
	cp $(MAKEPATH)/.zshrc $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	cp $(MAKEPATH)/init.vim $(HOME)/.config/nvim/

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/

neovim-theme-update:
	-mkdir -p $(HOME)/.config/nvim/colors/
	-rm $(HOME)/.config/nvim/colors/one.vim
	curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -o $(HOME)/.config/nvim/colors/one.vim
