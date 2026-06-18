{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ./hyprland.conf;
}
