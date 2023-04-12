{ config, pkgs, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    zsh
    htop
    bash
    automake
    gnumake
    gnused
    gfold
    nodejs-18_x
    nodePackages.pnpm
    rustup
    neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
