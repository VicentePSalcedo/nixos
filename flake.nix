{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      # agenix,
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
          ];
        };
      };
    };
}
