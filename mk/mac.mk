# DOTFILES
# https://nickgerace.dev

brew-mac-install: brew-mac-update-and-upgrade
	brew install \
		bash curl git make tmux wget neovim \
		aspell htop speedtest-cli gsed jq tree nodejs \
		cowsay lolcat fortune neofetch \
		doctl azure-cli \
		go helm k3d kind kubectl rke kustomize k9s golangci/tap/golangci-lint
	brew tap \
		homebrew/cask-fonts
	brew cask install \
		font-iosevka font-iosevka-slab font-cascadia-code \
		ngrok google-cloud-sdk

brew-mac-install-essentials: brew-mac-update-and-upgrade
	brew install \
		bash curl tmux make git wget neovim aspell htop speedtest-cli gsed jq tree go helm \
		k3d kind kubectl kustomize

brew-mac-update-and-upgrade:
	brew update
	brew upgrade

