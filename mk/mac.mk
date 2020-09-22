# DOTFILES
# https://nickgerace.dev

brew: brew-update-and-upgrade
	brew install \
		aspell curl git htop make neovim speedtest-cli tmux tree wget nodejs gsed \
		go helm k3d kind kubectl
	brew tap homebrew/cask-fonts
	brew cask install font-iosevka font-iosevka-slab font-cascadia

brew-memes:
	brew install \
		cowsay lolcat fortune neofetch

brew-update-and-upgrade:
	brew update
	brew upgrade
