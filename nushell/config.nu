# The "use" files created from "env.nu" (must come before the first source call)
use ~/.config/nushell/mise.nu

# The "source" files created from "env.nu"
source ~/.config/nushell/jj.nu
source ~/.config/nushell/just.nu
source ~/.config/nushell/zoxide.nu

# Loaded theme from the install script
source ~/.config/nushell/theme.toml

alias hxn = config nu
alias hxd = hx ~/src/n/
alias update = ^~/src/n/bin/update.sh

# Load the remaining nushell files in the repository
source brew.nu
source diff.nu
source docker.nu
source eza.nu
source fastfetch.nu
source ghostty.nu
source jj.nu
source kubernetes.nu
source npm.nu
source rust.nu
source shfmt.nu
source trivy.nu
source zoxide.nu

# Unsupported integrations that were supported in zsh:
# - brew
# - fnm
# - fzf
