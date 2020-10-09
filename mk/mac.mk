# DOTFILES
# https://nickgerace.dev

brew: brew-update-and-upgrade
	brew install \
		aspell curl git htop make neovim speedtest-cli tmux tree wget gsed \
		go helm k3d kind kubectl rke
	brew tap homebrew/cask-fonts
	brew cask install \
		font-iosevka font-iosevka-slab font-cascadia-code \
		ngrok

brew-update-and-upgrade:
	brew update
	brew upgrade

brew-memes:
	brew install \
		cowsay lolcat fortune neofetch

brew-cloud:
	brew install \
		doctl
	brew cask install \
		google-cloud-sdk

brew-extras:
	brew install \
		nodejs

