MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all:
	cd $(MAKEPATH); cargo run -q
.PHONY: all

darwin:
	xargs brew install < $(MAKEPATH)/pkgs/brew-darwin-base.txt
	brew install --cask alacritty visual-studio-code font-iosevka font-iosevka-nerd-font font-jetbrains-mono
	xargs cargo install < $(MAKEPATH)/pkgs/crates.txt
.PHONY: darwin

tidy:
	cd $(MAKEPATH); cargo fmt
	cd $(MAKEPATH); cargo fix --edition-idioms --allow-dirty --allow-staged
	cd $(MAKEPATH); cargo clippy --fix --no-deps --edition-idioms --allow-dirty --allow-staged
.PHONY: tidy