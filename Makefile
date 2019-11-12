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

install-ubuntu-sources:
	cp $(REPO)/ubuntu/sources.list /etc/apt/sources.list

install-debian-unstable-sources:
	cp $(REPO)/debian-unstable/sources.list /etc/apt/sources.list

push:
	cp $(HOME)/.aliases.bash $(REPO)/
	cp $(HOME)/.vimrc $(REPO)/
	cp $(HOME)/.bashrc $(REPO)/
	cp $(HOME)/.bash_profile $(REPO)/

push-ubuntu-sources:
	cp /etc/apt/sources.list $(REPO)/ubuntu/sources.list

push-debian-unstable-sources:
	cp /etc/apt/sources.list $(REPO)/debian-unstable/sources.list
