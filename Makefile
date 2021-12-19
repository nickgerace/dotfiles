MAKEPATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GIT_USER_NAME := "Nick Gerace"

.DEFAULT_GOAL := bootstrap

bootstrap: download-neovim-theme configure-git
	@-rm $(HOME)/.zshrc
	ln -s $(MAKEPATH)/zshrc $(HOME)/.zshrc
	@-rm $(HOME)/.tmux.conf
	ln -s $(MAKEPATH)/tmux.conf $(HOME)/.tmux.conf
	@-rm $(HOME)/.config/nvim/init.vim
	@-mkdir -p $(HOME)/.config/nvim/
	ln -s $(MAKEPATH)/init.vim $(HOME)/.config/nvim/init.vim

download-neovim-theme:
	@-mkdir -p $(HOME)/.config/nvim/colors/
	@-rm $(HOME)/.config/nvim/colors/one.vim
	curl https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim \
		-so $(HOME)/.config/nvim/colors/one.vim

configure-git:
	git config --global pull.rebase true
	git config --global user.name $(GIT_USER_NAME)