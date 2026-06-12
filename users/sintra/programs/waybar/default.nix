{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [];
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        "clock" = {
          format = "{:%I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
}
