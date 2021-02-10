{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "nick";
    homeDirectory = "/Users/nick";
    stateVersion = "21.03";
  };

  nixpkgs.config.allowUnfree = true;

  # Not in nixpkgs   | rke
  # No macOS support | kube3d
  # Optional         | nodejs parallel
  
  home.packages = with pkgs; [
    aspell
    awscli2
    azure-cli
    bash_5 # bash
    cowsay
    curl
    doctl
    fortune
    fzf
    git
    gnumake
    gnupg
    gnused
    go
    golangci-lint
    htop
    jq
    k9s
    kind
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
    terraform_0_14 # terraform
    tmux
    tree
    wget
    zsh
  ];
}
