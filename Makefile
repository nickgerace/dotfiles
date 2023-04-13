MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all:
	cd $(MAKEPATH); cargo run -q
.PHONY: all

tidy:
	cd $(MAKEPATH); nixfmt home-manager/home.nix
	cd $(MAKEPATH); cargo fmt
	cd $(MAKEPATH); cargo fix --edition-idioms --allow-dirty --allow-staged
	cd $(MAKEPATH); cargo clippy --fix --no-deps --edition-idioms --allow-dirty --allow-staged
.PHONY: tidy
