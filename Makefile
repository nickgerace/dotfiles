MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install-all: install-bash install-vim install-tmux

install-bash:
	cp $(MAKEPATH)/.aliases.bash $(HOME)/
	cp $(MAKEPATH)/.bashrc $(HOME)/
	cp $(MAKEPATH)/.bash_profile $(HOME)/

install-vim:
	cp $(MAKEPATH)/.vimrc $(HOME)/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

install-tmux:
	cp $(MAKEPATH)/.tmux.conf $(HOME)/

install-sources:
	cp $(MAKEPATH)/ubuntu/sources.list /etc/apt/sources.list

push:
	cp $(HOME)/.aliases.bash $(MAKEPATH)/
	cp $(HOME)/.vimrc $(MAKEPATH)/
	cp $(HOME)/.bashrc $(MAKEPATH)/
	cp $(HOME)/.bash_profile $(MAKEPATH)/
	cp $(HOME)/.tmux.conf $(MAKEPATH)/

push-sources:
	cp /etc/apt/sources.list $(MAKEPATH)/ubuntu/sources.list
