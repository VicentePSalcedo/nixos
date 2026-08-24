{ config, pkgs, ... }:

{
  home.packages = [ pkgs.hyprlock ];
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
  xdg.configFile."hypr/autostart.lua".source = ./autostart.lua;
  xdg.configFile."hypr/rules.lua".source = ./rules.lua;
  xdg.configFile."hypr/keybinds.lua".source = ./keybinds.lua;
  xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
  xdg.configFile."hypr/toggle-wallpaper.sh".source = ./toggle-wallpaper.sh;
}
