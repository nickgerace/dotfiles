# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEPATH)/mk/apt.mk
include $(MAKEPATH)/mk/dnf.mk
include $(MAKEPATH)/mk/mac.mk

include $(MAKEPATH)/mk/editors.mk
include $(MAKEPATH)/mk/rust.mk
include $(MAKEPATH)/mk/shells.mk

install-mac: zsh tmux vim neovim vs-code-mac

install-linux: zsh tmux vim neovim vs-code-linux

push-mac: push-core
	-cp $(HOME)/Library/Application\ Support/Code/User/settings.json $(MAKEPATH)/.config/Code/User/

push-linux: push-core
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/.config/Code/User/

push-core:
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp -r $(HOME)/.config/zsh/ $(MAKEPATH)/.config/zsh/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.vimrc $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/.config/nvim/

