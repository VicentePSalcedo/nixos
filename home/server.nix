{ pkgs, ... }:
{
  imports = [
    ./fastfetch
    ./nu
    ./starship
    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./helix.nix
  ];
  home.packages = with pkgs; [
    cron
  ];
  programs.yazi.enableNushellIntegration = true;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
