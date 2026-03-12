source catppuccin_latte.nu

$env.EDITOR = "hx"
$env.VISUAL = "hx"

$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.local/bin')

$env.config.buffer_editor = "hx"

$env.LS_COLORS = (vivid generate catppuccin-latte)

alias git = jj

alias hxn = config nu
alias hxd = hx ~/src/dotfiles/

$env.config.show_banner = false

alias claude-personal = with-env { CLAUDE_CONFIG_DIR: ($env.HOME + "/.claude-personal") } { ^($env.HOME + "/.local/bin/claude") }
alias claude-work = with-env { CLAUDE_CONFIG_DIR: ($env.HOME + "/.claude-work") } { ^($env.HOME + "/.local/bin/claude") }

alias claude-personal-dangerously-skip-permissions = with-env { CLAUDE_CONFIG_DIR: ($env.HOME + "/.claude-personal") } { ^($env.HOME + "/.local/bin/claude") --dangerously-skip-permissions }
alias claude-work-dangerously-skip-permissions = with-env { CLAUDE_CONFIG_DIR: ($env.HOME + "/.claude-work") } { ^($env.HOME + "/.local/bin/claude") --dangerously-skip-permissions }

alias update = ^~/src/dotfiles/bin/update.sh

$env.PATH = ($env.PATH | append "~/.cargo/bin")

alias jjst = jj status
alias jjd = jj diff

source ~/.zoxide.nu
