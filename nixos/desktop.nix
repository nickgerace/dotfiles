{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };
  services.xserver.displayManager.gdm.wayland = true;

  networking.networkmanager.enable = true;

  # NOTE(nick): this is system76-related software for the Thelio. If chipset fan(s) are loud, you
  # may need to adjust the "MOS_FAN" and/or "PCH_FAN" fan curves.
  services.power-profiles-daemon.enable = false;
  hardware.system76.enableAll = true;

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
}
