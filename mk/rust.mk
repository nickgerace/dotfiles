# DOTFILES
# https://nickgerace.dev

.PHONY: rustup
rustup:
	@printf "https://rustup.rs/\n"

.PHONY: cargo
cargo:
	cargo install \
                exa \
                ripgrep \
                fd-find \
                ytop \
                bat

