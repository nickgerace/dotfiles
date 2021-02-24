MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install-vs-code:
ifeq ($(shell uname), Darwin)
	-mkdir -p $(HOME)/Library/Application\ Support/Code/User/
	cp $(MAKEPATH)/code/settings.json $(HOME)/Library/Application\ Support/Code/User
else
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(MAKEPATH)/code/settings.json $(HOME)/.config/Code/User/
endif

push-vs-code:
ifeq ($(shell uname), Darwin)
	-cp $(HOME)/Library/Application\ Support/Code/User/settings.json $(MAKEPATH)/code/
else
	-cp $(HOME)/.config/Code/User/settings.json $(MAKEPATH)/code/
endif
