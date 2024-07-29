{
  description = "nickgerace/dotfiles";

  inputs = {
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nix-darwin,
    ghostty,
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      modules = [
        ./os/nixos/configuration.nix
        {
          environment.systemPackages = [
            ghostty.packages.x86_64-linux.default
          ];
        }
      ];
    };

    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./os/nix-darwin/configuration.nix];
    };
  };
}
