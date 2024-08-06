{
  config,
  pkgs,
  ...
}: {
  home.username = "nick";
  home.homeDirectory = "/home/nick";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alejandra
    starship
    gfold
    zellij
    eza
    jq
    (nerdfonts.override {fonts = ["Iosevka"];})
  ];

  fonts.fontconfig.enable = true;
}
