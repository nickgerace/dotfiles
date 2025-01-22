{
  config,
  lib,
  pkgs,
  ...
}: {
  # WARNING(nick): this adds compliance data collection. You will likely want to remove this if
  # using my configuration files!
  imports = [
    (import (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/systeminit/si-device-compliance/refs/heads/main/special-cases/compliance/si-nixos-configuration.nix";
      sha256 = "05idliz9v6sb4s1bwp85mzkwm3zbs1is2il2581xdrrn4kgxkr41";
    }))
  ];

  # We need this for SI's veritech to lang-js to deno flow that requires dynamic dependencies.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    gcc-unwrapped.lib
  ];
}
