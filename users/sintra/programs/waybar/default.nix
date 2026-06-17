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
        modules-right = (if osConfig.networking.hostName == "wraith" then [ "bluetooth" "battery" ] else []) ++ [ "cpu" "memory" "pulseaudio" "custom/spacer" "tray" ];
        "tray" = {
          "spacing" = 10;
          "icon-size" = 16;
        };
        # Added a dummy module to create spacing between the right modules and the tray
        "custom/spacer" = {
          "format" = " ";
        };
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "battery" = {
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
          states = {
            warning = 30;
            critical = 15;
          };
        };
        "bluetooth" = {
          "format" = " {status}";
          "format-connected" = " {device_alias}";
          "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
          "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
          "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon}";
          "format-muted" = "";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "on-click-right" = "pulsemixer";
          "on-scroll-up" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+";
          "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
          "tooltip-format" = "{volume}%  {desc}";
        };
        "cpu" = {
          "format" = " {usage}%";
          "tooltip-format" = "CPU {usage}%";
          "on-click" = "ghostty -e btm";
        };
        "memory" = {
          "format" = " {used:0.1f}G";
          "tooltip-format" = "RAM {used:0.1f}G / {total:0.1f}G ({percentage}%)";
          "on-click" = "ghostty -e btm";
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
}
