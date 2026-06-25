{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
  };
}
