# DOTFILES
# https://nickgerace.dev

# Path to this repository.
MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# All Node related variables. These are for VIM plugins.
NODE_VERSION:=v12.16.1
NODE_VERSION_FULL:=node-$(NODE_VERSION)-linux-x64
NODE_FILE:=$(NODE_VERSION_FULL).tar.xz
NODE_LOCATION:=/usr/local

###################################################################################################
# PRIMARY TARGETS
###################################################################################################
install: message main vim

push:
	cp $(HOME)/.vimrc $(MAKEPATH)/
	cp $(HOME)/.bashrc $(MAKEPATH)/
	cp $(HOME)/.bash_profile $(MAKEPATH)/
	cp $(HOME)/.tmux.conf $(MAKEPATH)/

###################################################################################################
# SUB TARGETS
###################################################################################################
message:
	@printf "Must have the following installed...\n"
	@printf "  [ vim | curl | wget | bash | tmux | tar ]\n"

main:
	cp $(MAKEPATH)/.bashrc $(HOME)/
	cp $(MAKEPATH)/.bash_profile $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/

vim: vim-pre-node vim-post-node

vim-post-node:
	cp $(MAKEPATH)/.vimrc $(HOME)/
	export PATH=$(PATH):$(NODE_LOCATION)
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

vim-pre-node:
	@printf "We need NodeJS installed for vim plug(s) to work...\n"
	cd $(MAKEPATH); wget https://nodejs.org/dist/$(NODE_VERSION)/$(NODE_FILE)
	sudo tar -xJvf $(MAKEPATH)/$(NODE_FILE) -C $(NODE_LOCATION)
	sudo mv $(NODE_LOCATION)/$(NODE_VERSION_FULL) $(NODE_LOCATION)/nodejs
	rm $(MAKEPATH)/$(NODE_FILE)

###################################################################################################
# TEST TARGETS
###################################################################################################
test-dotfiles:
	cd $(MAKEPATH); docker build -f test/Dockerfile -t test-dotfiles .

docker-install: message main docker-vim

docker-vim: docker-node vim-post-node

docker-node:
	@printf "We need NodeJS installed for vim plug(s) to work...\n"
	cd $(MAKEPATH); wget https://nodejs.org/dist/$(NODE_VERSION)/$(NODE_FILE)
	tar -xJvf $(MAKEPATH)/$(NODE_FILE) -C $(NODE_LOCATION)
	mv $(NODE_LOCATION)/$(NODE_VERSION_FULL) $(NODE_LOCATION)/nodejs
	rm $(MAKEPATH)/$(NODE_FILE)
