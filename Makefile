# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CURRENT:=$(MAKEPATH)/current
GO_VERSION:=1.14.2

install:
	cp $(CURRENT)/.zshrc $(HOME)/
	cp $(CURRENT)/.tmux.conf $(HOME)/
	cp $(CURRENT)/.vimrc $(HOME)/
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(CURRENT)/settings.json $(HOME)/.config/Code/User/
	-mkdir -p $(HOME)/.oh-my-zsh/themes/
	cp $(CURRENT)/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/
	@printf "\nNow, install oh-my-zsh: https://ohmyz.sh/\n"

push:
	-cp $(HOME)/.zshrc $(CURRENT)/
	-cp $(HOME)/.tmux.conf $(CURRENT)/
	-cp $(HOME)/.vimrc $(CURRENT)/
	-cp $(HOME)/.config/Code/User/settings.json $(CURRENT)/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(CURRENT)/

deb:
	sudo apt update
	sudo apt install \
		fish \
		zsh \
		tree \
		cloc \
		speedtest-cli \
		libclang-dev \
		llvm \
		libssl-dev \
		build-essential \
		wget \
		curl \
		make \
		tmux \
		vim \
		tlp \
		nvme-cli \
		neofetch \
		aspell \
		htop \
		fwupd \
		efibootmgr \
		git

go:
	wget https://dl.google.com/go/go$(GO_VERSION).linux-amd64.tar.gz
	-sudo rm -r /usr/local/go
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	-rm go$(GO_VERSION).linux-amd64.tar.gz

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
