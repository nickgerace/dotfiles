MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

UNAME:=$(shell uname -s)

VSCODE:="$(HOME)/.config/Code/User"
ifeq ("$(UNAME)", "Darwin")
	VSCODE:="$(HOME)/Library/Application Support/Code/User"
endif

.DEFAULT_GOAL:=all

all:
	cd $(MAKEPATH); cargo run -q

tidy:
	cd $(MAKEPATH); nixfmt home-manager/home.nix
	cd $(MAKEPATH); cargo fmt
	cd $(MAKEPATH); cargo fix --edition-idioms --allow-dirty --allow-staged
	cd $(MAKEPATH); cargo clippy --fix --no-deps --edition-idioms --allow-dirty --allow-staged

vscode:
	@-rm $(VSCODE)/keybindings.json
	ln -s $(MAKEPATH)/vscode/keybindings.json $(VSCODE)/keybindings.json
.PHONY: vscode
