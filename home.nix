{ config, pkgs, lib, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    direnv
    nix-prefetch
    nix-update
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
  ];
}
