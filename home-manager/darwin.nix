{ config, pkgs, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "23.05";
  home.sessionVariables = { EDITOR = "nvim"; };

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # cargo-watch
    # ferris-fetch
    # nushell
    # procs
    asciinema
    asciinema-agg
    aspell
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
    cloc
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
    go
    graphviz
    helix
    htop
    hugo
    iosevka
    jq
    just
    kube3d
    kubectl
    kubernetes-helm
    kubeval
    kubie
    libtool
    lolcat
    lua
    m4
    mold
    neovim
    nixfmt
    nixpacks
    nixpkgs-fmt
    nodejs-18_x
    nodePackages.pnpm
    onefetch
    postgresql
    protobuf
    ripgrep
    rust-analyzer
    rustup
    scc
    skopeo
    speedtest-cli
    starship
    terraform
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
    zstd

    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];
}
