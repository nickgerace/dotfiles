# DOTFILES
# https://nickgerace.dev

CRATES:="exa ripgrep fd-find ytop bat gfold"

.PHONY: rustup
rustup:
	@printf "https://rustup.rs/\n"

cargo-install:
	cargo install "$(CRATES)"

cargo-uninstall:
	-cargo uninstall "$(CRATES)"
