$env.PATH = ($env.PATH | append "~/.cargo/bin")

const cargo_env_nu = if ("~/.cargo/env.nu" | path expand | path exists) { "~/.cargo/env.nu" } else { null }
source $cargo_env_nu

alias cargo-check-all = cargo check --all-targets --all-features
