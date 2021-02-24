MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install:
	cp $(MAKEPATH)/.zshrc $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	-mkdir -p $(HOME)/.config/nvim/
	cp $(MAKEPATH)/init.vim $(HOME)/.config/nvim/

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/
