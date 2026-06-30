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
          { run = "zen \"$@\""; block = false; desc = "Zen Browser"; }
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
