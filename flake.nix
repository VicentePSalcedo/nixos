{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  {
    nixosConfigurations = {
      ghost = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linx";
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
        ];
      };
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
            _module.args = { inherit inputs; } ;
          }
        ];
      };
    };
  };
}

