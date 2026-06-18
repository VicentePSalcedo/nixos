{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.lua".text = builtins.readFile ./hyprland.lua;
}
