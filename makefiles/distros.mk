# DOTFILES
# https://nickgerace.dev

PACKAGES:=git \
	fish \
	zsh \
	tree \
	cloc \
	speedtest-cli \
	llvm \
	wget \
	curl \
	make \
	tmux \
	vim \
	neovim \
	nvme-cli \
	neofetch \
	aspell \
	htop \
	fwupd \
	efibootmgr

dnf:
	sudo dnf check-update
	sudo dnf install \
		$(PACKAGES) \
		openssl-devel \
		zlib-devel \
		@development-tools \
		util-linux-user 
	sudo dnf install \
		https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(shell rpm -E %fedora).noarch.rpm \
		https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(shell rpm -E %fedora).noarch.rpm
	sudo dnf check-update
	sudo dnf groupupdate Multimedia
	sudo dnf autoremove
	@printf "\nInstall the following...\n\
		oh-my-zsh\n\
		docker\n\
		kind\n\
		kubectl\n\
		helm\n\
		go\n\
		rust (rustup)\n\
		\n"

cgroups:
	sudo dnf install -y grubby
	sudo grubby \
		--update-kernel=ALL \
		--args="systemd.unified_cgroup_hierarchy=0"

apt:
	sudo apt update
	sudo apt install \
		$(PACKAGES) \
		libssl-dev \
		build-essential \
		ubuntu-restricted-extras
	sudo apt upgrade
	sudo apt autoremove
	@printf "\nInstall the following...\n\
		oh-my-zsh\n\
		docker\n\
		kind\n\
		kubectl\n\
		helm\n\
		go\n\
		rust (rustup)\n\
		\n"

