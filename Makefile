REPO:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install-all: install-bash install-vim

install-bash:
	cp $(REPO)/.aliases.bash $(HOME)/
	cp $(REPO)/.bashrc $(HOME)/
	cp $(REPO)/.bash_profile $(HOME)/

install-vim:
	cp $(REPO)/.vimrc $(HOME)/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

ubuntu-sources:
	cp $(REPO)/ubuntu/sources.list /etc/apt/sources.list

debian-unstable-sources:
	cp $(REPO)/debian-unstable/sources.list /etc/apt/sources.list

push:
	cp $(HOME)/.aliases.bash $(REPO)/
	cp $(HOME)/.vimrc $(REPO)/
	cp $(HOME)/.bashrc $(REPO)/
	cp $(HOME)/.bash_profile $(REPO)/
