MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all: nix brew
	cd $(MAKEPATH); cargo run -q
.PHONY: all

nix: tidy-nix
	cd $(MAKEPATH); git add .
	cd $(MAKEPATH); nix flake update
	home-manager switch --flake $(MAKEPATH)
.PHONY: nix

brew:
	brew install --cask alacritty visual-studio-code font-iosevka font-iosevka-nerd-font font-jetbrains-mono

tidy: tidy-nix
	cd $(MAKEPATH); cargo fmt
	cd $(MAKEPATH); cargo fix --edition-idioms --allow-dirty --allow-staged
	cd $(MAKEPATH); cargo clippy --fix --no-deps --edition-idioms --allow-dirty --allow-staged
.PHONY: tidy

tidy-nix:
	nixfmt $(MAKEPATH)/flake.nix
	nixfmt $(MAKEPATH)/home.nix
.PHONY: tidy-nix

nix-init:
	cd $(MAKEPATH); nix run . switch -- --flake .
.PHONY: nix-init
