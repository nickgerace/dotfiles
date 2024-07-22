MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=install

install:
	@$(MAKEPATH)/bin/install.sh
.PHONY: all

update:
	@$(MAKEPATH)/bin/update.sh
.PHONY: update
