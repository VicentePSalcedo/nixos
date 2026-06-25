{ pkgs, inputs, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "sintra" ];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "librewolf-151.0.2-1"
      "librewolf-unwrapped-151.0.2-1"
    ];
  };

  nixpkgs.overlays = [
    inputs.firefox-addons.overlays.default
  ];
}
