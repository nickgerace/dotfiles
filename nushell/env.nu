# Load the PATH first
let path_prefixes = [
    "/home/linuxbrew/.linuxbrew/bin"
    '/opt/homebrew/bin'
    '/opt/homebrew/opt/curl/bin'
    '/opt/homebrew/opt/gnu-sed/libexec/gnubin'
    '/opt/homebrew/opt/make/libexec/gnubin'
    '/usr/local/bin'
    '~/.local/bin'
] | where { path exists }
$env.PATH = ($env.PATH | prepend $path_prefixes)

# Editor settings
$env.EDITOR = "hx"
$env.config.buffer_editor = "hx"
$env.VISUAL = "hx"

# Remaining settings
$env.config.show_banner = false
$env.LS_COLORS = (vivid generate rose-pine-dawn)

let generated_dir = ($nu.home-dir | path join .config nushell)
mkdir $generated_dir

if (which mise | is-not-empty) {
  let mise_nu = ($generated_dir | path join mise.nu)
  mise activate nu | save $mise_nu --force
}

if (which just | is-not-empty) {
  let just_nu = ($generated_dir | path join just.nu)
  just --completions nushell | save $just_nu --force
}

if (which jj | is-not-empty) {
  let jj_nu = ($generated_dir | path join jj.nu)
  jj util completion nushell | save $jj_nu --force
}

if (which zoxide | is-not-empty) {
  let zoxide_nu = ($generated_dir | path join zoxide.nu)
  zoxide init nushell | save $zoxide_nu --force
}
