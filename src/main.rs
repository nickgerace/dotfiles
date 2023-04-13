use anyhow::{anyhow, Result};
use git2::Config;
use serde::Deserialize;
use std::os::unix::fs as unix_fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::{env, fs, io};

#[cfg(any(
    all(target_os = "linux", target_arch = "x86_64"),
    all(target_os = "macos", target_arch = "aarch64")
))]
const REPO: &str = env!("CARGO_MANIFEST_DIR");

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
const ALACRITTY: &str = "linux.yml";
#[cfg(all(target_os = "macos", target_arch = "aarch64"))]
const ALACRITTY: &str = "darwin.yml";

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
const GFOLD: &str = "linux.toml";
#[cfg(all(target_os = "macos", target_arch = "aarch64"))]
const GFOLD: &str = "darwin.toml";

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
const STABLE_TOOLCHAIN: &str = "stable-x86_64-unknown-linux-gnu";
#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
const NIGHTLY_TOOLCHAIN: &str = "nightly-x86_64-unknown-linux-gnu";

#[cfg(all(target_os = "macos", target_arch = "aarch64"))]
const STABLE_TOOLCHAIN: &str = "stable-aarch64-apple-darwin";
#[cfg(all(target_os = "macos", target_arch = "aarch64"))]
const NIGHTLY_TOOLCHAIN: &str = "nightly-aarch64-apple-darwin";

#[cfg(any(
    all(target_os = "linux", target_arch = "x86_64"),
    all(target_os = "macos", target_arch = "aarch64")
))]
#[derive(Deserialize)]
struct DotfilesConfig {
    #[serde(rename = "git-user-name")]
    git_user_name: String,
}

struct Runner;

impl Runner {
    #[cfg(not(any(
        all(target_os = "linux", target_arch = "x86_64"),
        all(target_os = "macos", target_arch = "aarch64")
    )))]
    fn run() -> Result<()> {
        Err(anyhow!("invalid OS and ARCH configuration (see README.md)"))
    }

    #[cfg(any(
        all(target_os = "linux", target_arch = "x86_64"),
        all(target_os = "macos", target_arch = "aarch64")
    ))]
    fn run() -> Result<()> {
        let home = dirs::home_dir().ok_or_else(|| anyhow!("home dir not found"))?;
        let repo = PathBuf::from(REPO);

        let dotfiles_toml_string = fs::read_to_string(repo.join("dotfiles.toml"))?;
        let config: DotfilesConfig = toml::from_str(&dotfiles_toml_string)?;

        let global_gitconfig = Config::find_global()?;
        let mut gitconfig = Config::open(&global_gitconfig)?;
        gitconfig.set_str("user.name", &config.git_user_name)?;
        gitconfig.set_bool("pull.rebase", true)?;

        Self::link(repo.join("zshrc"), home.join(".zshrc"))?;
        Self::link(repo.join("tmux.conf"), home.join(".tmux.conf"))?;
        Self::link(
            repo.join("init.lua"),
            home.join(".config").join("nvim").join("init.lua"),
        )?;
        Self::link(
            repo.join("starship.toml"),
            home.join(".config").join("starship.toml"),
        )?;
        Self::link(
            repo.join("alacritty").join(ALACRITTY),
            home.join(".config").join("alacritty").join("alacritty.yml"),
        )?;
        Self::link(
            repo.join("gfold").join(GFOLD),
            home.join(".config").join("gfold.toml"),
        )?;
        Self::link(
            repo.join("home-manager").join("darwin.nix"),
            home.join(".config").join("home-manager").join("home.nix"),
        )?;

        #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
        let cargo_config = match PathBuf::from("/home/linuxbrew/.linuxbrew/bin/mold").exists() {
            true => "linuxbrew.toml",
            false => "config.toml",
        };
        #[cfg(all(target_os = "macos", target_arch = "aarch64"))]
        let cargo_config = "config.toml";

        Self::link(
            repo.join("cargo").join(cargo_config),
            home.join(".cargo").join("config.toml"),
        )?;

        Self::rustup(&["toolchain", "install", STABLE_TOOLCHAIN])?;
        Self::rustup(&["toolchain", "install", NIGHTLY_TOOLCHAIN])?;
        Self::rustup(&["default", STABLE_TOOLCHAIN])?;

        Ok(())
    }

    /// Remove the old link before linking again.
    fn link<X: AsRef<Path>, Y: AsRef<Path>>(original: X, link: Y) -> Result<()> {
        let original = original.as_ref();
        let link = link.as_ref();

        if let Some(parent) = link.parent() {
            if !parent.exists() {
                fs::create_dir_all(parent)?;
                println!("created parent directory (and ancestor(s), if applicable): {parent:?}");
            } else if !parent.is_dir() {
                return Err(anyhow!("parent is not a directory: {parent:?}"));
            }
        }

        match fs::remove_file(link) {
            Ok(_) => println!("removed {link:?}"),
            Err(e) if e.kind() == io::ErrorKind::NotFound => {}
            Err(e) => return Err(e.into()),
        }

        unix_fs::symlink(original, link)?;
        println!("created symlink from {original:?} to {link:?}");

        Ok(())
    }

    /// Execute `rustup` with provided arguments.
    fn rustup(args: &[&str]) -> Result<()> {
        println!("> rustup {}", args.join(" "));
        let mut cmd = Command::new("rustup");
        match cmd.args(args).status()?.success() {
            true => Ok(()),
            false => Err(anyhow!("rustup command failed")),
        }
    }
}

fn main() -> Result<()> {
    Runner::run()
}
