# DOTFILES
# https://nickgerace.dev

MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CURRENT:=$(MAKEPATH)/current

install:
	cp $(CURRENT)/.zshrc $(HOME)/
	cp $(CURRENT)/.tmux.conf $(HOME)/
	-mkdir -p $(HOME)/.config/nvim/
	cp $(CURRENT)/init.vim $(HOME)/.config/nvim/init.vim
	-mkdir -p $(HOME)/.oh-my-zsh/themes/
	cp $(CURRENT)/nickgerace.zsh-theme $(HOME)/.oh-my-zsh/themes/
	@printf "\nNow, install oh-my-zsh: https://ohmyz.sh/\n"

push:
	-cp $(HOME)/.zshrc $(CURRENT)/
	-cp $(HOME)/.tmux.conf $(CURRENT)/
	-cp $(HOME)/.config/nvim/init.vim $(CURRENT)/
	-cp $(HOME)/.oh-my-zsh/themes/nickgerace.zsh-theme $(CURRENT)/

cargo:
	cargo install exa ripgrep fd-find bat
	cargo install --git https://github.com/nickgerace/gfold

.PHONY: neovim
neovim:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall
	nvim +"CocInstall coc-rust-analyzer" +qall

fedora:
	sudo dnf check-update
	sudo dnf install \
		fish \
		zsh \
		tree \
		cloc \
		speedtest-cli \
		llvm \
		wget \
		curl \
		openssl-devel \
		make \
		tmux \
		vim \
		nodejs \
		neovim \
		nvme-cli \
		neofetch \
		aspell \
		htop \
		fwupd \
		efibootmgr \
		util-linux-user \
		zlib-devel \
		@development-tools \
		git
	sudo dnf install \
		https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
		https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	sudo dnf check-update
	sudo dnf groupupdate Multimedia
	@printf "\nInstall the following...\n\
		oh-my-zsh\n\
		docker\n\
		kind\n\
		kubectl\n\
		helm\n\
		go\n\
		rust (rustup)\n\
		\n"
