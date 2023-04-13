use anyhow::{anyhow, Result};
use git2::Config;
use serde::Deserialize;
use std::os::unix::fs as unix_fs;
use std::path::{Path, PathBuf};
use std::{env, fs, io};

const REPO: &str = env!("CARGO_MANIFEST_DIR");

#[cfg(target_os = "linux")]
const ALACRITTY: &str = "linux.yml";
#[cfg(target_os = "macos")]
const ALACRITTY: &str = "darwin.yml";

#[cfg(target_os = "linux")]
const GFOLD: &str = "linux.toml";
#[cfg(target_os = "macos")]
const GFOLD: &str = "darwin.toml";

#[derive(Deserialize)]
struct DotfilesConfig {
    #[serde(rename = "git-user-name")]
    git_user_name: String,
}

struct Runner;

impl Runner {
    #[cfg(not(any(target_os = "linux", target_os = "macos")))]
    fn run() -> Result<()> {
        Err(anyhow!("only Linux and macOS are currently supported"))
    }

    #[cfg(any(target_os = "linux", target_os = "macos"))]
    fn run() -> Result<()> {
        let home = dirs::home_dir().ok_or_else(|| anyhow!("home dir not found"))?;
        let repo = PathBuf::from(REPO);
        let none: Option<PathBuf> = None;

        let dotfiles_toml_string = fs::read_to_string(repo.join("dotfiles.toml"))?;
        let config: DotfilesConfig = toml::from_str(&dotfiles_toml_string)?;

        let global_gitconfig = Config::find_global()?;
        let mut gitconfig = Config::open(&global_gitconfig)?;
        gitconfig.set_str("user.name", &config.git_user_name)?;
        gitconfig.set_bool("pull.rebase", true)?;

        Self::link(repo.join("zshrc"), home.join(".zshrc"), none.clone())?;
        Self::link(repo.join("tmux.conf"), home.join(".tmux.conf"), none)?;
        Self::link(
            repo.join("init.lua"),
            home.join(".config").join("nvim").join("init.lua"),
            Some(home.join(".config").join("nvim")),
        )?;
        Self::link(
            repo.join("starship.toml"),
            home.join(".config").join("starship.toml"),
            Some(home.join(".config")),
        )?;
        Self::link(
            repo.join("alacritty").join(ALACRITTY),
            home.join(".config").join("alacritty").join("alacritty.yml"),
            Some(home.join(".config").join("alacritty")),
        )?;
        Self::link(
            repo.join("gfold").join(GFOLD),
            home.join(".config").join("gfold.toml"),
            Some(home.join(".config")),
        )?;
        Self::link(
            repo.join("home-manager").join("home.nix"),
            home.join(".config").join("home-manager").join("home.nix"),
            Some(home.join(".config").join("home-manager")),
        )?;

        #[cfg(target_os = "linux")]
        let cargo_config = match PathBuf::from("/home/linuxbrew/.linuxbrew/bin/mold").exists() {
            true => "linuxbrew.toml",
            false => "config.toml",
        };
        #[cfg(not(target_os = "linux"))]
        let cargo_config = "config.toml";

        Self::link(
            repo.join("cargo").join(cargo_config),
            home.join(".cargo").join("config.toml"),
            Some(home.join(".cargo")),
        )?;

        Ok(())
    }

    /// Remove the old link before linking again. If provided, create the parent directory and
    /// all of its parent components (if missing).
    #[cfg(any(target_os = "linux", target_os = "macos"))]
    fn link<X: AsRef<Path>, Y: AsRef<Path>, Z: AsRef<Path>>(
        original: X,
        link: Y,
        link_parent_directory: Option<Z>,
    ) -> Result<()> {
        if let Some(directory) = link_parent_directory {
            let directory = directory.as_ref();
            if !directory.exists() {
                fs::create_dir_all(directory)?;
                println!(
                    "created parent directory (and ancestor(s), if applicable): {directory:?}"
                );
            } else if !directory.is_dir() {
                return Err(anyhow!("parent is not a directory: {:?}", directory));
            }
        }

        let original = original.as_ref();
        let link = link.as_ref();

        match fs::remove_file(link) {
            Ok(_) => println!("removed {link:?}"),
            Err(e) if e.kind() == io::ErrorKind::NotFound => {}
            Err(e) => return Err(e.into()),
        }

        unix_fs::symlink(original, link)?;
        println!("created symlink from {original:?} to {link:?}");

        Ok(())
    }
}

fn main() -> Result<()> {
    Runner::run()
}
