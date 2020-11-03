# DOTFILES
# https://nickgerace.dev

brew: brew-update-and-upgrade
	-brew install \
		bash curl git make tmux wget bash-completion@2 \
		aspell htop speedtest-cli gsed jq tree neovim \
		go helm k3d kind kubectl rke kustomize k9s
	-brew install \
		golangci/tap/golangci-lint
	-brew tap \
		homebrew/cask-fonts
	-brew cask install \
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
		doctl azure-cli
	brew cask install \
		google-cloud-sdk

brew-extras:
	brew install \
		nodejs

