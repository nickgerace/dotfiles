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

push-mac: push-extras
	-cp $(HOME)/Library/Application\ Support/Code/User/settings.json $(MAKEPATH)/vs-code/

push-linux: push-extras
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/vs-code/

push-extras:
	-cp $(HOME)/.zshrc $(MAKEPATH)/zsh/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/tmux/
	-cp $(HOME)/.vimrc $(MAKEPATH)/vim/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/neovim/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(MAKEPATH)/zsh/
