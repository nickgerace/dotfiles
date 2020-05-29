# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEPATH)/makefiles/distros.mk
include $(MAKEPATH)/makefiles/editors.mk
include $(MAKEPATH)/makefiles/fonts.mk
include $(MAKEPATH)/makefiles/languages.mk
include $(MAKEPATH)/makefiles/shells.mk

install: zsh tmux vim neovim

push:
	-cp $(HOME)/.zshrc $(MAKEPATH)/zsh/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/tmux/
	-cp $(HOME)/.vimrc $(MAKEPATH)/vim/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/nvim/
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/vs-code/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(MAKEPATH)/zsh/

