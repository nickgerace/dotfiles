{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Base
    curl
    git
    helix
    wget

    # LSPs and formatters
    alejandra
    nodePackages.bash-language-server
    nodejs
    vscode-langservers-extracted

    # Shell
    bashInteractive
    zellij
    zoxide
    zsh

    # Tools
    bat
    fzf
    gnumake
    gnused
    jq
    ripgrep
    tree

    # Essential TUIs
    fastfetch
    gfold
    htop
    speedtest-cli

    # Extra TUIs
    dua

    # SI
    direnv
    graphviz

    # Misc
    aspell
    cloc
    hugo
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
