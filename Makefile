DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

push:
	cp $(HOME)/.zshrc $(DIR)/
	cp $(HOME)/.vimrc $(DIR)/
	cp $(HOME)/.aliases.sh $(DIR)/
	cp -r $(HOME)/.extra $(DIR)/
	cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(DIR)/.oh-my-zsh/themes/

install-fish:
	mkdir -p $(HOME)/.config/fish
	cp $(DIR)/.aliases.sh $(HOME)/.config/fish/aliases.fish

install-zsh:
	cp $(DIR)/.zshrc $(HOME)/
	cp $(DIR)/.aliases.sh $(HOME)/
	mkdir -p $(HOME)/.oh-my-zsh/themes
	cp $(DIR)/.oh-my-zsh/themes/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/

install-vim:
	cp $(DIR)/.vimrc $(HOME)/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

install-extras:
	cp -r $(DIR)/.extra $(HOME)/

install-minimal-fish: install-fish install-vim

install-minimal-zsh: install-zsh install-vim

install-all: install-fish install-zsh install-vim install-extras
