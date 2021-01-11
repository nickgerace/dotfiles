# DOTFILES
# https://nickgerace.dev

BREW_BASE:="aspell bash curl git gsed htop jq make neovim speedtest-cli tmux tree wget"
BREW_CLOUD:="doctl azure-cli awscli terraform"
BREW_K8S:="helm k3d k9s kind kubectl kustomize"
BREW_LANG:="go golangci/tap/golangci-lint python3"
BREW_EXTRA:="nodejs cowsay lolcat fortune neofetch"

brew-install: brew-update-upgrade
	brew install \
		"$(BREW_BASE)" \
		"$(BREW_CLOUD)" \
		"$(BREW_K8S)" \
		"$(BREW_LANG)" \
		"$(BREW_EXTRA)"
	brew tap homebrew/cask-fonts
	brew cask install \
		font-iosevka font-iosevka-slab font-cascadia-code \
		ngrok google-cloud-sdk

brew-install-unavailable-in-home-manager:
	brew install azure-cli awscli terraform k3d
	brew tap homebrew/cask-fonts
	brew cask install font-iosevka font-iosevka-slab font-cascadia-code

brew-update-upgrade-cleanup:
	brew update
	brew upgrade
	brew cleanup

