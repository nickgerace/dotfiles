MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all:
	@$(MAKEPATH)/setup/run.sh
.PHONY: all

switch:
	cd $(MAKEPATH); sudo nixos-rebuild switch --flake .
.PHONY: switch

update:
	cd $(MAKEPATH); nix flake update
	cd $(MAKEPATH); sudo nixos-rebuild switch --flake .
	npm update -g
	flatpak update -y
	flatpak uninstall --unused
	flatpak repair
.PHONY: update
