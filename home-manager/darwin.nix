{ config, pkgs, lib, ... }:

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

  home.activation.rustupUpdate = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    if [ "$(command -v rustup)" ]; then
        rustup update
    fi
  '';

  home.activation.upgradeAndCleanVimPlug = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    if [ "$(command -v nvim)" ] && [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    fi
  '';

  # Temporary measure: https://github.com/NixOS/nixpkgs/issues/226677
  home.activation.downloadAndReplaceBuck2 = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    TEMP_BUCK2=$(mktemp -d)

    wget "https://github.com/facebook/buck2/releases/download/latest/buck2-aarch64-apple-darwin.zst" -O $TEMP_BUCK2/buck2.zst
    zstd -d $TEMP_BUCK2/buck2.zst

    if [ ! -d $HOME/.local/bin ]; then
        mkdir -p $HOME/.local/bin
    elif [ -f $HOME/.local/bin/buck2 ]; then
        echo "[home.activation.buck2] current buck2 version..."
        $HOME/.local/bin/buck2 -V
        rm $HOME/.local/bin/buck2
    fi

    mv $TEMP_BUCK2/buck2 $HOME/.local/bin/buck2
    chmod +x $HOME/.local/bin/buck2

    echo "[home.activation.buck2] new buck2 version..."
    $HOME/.local/bin/buck2 -V
  '';
}
