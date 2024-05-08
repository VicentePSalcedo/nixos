{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      wraith = nixpkgs.lib.nixosSystem {
        system = "x86_64-linx";
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
        ];
      };
      miata = nixpkgs.lib.nixosSystem {
        system = "x86_64-linx";
        modules = [
          ./miata/configuration.nix
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
    };
  };
}
