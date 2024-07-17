{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/New_York";
  networking.hostName = "nixos";

  users.users.nick = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "networkmanager" ];
  };
  environment.variables.EDITOR = "hx";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.flatpak.enable = true;
  services.power-profiles-daemon.enable = false;
  hardware.system76.enableAll = true;
  virtualisation.docker.enable = true;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "Iosevka" ]; }) ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  i18n.defaultLocale = "en_US.UTF-8";
  programs.dconf.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    cheese
    epiphany
    evince
    geary
    gedit
    gnome-calculator
    gnome-calendar
    gnome-terminal
    gnome-text-editor
    gnome-tour
    totem
  ]) ++ (with pkgs.gnome; [
    atomix
    gnome-characters
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    hitori
    iagno
    tali
  ]);

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # TODO(nick): use these instead of npm packages for helix
    # typescript
    # typescript-language-server
    # vue-language-server
    # nodePackages.prettier
    alacritty
    bat
    aspell
    bash-language-server
    cowsay
    graphviz
    gh
    fortune
    hugo
    lolcat
    mold
    shellcheck
    bash
    curl
    direnv
    eza
    fastfetch
    fd
    fzf
    gfold
    git
    gnumake
    gnused
    helix
    htop
    jq
    nixfmt-classic
    nodejs
    ripgrep
    speedtest-cli
    starship
    tmux
    tree
    wget
    zellij
    zoxide
    zsh
  ];

  system.stateVersion = "24.05";
}

