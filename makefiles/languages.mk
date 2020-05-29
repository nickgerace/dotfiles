# DOTFILES
# https://nickgerace.dev

cargo:
	cargo install \
        exa \
        ripgrep \
        fd-find \
        ytop \
        bat
	cargo install --git https://github.com/nickgerace/gfold
	@printf "Should probably publish gfold to crates.io at some point...\n"

