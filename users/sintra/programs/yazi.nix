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
          { run = "firefox \"$@\""; block = false; desc = "Firefox"; }
        ];
      };
      open = {
        prepend_rules = [
          { mime = "application/pdf"; use = "pdf"; }
        ];
      };
    };
  };
}
