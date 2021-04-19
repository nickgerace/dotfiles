MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: prepare neovim-theme
	-rm $(HOME)/.zshrc
	ln -s $(MAKEPATH)/zshrc $(HOME)/.zshrc
	-rm $(HOME)/.tmux.conf
	ln -s $(MAKEPATH)/tmux.conf $(HOME)/.tmux.conf
	-rm $(HOME)/.config/nvim/init.vim
	ln -s $(MAKEPATH)/init.vim $(HOME)/.config/nvim/init.vim
	-rm $(HOME)/.config/alacritty/alacritty.yml
	ln -s $(MAKEPATH)/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml

prepare:
	-mkdir -p $(HOME)/.config/nvim/colors/
	-mkdir -p $(HOME)/.config/alacritty/

neovim-theme:
	-rm $(HOME)/.config/nvim/colors/one.vim
	curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim \
		-o $(HOME)/.config/nvim/colors/one.vim
