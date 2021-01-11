{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "nick";
    homeDirectory = "/Users/nick";
    stateVersion = "21.03";
  };
  
  home.packages = with pkgs; [
    aspell
    bash
    cowsay
    curl
    doctl
    fortune
    fzf
    git
    gnumake
    go
    htop
    jq
    k9s
    kubectl
    kubernetes-helm
    kustomize
    lolcat
    neofetch
    neovim
    pandoc
    python3
    rustup
    speedtest-cli
    tmux
    tree
    wget
  ];
}
