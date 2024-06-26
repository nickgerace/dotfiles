MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL:=all

all:
	@$(MAKEPATH)/bootstrap/run.sh
.PHONY: all

thelio:
	@$(MAKEPATH)/thelio/bootstrap.sh
.PHONY:thelio
