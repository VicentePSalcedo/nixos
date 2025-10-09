{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # agenix.url = "github:ryantm/agenix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      # agenix,
      ...
    }@inputs:
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
        ghost = nixpkgs.lib.nixosSystem {
          system = "x86_64-link";
          modules = [
            ./ghost/configuration.nix
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
        pi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./pi/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sintra = import ./home/server.nix;
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
