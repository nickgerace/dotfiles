{ config, pkgs, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/home/nick";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    aspell
    bash
    bat
    bottom
    cloc
    cowsay
    curl
    direnv
    eza
    fastfetch
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
    htop
    hugo
    jq
    lolcat
    mold
    neovim
    onefetch
    ripgrep
    scc
    speedtest-cli
    starship
    tmux
    tree
    vim
    wget
    yamllint
    yq
    zoxide
    zsh
  ];
}
