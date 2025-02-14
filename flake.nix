{
  description = "Sintra's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    {
      # I should figure out how to automate this part cause then I'd have my own distro I could share with others
      # or someone out there could do it for me, just shoot me an email to let me know: vicentepsalcedo@gmail.com
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
          ];
        };
      };
    };
}
