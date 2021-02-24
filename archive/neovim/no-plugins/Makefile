MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPOPATH:=$(shell dirname $(shell dirname $(MAKEPATH)))

neovim-theme-upstream:
	-rm $(REPOPATH)/nvim/one.vim
	cd $(REPOPATH)/nvim/; wget https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim

neovim-coc-installs:
	-nvim +"CocInstall coc-rust-analyzer" +qall

