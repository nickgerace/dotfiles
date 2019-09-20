DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

push:
	cp $(HOME)/.zshrc $(DIR)/
	cp $(HOME)/.vimrc $(DIR)/
	cp $(HOME)/.aliases.zsh $(DIR)/
	cp -r $(HOME)/.extra $(DIR)/
	cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(DIR)/.oh-my-zsh/themes/

install-all:
	cp $(DIR)/.zshrc $(HOME)/
	cp $(DIR)/.vimrc $(HOME)/
	cp $(DIR)/.aliases.zsh $(HOME)/
	cp -r $(DIR)/.extra $(HOME)/
	mkdir -p $(HOME)/.oh-my-zsh/themes
	cp $(DIR)/.oh-my-zsh/themes/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/

install-minimal:
	cp $(DIR)/.zshrc $(HOME)/
	cp $(DIR)/.vimrc $(HOME)/
	cp $(DIR)/.aliases.zsh $(HOME)/
	mkdir -p $(HOME)/.oh-my-zsh/themes
	cp $(DIR)/.oh-my-zsh/themes/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/
