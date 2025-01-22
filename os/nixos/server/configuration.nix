{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./si.nix
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
    bottom
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
    jujutsu
    just
    lolcat
    mold
    nodejs
    ripgrep
    shellcheck
    speedtest-cli
    tmux
    tree
    wget
    zellij
    zoxide
    zsh

    # Enable if GPU-monitoring is desired.
    # nvtopPackages.full
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
  # TODO(nick): switch back once the following issue is resolved: https://github.com/pop-os/system76-dkms/issues/70
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  powerManagement.resumeCommands = ''
    echo "resuming..."
  '';

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.enable = false;
    firewall = {
      enable = true;
      interfaces."tailscale0".allowedTCPPorts = [
        22 # ssh
        8080 # SI UI
        5157 # local SI module index
        10350 # TILT UI
      ];
    };
  };
  services.tailscale.enable = true;
  services.openssh.enable = true;

  # TODO(nick): try to disable this eventually to see if it works again.
  # Source: https://discourse.nixos.org/t/nixos-rebuild-switch-upgrade-networkmanager-wait-online-service-failure/30746
  systemd.services.NetworkManager-wait-online.enable = false;

  users.users.nick = {
    isNormalUser = true;
    description = "nick";
    extraGroups = ["docker" "wheel" "networkmanager"];
  };
  environment.variables.EDITOR = "hx";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;

  # This is system76-related software for the Thelio. If chipset fan(s) are loud, you may need to
  # adjust the "MOS_FAN" and/or "PCH_FAN" fan curves.
  hardware.system76.enableAll = true;

  time.timeZone = "America/New_York";
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
