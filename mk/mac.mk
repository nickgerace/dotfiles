# DOTFILES
# https://nickgerace.dev

BREW_BASE:="aspell bash curl git gsed htop jq make neovim speedtest-cli tmux tree wget"
BREW_CLOUD:="doctl azure-cli"
BREW_K8S:="helm k3d k9s kind kubectl kustomize"
BREW_LANG:="go golangci/tap/golangci-lint python3"

brew-install: brew-update-upgrade
	brew install \
		"$(BREW_BASE)" \
		"$(BREW_CLOUD)" \
		"$(BREW_K8S)" \
		"$(BREW_LANG)"
	brew tap homebrew/cask-fonts
	brew cask install \
		font-iosevka font-iosevka-slab font-cascadia-code \
		ngrok google-cloud-sdk

BREW_EXTRA:="nodejs"
BREW_MEME:="cowsay lolcat fortune neofetch"

brew-install-extras: brew-install
	brew install \
		"$(BREW_EXTRA)" \
		"$(BREW_MEME)"

brew-update-upgrade:
	brew update
	brew upgrade

