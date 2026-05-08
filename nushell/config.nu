# The "use" files created from "env.nu" (must come before the first source call)
const generated_dir = ($nu.home-dir | path join .config nushell)
const mise_nu = if (($generated_dir | path join mise.nu) | path exists) { $generated_dir | path join mise.nu } else { null }
use $mise_nu

# The "source" files created from "env.nu"
const jj_nu = if (($generated_dir | path join jj.nu) | path exists) { $generated_dir | path join jj.nu } else { null }
const just_nu = if (($generated_dir | path join just.nu) | path exists) { $generated_dir | path join just.nu } else { null }
const zoxide_generated_nu = if (($generated_dir | path join zoxide.nu) | path exists) { $generated_dir | path join zoxide.nu } else { null }
source $jj_nu
source $just_nu
source $zoxide_generated_nu

alias hxn = config nu
alias hxd = hx ~/src/n/
alias update = ^~/src/n/bin/update.sh

# Load the remaining nushell files in the repository
const brew_nu = path self brew.nu
const diff_nu = path self diff.nu
const docker_nu = path self docker.nu
const eza_nu = path self eza.nu
const fastfetch_nu = path self fastfetch.nu
const ghostty_nu = path self ghostty.nu
const repo_jj_nu = path self jj.nu
const kubernetes_nu = path self kubernetes.nu
const npm_nu = path self npm.nu
const ps_nu = path self ps.nu
const rust_nu = path self rust.nu
const shfmt_nu = path self shfmt.nu
const theme_nu = path self theme.toml
const trivy_nu = path self trivy.nu
const zoxide_repo_nu = path self zoxide.nu

source $brew_nu
source $diff_nu
source $docker_nu
source $eza_nu
source $fastfetch_nu
source $ghostty_nu
source $repo_jj_nu
source $kubernetes_nu
source $npm_nu
source $rust_nu
source $shfmt_nu
source $theme_nu
source $trivy_nu
source $zoxide_repo_nu

# Unsupported integrations that were supported in zsh:
# - brew
# - fnm
# - fzf
