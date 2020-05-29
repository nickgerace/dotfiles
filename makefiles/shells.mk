# DOTFILES
# https://nickgerace.dev

.PHONY: zsh
zsh:
	cp $(MAKEPATH)/zsh/.zshrc $(HOME)/
	-mkdir -p $(HOME)/.oh-my-zsh/themes/
	cp $(MAKEPATH)/zsh/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/

.PHONY: tmux
tmux:
	cp $(MAKEPATH)/tmux/.tmux.conf $(HOME)/

