# DOTFILES
# https://nickgerace.dev

.PHONY: zsh
zsh:
	cp $(MAKEPATH)/.zshrc $(HOME)/
	-mkdir -p $(HOME)/.config/zsh/
	cp -r $(MAKEPATH)/.config/zsh/ $(HOME)/.config/zsh/

.PHONY: tmux
tmux:
	cp $(MAKEPATH)/.tmux.conf $(HOME)/

