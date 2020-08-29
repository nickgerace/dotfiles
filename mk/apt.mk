# DOTFILES
# https://nickgerace.dev

apt:
	sudo apt update
	sudo apt install \
		git fish zsh tree cloc speedtest-cli \
		wget curl make tmux \
		vim neovim neofetch aspell htop \
		llvm llvm-dev libssl-dev nodejs \
		build-essential
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

apt-desktop:
	sudo apt update
	sudo apt install nvme-cli efibootmgr fwupd ubuntu-restricted-extras
	sudo apt upgrade
	sudo apt autoremove
