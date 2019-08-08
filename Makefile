push:
	cp ~/.zshrc .
	cp ~/.vimrc .
	cp ~/.aliases.bash .
	cp -r ~/.extra .
	cp ~/.oh-my-zsh/themes/nickgerace.zsh-theme .oh-my-zsh/themes/

install:
	cp . ~/.zshrc
	cp . ~/.vimrc
	cp . ~/.aliases.bash .
	cp -r ~/.extra .
	cp .oh-my-zsh/themes/ ~/.oh-my-zsh/themes/nickgerace.zsh-theme
