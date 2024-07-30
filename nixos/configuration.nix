{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./cosmic.nix
  ];

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.google.Chrome"
    "com.slack.Slack"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
    "us.zoom.Zoom"
  ];

  environment.systemPackages = with pkgs; [
    # TODO(nick): use these instead of npm packages for helix
    # typescript
    # typescript-language-server
    # vue-language-server
    # nodePackages.prettier
    alejandra
    aspell
    bash
    bash-language-server
    bat
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
    gnumake
    gnused
    graphviz
    helix
    htop
    hugo
    jq
    just
    lolcat
    mold
    nixd
    nodejs
    nvtopPackages.full
    ripgrep
    shellcheck
    shfmt
    speedtest-cli
    starship
    tmux
    tree
    wget
    zellij
    zoxide
    zsh
  ];
  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["Iosevka"];})];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = ["nix-command" "flakes"];
  };
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/New_York";
  networking.hostName = "nixos";

  users.users.nick = {
    isNormalUser = true;
    description = "nick";
    extraGroups = ["docker" "wheel" "networkmanager"];
  };
  environment.variables.EDITOR = "hx";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "24.05";
}
