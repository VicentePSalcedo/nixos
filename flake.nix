{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # agenix.url = "github:ryantm/agenix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      # agenix,
      rust-overlay,
      ...
    }:
    {
      nixosConfigurations = {
        wraith = nixpkgs.lib.nixosSystem {
          system = "x86_64-link";
          modules = [
            ./wraith/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sintra = import ./home;
            }
            {
              _module.args = { inherit inputs; };
            }
            # agenix.nixosModules.default
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ rust-overlay.overlays.default ];
                environment.systemPackages = [
                  pkgs.rust-bin.stable.latest.default
                  pkgs.openssl
                ];
              }
            )
          ];
        };
      };
    };
}
