{
  description = "nickgerace/dotfiles";

  inputs = {
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };
    # nix-darwin = {
    #   url = "github:LnL7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixpkgs.url = "nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-unstable,
    # nix-darwin,
    home-manager,
    ghostty,
  }: {
    # nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
    #   system = "x86_64-linux";
    #   specialArgs = {
    #     pkgs-unstable = import nixpkgs-unstable {
    #       inherit system;
    #       config.allowUnfree = true;
    #     };
    #   };
    #   modules = [
    #     ./os/nixos/configuration.nix
    #     {
    #       environment.systemPackages = [
    #         ghostty.packages.x86_64-linux.default
    #       ];
    #     }
    #   ];
    # };

      homeConfigurations.nick = home-manager.lib.homeManagerConfiguration rec {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [ ./os/fedora/home.nix ];
      };
    # darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
    #   system = "aarch64-darwin";
    #   modules = [./os/nix-darwin/configuration.nix];
    # };
  };
}
