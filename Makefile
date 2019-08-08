push:
	cp ~/.zshrc .
	cp ~/.vimrc .
	cp ~/.aliases.zsh .
	cp -r ~/.extra .
	cp ~/.oh-my-zsh/themes/nickgerace.zsh-theme .oh-my-zsh/themes/

install:
	cp .zshrc ~/
	cp .vimrc ~/
	cp .aliases.zsh ~/
	cp -r .extra ~/
	mkdir -p ~/.oh-my-zsh/themes
	cp .oh-my-zsh/themes/nickgerace.zsh-theme ~/.oh-my-zsh/themes/
