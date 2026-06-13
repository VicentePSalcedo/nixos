{ pkgs, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "sintra" ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
