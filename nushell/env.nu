# Load the PATH first
let path_prefixes = [
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

const mise_nu = ($nu.home-dir | path join .config nushell mise.nu)
^/opt/homebrew/bin/mise activate nu | save $mise_nu --force

const just_nu = ($nu.home-dir | path join .config nushell just.nu)
^/opt/homebrew/bin/just --completions nushell | save $just_nu --force

const jj_nu = ($nu.home-dir | path join .config nushell jj.nu)
^/opt/homebrew/bin/jj util completion nushell | save $jj_nu --force

const zoxide_nu = ($nu.home-dir | path join .config nushell zoxide.nu)
^/opt/homebrew/bin/zoxide init nushell | save $zoxide_nu --force
