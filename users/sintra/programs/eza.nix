{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    git = true;
    icons = "auto";
  };
}
