MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: neovim-theme
	-mkdir -p $(HOME)/.config/nvim/colors/
	-mkdir -p $(HOME)/.config/alacritty/
	ln -s $(MAKEPATH)/zshrc $(HOME)/.zshrc
	ln -s $(MAKEPATH)/tmux.conf $(HOME)/.tmux.conf
	ln -s $(MAKEPATH)/init.vim $(HOME)/.config/nvim/init.vim
	ln -s $(MAKEPATH)/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml

neovim-theme:
	-rm $(HOME)/.config/nvim/colors/one.vim
	curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim \
		-o $(HOME)/.config/nvim/colors/one.vim
