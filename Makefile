MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all:
	@$(MAKEPATH)/setup/run.sh
.PHONY: all
