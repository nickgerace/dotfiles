{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    aspell
    bashInteractive
    bat
    curl
    direnv
    fastfetch
    gfold
    gnumake
    gnused
    graphviz
    helix
    htop
    jq
    nodejs
    ripgrep
    speedtest-cli
    starship
    tree
    vscode-langservers-extracted
    wget
    zellij
    zoxide
    zsh
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["Iosevka"];
    })
  ];

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  nix = {
    useDaemon = true;
    settings.experimental-features = "nix-command flakes";
  };
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
