# DOTFILES
# https://nickgerace.dev

.PHONY: cargo
cargo:
	cargo install \
                exa \
                ripgrep \
                fd-find \
                ytop \
                bat
	cargo install --git https://github.com/nickgerace/gfold --tag 0.5.0
