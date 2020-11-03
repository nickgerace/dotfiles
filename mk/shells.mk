# DOTFILES
# https://nickgerace.dev

.PHONY: bash
bash:
	cp $(MAKEPATH)/.profile $(HOME)/
	cp $(MAKEPATH)/.bashrc $(HOME)/
	-mkdir -p $(HOME)/.config/bash/
	cp -r $(MAKEPATH)/.config/bash/ $(HOME)/.config/bash/

.PHONY: tmux
tmux:
	cp $(MAKEPATH)/.tmux.conf $(HOME)/

