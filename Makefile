MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all: nix
	cd $(MAKEPATH); cargo run -q
.PHONY: all

nix:
	cd $(MAKEPATH); git add .
	cd $(MAKEPATH); nix flake update
	cd $(MAKEPATH); home-manager switch --flake .
.PHONY: nix

tidy:
	cd $(MAKEPATH); nixfmt home-manager/darwin.nix
	cd $(MAKEPATH); cargo fmt
	cd $(MAKEPATH); cargo fix --edition-idioms --allow-dirty --allow-staged
	cd $(MAKEPATH); cargo clippy --fix --no-deps --edition-idioms --allow-dirty --allow-staged
.PHONY: tidy
