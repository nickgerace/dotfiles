{
  description = "nickgerace/dotfiles";

  inputs = {
    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    # determinate-nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.0";
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    nix-flatpak,
    ghostty,
    nixos-cosmic,
    # determinate,
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        # determinate.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        {
          nix.settings = {
            substituters = ["https://cosmic.cachix.org/"];
            trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
          };
        }
        nixos-cosmic.nixosModules.default
        ./nixos/configuration.nix
        {
          environment.systemPackages = [
            ghostty.packages.x86_64-linux.default
          ];
        }
      ];
    };

    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./nix-darwin/configuration.nix];
    };
  };
}
