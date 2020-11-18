# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEPATH)/mk/apt.mk
include $(MAKEPATH)/mk/dnf.mk
include $(MAKEPATH)/mk/mac.mk

include $(MAKEPATH)/mk/editors.mk
include $(MAKEPATH)/mk/rust.mk

install:
ifeq ($(shell uname), Darwin)
	-mkdir -p $(HOME)/Library/Application\ Support/Code/User/
	cp $(MAKEPATH)/code/settings.json $(HOME)/Library/Application\ Support/Code/User
else
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(MAKEPATH)/code/settings.json $(HOME)/.config/Code/User/
endif
	cp $(MAKEPATH)/.zshrc $(HOME)/
	cp $(MAKEPATH)/.tmux.conf $(HOME)/
	-mkdir -p $(HOME)/.config/nvim/colors/
	cp $(MAKEPATH)/nvim/init.vim $(HOME)/.config/nvim/
	cp $(MAKEPATH)/nvim/one.vim $(HOME)/.config/nvim/colors/
	cp $(MAKEPATH)/.gitignore $(HOME)/.gitignore

push:
ifeq ($(shell uname), Darwin)
	-cp $(HOME)/Library/Application\ Support/Code/User/settings.json $(MAKEPATH)/code/
else
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/code/
endif
	-cp $(HOME)/.zshrc $(MAKEPATH)/
	-cp $(HOME)/.tmux.conf $(MAKEPATH)/
	-cp $(HOME)/.config/nvim/init.vim $(MAKEPATH)/nvim/
	-cp $(HOME)/.config/nvim/colors/one.vim $(MAKEPATH)/nvim/
	-cp $(HOME)/.gitignore $(MAKEPATH)/.gitignore

