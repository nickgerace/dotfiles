install:
    @bin/install.sh

update:
	@bin/update.sh

update-repo:
    wget -O nushell/theme.toml https://raw.githubusercontent.com/nushell/nu_scripts/refs/heads/main/themes/nu-themes/rose-pine-dawn.nu

format:
    -shfmt -i 2 -w **/*.sh
    -if command -v alejandra; then alejandra **/*.nix; fi

list:
    @scripts/list-owned-repos.sh
