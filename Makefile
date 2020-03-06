# DOTFILES
# https://nickgerace.dev

# All variables for Make targets.
MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
NEOVIM_PATH:=$(HOME)/local
NEOVIM_VERSION:=v0.4.3

# All Make targets.
install: dotfiles neovim

dotfiles:
	cp $(MAKEPATH)/.bashrc $(HOME)/
	cp $(MAKEPATH)/.profile $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	mkdir -p $(HOME)/.config/nvim/
	cp $(MAKEPATH)/init.vim $(HOME)/.config/nvim/

neovim: download plugs

download:
	-rm -r $(NEOVIM_PATH)/nvim
	cd $(MAKEPATH); wget https://github.com/neovim/neovim/releases/download/$(NEOVIM_VERSION)/nvim-linux64.tar.gz
	cd $(MAKEPATH); tar -xzf nvim-linux64.tar.gz
	mkdir -p $(NEOVIM_PATH)
	mv $(MAKEPATH)/nvim-linux64 $(NEOVIM_PATH)/nvim
	-rm $(MAKEPATH)/nvim-linux64.tar.gz

plugs:
	-if ! [ -f $(HOME)/.local/share/nvim/site/autoload/plug.vim ]; then curl -fLo $(HOME)/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; fi
	$(NEOVIM_PATH)/nvim/bin/nvim +PlugInstall +qall

push:
	-cp $(HOME)/.bashrc $(MAKEPATH)/
	-cp $(HOME)/.profile $(MAKEPATH)/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/

docker-test:
	cd $(MAKEPATH); docker build -f test/Dockerfile -t test-dotfiles .

docker-test-interactive: docker-test
	docker run -it --entrypoint /bin/bash test-dotfiles

# OPTIONAL: All Node related targets for installing the coc.vim extension.
#
# All Node related variables.
# NODE_VERSION:=v12.16.1
# NODE_VERSION_FULL:=node-$(NODE_VERSION)-linux-x64
# NODE_FILE:=$(NODE_VERSION_FULL).tar.xz
# NODE_LOCATION:=/usr/local
#
# node:
# 	@printf "We need NodeJS installed for vim plug(s) to work...\n"
# 	cd $(MAKEPATH); wget https://nodejs.org/dist/$(NODE_VERSION)/$(NODE_FILE)
# 	sudo tar -xJvf $(MAKEPATH)/$(NODE_FILE) -C $(NODE_LOCATION)
# 	sudo mv $(NODE_LOCATION)/$(NODE_VERSION_FULL) $(NODE_LOCATION)/nodejs
# 	rm $(MAKEPATH)/$(NODE_FILE)
# 
# docker-node:
# 	@printf "We need NodeJS installed for vim plug(s) to work...\n"
# 	cd $(MAKEPATH); wget https://nodejs.org/dist/$(NODE_VERSION)/$(NODE_FILE)
# 	tar -xJvf $(MAKEPATH)/$(NODE_FILE) -C $(NODE_LOCATION)
# 	mv $(NODE_LOCATION)/$(NODE_VERSION_FULL) $(NODE_LOCATION)/nodejs
# 	rm $(MAKEPATH)/$(NODE_FILE)
