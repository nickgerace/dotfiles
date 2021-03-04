MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

neovim-theme-upstream:
	-rm $(MAKEPATH)/one.vim
	wget https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -P $(MAKEPATH)/
