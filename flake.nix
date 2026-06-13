{
  description = "Sintra's Workstation Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, hermes-agent, home-manager, sops-nix, antigravity-nix, ... }@inputs: {
    nixosConfigurations.phantom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        sops-nix.nixosModules.sops
        hermes-agent.nixosModules.default
        home-manager.nixosModules.home-manager
        ./hosts/phantom
      ];
    };

    nixosConfigurations.wraith = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        sops-nix.nixosModules.sops
        hermes-agent.nixosModules.default
        home-manager.nixosModules.home-manager
        ./hosts/wraith
      ];
    };

    nixosConfigurations.ghost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        sops-nix.nixosModules.sops
        hermes-agent.nixosModules.default
        home-manager.nixosModules.home-manager
        ./hosts/ghost
      ];
    };

    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        sops-nix.nixosModules.sops
        hermes-agent.nixosModules.default
        home-manager.nixosModules.home-manager
        ./hosts/pi
      ];
    };
  };
}
