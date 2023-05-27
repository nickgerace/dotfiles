{ config, pkgs, lib, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    # Enable as needed.
    # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

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
    fzf
    gfold
    gh
    git
    git-cliff
    gnumake
    gnused
    go
    graphviz
    helix
    htop
    hugo
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
    nix-prefetch
    nix-update
    nixfmt
    nixpacks
    nixpkgs-fmt
    nodejs-18_x
    nodePackages.pnpm
    onefetch
    pkg-config
    postgresql
    protobuf
    ripgrep
    rustup
    scc
    shfmt
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
    zoxide
    zsh
    zstd

    # Currently managed by homebrew.
    # iosevka
    # (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  home.activation.rustup = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    if [ "$(command -v rustup)" ]; then
        rustup update
    fi
  '';

  home.activation.neovim = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    if [ "$(command -v nvim)" ] && [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        nvim --headless +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi
  '';

  home.activation.brew = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="/opt/homebrew/bin:${config.home.path}/bin:$PATH"
    brew update
    brew upgrade
    brew cleanup
  '';
}
