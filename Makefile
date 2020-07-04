# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEPATH)/mk/distros.mk
include $(MAKEPATH)/mk/editors.mk
include $(MAKEPATH)/mk/languages.mk
include $(MAKEPATH)/mk/shells.mk

install: zsh tmux vim neovim

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/zsh/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/tmux/
	-cp $(HOME)/.vimrc $(MAKEPATH)/vim/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/nvim/
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/vs-code/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(MAKEPATH)/zsh/

