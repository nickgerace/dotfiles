{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [./hardware-configuration.nix];

  environment.systemPackages = with pkgs-unstable; [
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
    lolcat
    mold
    nodejs
    nvtopPackages.full
    ripgrep
    shellcheck
    speedtest-cli
    tmux
    tree
    wget
    zellij
    zoxide
    zsh
  ];

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
  networking.networkmanager.enable = true;

  users.users.nick = {
    isNormalUser = true;
    description = "nick";
    extraGroups = ["docker" "wheel" "networkmanager"];
  };
  environment.variables.EDITOR = "hx";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.flatpak.enable = true;
  virtualisation.docker.enable = true;

  # NOTE(nick): this is system76-related software for the Thelio. If chipset fan(s) are loud, you
  # may need to adjust the "MOS_FAN" and/or "PCH_FAN" fan curves.
  services.power-profiles-daemon.enable = false;
  hardware.system76.enableAll = true;

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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  # NOTE(nick): this enables printing.
  # services.printing.enable = true;

  programs.dconf.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages =
    (with pkgs; [
      epiphany
      evince
      gedit
      gnome-text-editor
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      atomix
      cheese
      geary
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-terminal
      gnome-weather
      hitori
      iagno
      simple-scan
      tali
      totem
    ]);

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "24.05";
}
