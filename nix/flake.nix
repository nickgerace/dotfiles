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
    devShells = {
      default = {system}: let
        pkgs = import nixpkgs {inherit system;};
      in
        pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            bash
            just
            shfmt
          ];
          formatter = pkgs.alejandra;
        };
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      # NOTE(nick): slightly modified from restoring rev ad58ee20006ec585a5ccc0c2e867132d7698ed49 on 3 May 2026
      modules = [./nixos/server/configuration.nix];
    };

    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      # NOTE(nick): slightly modified from restoring rev ad58ee20006ec585a5ccc0c2e867132d7698ed49 on 3 May 2026
      modules = [./nix-darwin/darwin.nix];
    };

    darwinConfigurations.sibook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      # NOTE(nick): slightly modified from restoring rev ad58ee20006ec585a5ccc0c2e867132d7698ed49 on 3 May 2026
      modules = [./nix-darwin/sibook.nix];
    };
  };
}
