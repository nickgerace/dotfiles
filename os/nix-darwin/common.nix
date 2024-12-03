{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aspell
    bat
    cloc
    curl
    dua
    fastfetch
    fzf
    gfold
    git
    gnumake
    gnused
    helix
    htop
    jq
    ripgrep
    speedtest-cli
    tree
    wget

    # Shell
    bashInteractive
    zellij
    zoxide
    zsh

    # LSPs and formatters
    nodePackages.bash-language-server
    shfmt

    # Nix-related
    alejandra
    direnv
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
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
