{ config, pkgs, osConfig, ... }:

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
        modules-right = if osConfig.networking.hostName == "wraith" then [ "battery" ] else [];
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        "clock" = {
          format = "{:%I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
          states = {
            warning = 30;
            critical = 15;
          };
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
}
