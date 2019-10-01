REPO:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# ALL INSTALL TARGETS.
install-fish:
	mkdir -p $(HOME)/.config/fish
	cp $(REPO)/config.fish $(HOME)/.config/fish

install-zsh:
	cp $(REPO)/zshrc $(HOME)/.zshrc

install-ohmyzsh:
	cp $(REPO)/ohmyzsh/ohmyzshrc $(HOME)/.oh-my-zsh/themes/
	mkdir -p $(HOME)/.oh-my-zsh/themes
	cp $(REPO)/zsh/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/

install-vim:
	cp $(REPO)/vimrc $(HOME)/.vimrc
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

install-aliases:
	cp $(REPO)/aliases.sh $(HOME)/.aliases.sh

intsall-extras:
	cp -r $(REPO)/extra $(HOME)/.extra

# ALL PUSH TARGETS.
push-main:
	cp $(HOME)/.aliases.sh $(REPO)/aliases.sh
	cp $(HOME)/.vimrc $(REPO)/vimrc
	cp -r $(HOME)/.extra $(REPO)/extra/

push-fish:
	cp $(HOME)/.config/fish/config.fish $(REPO)/config.fish

push-zsh:
	cp $(HOME)/.zshrc $(REPO)/zshrc

push-ohmyzsh:
	cp $(HOME)/.zshrc $(REPO)/ohmyzsh/ohmyzshrc
	cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(REPO)/ohmyzsh/
