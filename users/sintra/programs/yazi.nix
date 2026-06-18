{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      opener = {
        edit = [
          { run = "hx \"$@\""; block = true; desc = "Helix"; }
        ];
        pdf = [
          { run = "librewolf \"$@\""; block = false; desc = "LibreWolf"; }
        ];
      };
    };
  };
}
