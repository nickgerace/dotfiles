MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install:
	cp $(MAKEPATH)/.aliases.bash $(HOME)/
	cp $(MAKEPATH)/.bashrc $(HOME)/
	cp $(MAKEPATH)/.bash_profile $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	cp $(MAKEPATH)/.gitconfig $(HOME)/
	cp $(MAKEPATH)/.vimrc $(HOME)/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

push:
	cp $(HOME)/.aliases.bash $(MAKEPATH)/
	cp $(HOME)/.vimrc $(MAKEPATH)/
	cp $(HOME)/.bashrc $(MAKEPATH)/
	cp $(HOME)/.bash_profile $(MAKEPATH)/
	cp $(HOME)/.tmux.conf $(MAKEPATH)/
	cp $(HOME)/.gitconfig $(MAKEPATH)/
