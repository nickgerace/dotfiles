{
  description = "nickgerace/dotfiles";

  inputs = {
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [./os/nixos/server/configuration.nix];
    };

    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./os/nix-darwin/darwin.nix];
    };

    darwinConfigurations.sibook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./os/nix-darwin/sibook.nix];
    };
  };
}
