{
  description = "nickgerace/dotfiles";

  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs, ... }:
    let lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        # TODO(nick): rename to "thelio-major"
        nixos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./thelio-major/configuration.nix ];
        };
      };
    };
}
