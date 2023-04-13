{ config, pkgs, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "23.05";

  # How to get sha512...
  # > curl https://registry.npmjs.org/pnpm/ | jq '.versions."7.32.0"'.dist.integrity
  nixpkgs.overlays = [
    (self: super: {
      overrides.pnpm = super.nodePackages.pnpm.override (oldAttrs: rec {
        version = "7.32.0";
        src = super.fetchurl {
          url = "https://registry.npmjs.org/pnpm/-/pnpm-7.32.0.tgz";
          sha512 =
            "XkLEMinrF4046cWGvvam7dsCKeRdJ9i2SeDiKNodoZEPmJp1KrzQe1qYC5Vs/v9qBXJqyI0vLzjoMHjXgphP6g==";
        };
      });
    })
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # cargo-watch
    # ferris-fetch
    # nushell
    # procs
    asciinema
    asciinema-agg
    automake
    awscli2
    bash
    bat
    bottom
    butane
    cargo-audit
    cargo-bloat
    cargo-cross
    cargo-expand
    cargo-fuzz
    cargo-msrv
    cargo-nextest
    cargo-outdated
    cargo-udeps
    cargo-whatfeatures
    cmake
    coreutils
    cowsay
    curl
    direnv
    exa
    fd
    fortune
    gfold
    git
    git-cliff
    gnumake
    gnused
    graphviz
    helix
    htop
    hugo
    iosevka
    jq
    kubeval
    kubie
    lolcat
    lua
    mold
    neovim
    nixfmt
    nixpacks
    nixpkgs-fmt
    nodejs-18_x
    onefetch
    overrides.pnpm
    postgresql
    protobuf
    ripgrep
    rust-analyzer
    rustup
    skopeo
    speedtest-cli
    starship
    tmux
    tokei
    tokio-console
    toml2json
    tree
    vim
    wget
    yamllint
    yq
    zellij
    zsh

    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  home.sessionVariables = { EDITOR = "nvim"; };

  programs.home-manager.enable = true;
}
