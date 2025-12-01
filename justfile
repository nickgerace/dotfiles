_default:
    @just --list

# Links dotfiles and installs system packages
install:
    @bin/install.sh

# Updates system packages
update:
	@bin/update.sh

# Formats relevant files
format:
    -alejandra **/*.nix
    -shfmt -i 2 -w **/*.sh
    -shfmt -i 2 -w **/*.zsh
