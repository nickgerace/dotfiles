{
  description = "Nick Gerace's core flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # TODO(nick): add support for x86_64 linux as well.
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.${system} = home-manager.defaultPackage.${system};
      homeConfigurations = {
        "nick" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
