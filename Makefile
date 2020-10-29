# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEPATH)/mk/apt.mk
include $(MAKEPATH)/mk/dnf.mk
include $(MAKEPATH)/mk/mac.mk

include $(MAKEPATH)/mk/editors.mk
include $(MAKEPATH)/mk/rust.mk
include $(MAKEPATH)/mk/shells.mk

install: zsh tmux neovim vs-code
	-cp $(MAKEPATH)/.gitignore $(HOME)/.gitignore
	-mkdir $(HOME)/.scripts/
	-cp -r $(MAKEPATH)/.scripts/ $(HOME)/.scripts/

push:
ifeq ($(shell uname), Darwin)
	-cp $(HOME)/Library/Application\ Support/Code/User/settings.json $(MAKEPATH)/.config/Code/User/
else
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/.config/Code/User/
endif
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp -r $(HOME)/.config/zsh/ $(MAKEPATH)/.config/zsh/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/.config/nvim/
	-cp $(HOME)/.gitignore $(MAKEPATH)/.gitignore
	-cp -r $(HOME)/.scripts/ $(MAKEPATH)/.scripts/

