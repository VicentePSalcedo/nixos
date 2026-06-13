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

  # Ensure just is installed system-wide on all hosts now and in the future
  environment.systemPackages = [ pkgs.just ];
}
