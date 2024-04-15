{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      wraith = nixpkgs.lib.nixosSystem {
        system = "x86_64-linx";
	modules = [
	  ./configuration.nix
	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.sintra = import ./home;
      home-manager.extraSpecialArgs = { inherit nixpkgs; };
	  }
	  {
	    _module.args = { inherit inputs; };
	  }
  ];
      };
    };
  };
}
