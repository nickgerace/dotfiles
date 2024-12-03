MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=install

install:
	@$(MAKEPATH)/bin/install.sh
.PHONY: all

update:
	@$(MAKEPATH)/bin/update.sh
.PHONY: update

format:
	cd $(MAKEPATH); alejandra **/*.nix
	-cd $(MAKEPATH); shfmt -i 2 -w **/*.sh
	-cd $(MAKEPATH); shfmt -i 2 -w **/*.zsh
.PHONY: format
