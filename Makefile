REPO:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIM:=$(REPO)/main/vimrc
FISH:=$(REPO)/main/config.fish
ALIAS:=$(REPO)/main/aliases.sh

push:
	cp $(HOME)/.vimrc $(VIM)
	cp $(HOME)/.config/fish/config.fish $(FISH)
	cp $(HOME)/.aliases.sh $(ALIAS)
	cp $(HOME)/.zshrc $(REPO)/zsh/zshrc
	cp -r $(HOME)/.extra $(REPO)/extra/
	cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(REPO)/zsh/

task-fish:
	mkdir -p $(HOME)/.config/fish
	cp $(FISH) $(HOME)/.config/fish

task-zsh:
	cp $(REPO)/zsh/zshrc $(HOME)/.zshrc
	mkdir -p $(HOME)/.oh-my-zsh/themes
	cp $(REPO)/zsh/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/

task-vim:
	cp $(VIM) $(HOME)/.vimrc
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

task-aliases:
	cp $(ALIAS) $(HOME)/.aliases.sh

task-extras:
	cp -r $(REPO)/extra $(HOME)/.extra

install-fish: task-fish task-vim task-aliases

install-zsh: task-zsh task-vim task-aliases

install-all: task-fish task-zsh task-vim task-aliases task-extras
