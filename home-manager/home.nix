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
    asciinema
    asciinema-agg
    automake
    awscli2
    bash
    bat
    butane
    cmake
    coreutils
    cowsay
    curl
    direnv
    exa
    fortune
    gfold
    git
    gnumake
    gnused
    graphviz
    helix
    htop
    hugo
    iosevka
    kubeval
    lolcat
    lua
    mold
    neovim
    nixfmt
    nixpkgs-fmt
    nodejs-18_x
    overrides.pnpm
    postgresql
    protobuf
    rust-analyzer
    rustup
    skopeo
    speedtest-cli
    tmux
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
