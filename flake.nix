{
  description = "nickgerace/dotfiles";

  inputs = {
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-pkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixos-pkgs,
    nixpkgs,
    nix-darwin,
  }: {
    nixosConfigurations.nixos = nixos-pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./os/nixos/configuration.nix];
    };

    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./os/nix-darwin/configuration.nix];
    };
  };
}
