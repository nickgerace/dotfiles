{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "nick";
    homeDirectory = "/Users/nick";
    stateVersion = "21.03";
  };

  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    aspell
    bash_5 # bash
    cowsay
    curl
    doctl
    fortune
    fzf
    git
    gnumake
    gnused
    go
    golangci-lint
    htop
    jq
    k9s
    kubectl
    kubernetes-helm
    kustomize
    lolcat
    neofetch
    neovim
    ngrok # unfree
    pandoc
    python3
    ruby_2_7 # ruby
    rustup
    speedtest-cli
    tmux
    tree
    wget
    zsh
  ];
}
